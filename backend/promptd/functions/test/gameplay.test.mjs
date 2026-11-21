import { test } from 'node:test';
import assert from 'node:assert/strict';
import { GameplayPrompts } from '../src/gameplay.mjs';
class Store {
  data = new Map();
  async transact(keys, action) {
    const out = action(keys.map(k => structuredClone(this.data.get(k) ?? null)));
    out.writes?.forEach((v,i) => this.data.set(keys[i], structuredClone(v)));
    return structuredClone(out.result);
  }
}
const session = () => ({ profile: { contractVersion:1, groupTypes:['close_friends'], groupNote:'', styleLevel:'bold', moreOf:['funny'], moreOfNote:'', lessOf:[], lessOfNote:'',groupDescription:'Friends playing together.' }, effective:{personal:1,energy:2,intensity:2,novelty:2},feedback:[{text:'Preview',accepted:true}],history:['Preview'],prompts:[{text:'Preview'}] });
const input = (n=4,r=3) => ({gameId:'game',playerIds:Array.from({length:n},(_,i)=>`p${i}`),rounds:r,session:session()});
function setup() {
  const contexts=[];
  const generator={async generateValidated(s,n){contexts.push(structuredClone(s));return {texts:Array.from({length:n},(_,i)=>`Round ${contexts.length} idea ${i}`),metadata:{latencyMs:1}};}};
  const store=new Store();const worker=new GameplayPrompts({store,generator});return {worker,store,generator,contexts};
}
test('IA: every supported player/round count prepares Round 1 first and stops at the exact total',async()=>{
 for(const n of [4,6,8]) for(let rounds=1;rounds<=5;rounds++) {
  const {worker,contexts}=setup();await worker.start(input(n,rounds));assert.equal(contexts.length,0);
  let job=await worker.prepareNext('game');assert.equal(job.ready.length,1);assert.equal(job.ready[0].prompts.length,n/2);
  while(job.status!=='complete')job=await worker.prepareNext('game');
  assert.equal(job.ready.flatMap(r=>r.prompts).length,n/2*rounds);
  await worker.prepareNext('game');assert.equal(contexts.length,rounds);
 }
});
test('IA: preview/feedback and all earlier prompts reach later generation; duplicate Start cannot reset work',async()=>{
 const {worker,contexts}=setup();await worker.start(input());const first=await worker.prepareNext('game');
 await worker.start(input());await worker.prepareNext('game');
 assert.ok(contexts[1].history.includes('Preview'));assert.ok(contexts[1].history.includes(first.ready[0].prompts[0].text));
 assert.equal(contexts[1].feedback[0].accepted,true);
 await assert.rejects(worker.start({...input(),rounds:5}),{code:'failed-precondition'});
});
test('IA: worker restart resumes saved rounds and failures do not erase reviewed prompts',async()=>{
 const {worker,store,generator}=setup();await worker.start(input());const first=await worker.prepareNext('game');
 const resumed=new GameplayPrompts({store,generator});const original=generator.generateValidated;
 generator.generateValidated=async()=>{throw Error('offline');};
 for(let i=0;i<3;i++)await assert.rejects(resumed.prepareNext('game'));
 assert.deepEqual((await resumed.read('game')).ready,first.ready);
 await assert.rejects(resumed.prepareNext('game'),{code:'failed-precondition'});
 generator.generateValidated=original;
 await resumed.retry('game');const next=await resumed.prepareNext('game');
 assert.deepEqual(next.ready[0],first.ready[0]);assert.equal(next.ready.length,2);
});
test('IA: competing workers cannot duplicate the active round',async()=>{
 const {worker,generator}=setup();await worker.start(input());let release;
 generator.generateValidated=()=>new Promise(resolve=>{release=resolve;});
 const active=worker.prepareNext('game');await new Promise(resolve=>setImmediate(resolve));
 await assert.rejects(worker.prepareNext('game'),{code:'aborted'});
 release({texts:['one','two'],metadata:{}});await active;
});
test('IA: reject odd rosters, duplicate players and invalid round counts',async()=>{
 const {worker}=setup();
 for(const bad of [input(5),input(7),input(4,0),input(4,6),{...input(),playerIds:['p','p','q','r']}])await assert.rejects(worker.start(bad),{code:'invalid-argument'});
});


test('IA: an expired worker cannot overwrite a replacement worker result',async()=>{
 let now=0;const store=new Store();let release;
 const old=new GameplayPrompts({store,clock:()=>now,generator:{generateValidated:()=>new Promise(resolve=>{release=resolve;})}});
 await old.start(input());const pending=old.prepareNext('game');await new Promise(resolve=>setImmediate(resolve));
 now=120001;
 const replacement=new GameplayPrompts({store,clock:()=>now,generator:{generateValidated:async()=>({texts:['new one','new two'],metadata:{}})}});
 await replacement.prepareNext('game');release({texts:['stale one','stale two'],metadata:{}});
 await assert.rejects(pending,{code:'aborted'});
 assert.equal((await replacement.read('game')).ready[0].prompts[0].text,'new one');
});

test('IA: saved round survives closing and reopening the local database',async()=>{
 const { LocalStore } = await import('../host/local-store.mjs');
 const { mkdtempSync, rmSync } = await import('node:fs');
 const { tmpdir } = await import('node:os');
 const { join } = await import('node:path');
 const dir=mkdtempSync(join(tmpdir(),'promptd-gameplay-'));
 let store;
 try {
  store=new LocalStore(join(dir,'game.sqlite'));
  const generator={generateValidated:async(s,n)=>({texts:Array.from({length:n},(_,i)=>`Saved prompt ${s.history.length}-${i}`),metadata:{}})};
  let worker=new GameplayPrompts({store,generator});await worker.start(input());
  const first=await worker.prepareNext('game');store.close();
  store=new LocalStore(join(dir,'game.sqlite'));worker=new GameplayPrompts({store,generator});
  const next=await worker.prepareNext('game');assert.deepEqual(next.ready[0],first.ready[0]);assert.equal(next.ready.length,2);
 } finally {store?.close();rmSync(dir,{recursive:true,force:true});}
});
