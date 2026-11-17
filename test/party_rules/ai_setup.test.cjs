// IA: Synthetic demo data only. Verify the additive shared AI summary permissions.
const {test,before,after,beforeEach}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const {initializeTestEnvironment,assertSucceeds,assertFails}=require('@firebase/rules-unit-testing');
const {doc,setDoc,getDoc,updateDoc,writeBatch,serverTimestamp}=require('firebase/firestore');
let env;
const game={id:'promptd',rounds:3,requiredCards:7,mixCards:false,safeMode:true};
const member={name:'Test',characterId:null,cardCount:0,selectionRevision:-1,ready:false};
const party={hostId:'host',memberIds:['host','member'],members:{host:member,member},phase:'lobby',revision:0,game:null};
const ref=db=>doc(db,'parties/123456');
const setup=db=>doc(db,'parties/123456/aiSetup/current');
const db=uid=>env.authenticatedContext(uid).firestore();
const data=(uid='host')=>({schemaVersion:1,revision:1,sessionId:'session_1234567890',savedBy:uid,updatedAt:serverTimestamp(),
 settings:{groups:['Friends'],customGroups:[],description:'',topics:['Memes'],customTopics:[],style:'bold',averageAge:null,safeMode:true,rounds:3,mixCards:false},
 prompts:Array.from({length:5},(_,i)=>({id:'prompt_1234567890_'+i,text:'An approved example prompt '+i,topics:['Memes']}))});
before(async()=>{env=await initializeTestEnvironment({projectId:'demo-ai-summary-rules',firestore:{host:'127.0.0.1',port:8085,rules:fs.readFileSync(process.env.PARTY_RULES_FILE,'utf8')}})});
after(async()=>env?.cleanup());
beforeEach(async()=>{await env.clearFirestore();await env.withSecurityRulesDisabled(async c=>setDoc(ref(c.firestore()),{...party,createdAt:new Date(),updatedAt:new Date()}))});
async function save(uid='host',payload=data(uid)){const c=db(uid),b=writeBatch(c);b.update(ref(c),{game,revision:1,updatedAt:serverTimestamp()});b.set(setup(c),payload);return b.commit()}
test('host atomically saves settings and all five; a fresh member client restores them',async()=>{
 await assertSucceeds(save());const snapshot=await assertSucceeds(getDoc(setup(db('member'))));
 assert.equal(snapshot.data().prompts.length,5);assert.deepEqual(snapshot.data().prompts[0].topics,['Memes']);
 assert.equal(snapshot.data().revision,(await getDoc(ref(db('host')))).data().revision);
});
test('nonhost cannot save and outsider cannot read',async()=>{await assertFails(save('member'));await save();await assertFails(getDoc(setup(db('outsider'))))});
test('anonymous cannot read',async()=>{await save();await assertFails(getDoc(setup(env.unauthenticatedContext().firestore())))});
test('removed member loses access',async()=>{await save();await env.withSecurityRulesDisabled(async c=>updateDoc(ref(c.firestore()),{memberIds:['host']}));await assertFails(getDoc(setup(db('member'))))});
test('closed party cannot be read or written',async()=>{await save();await env.withSecurityRulesDisabled(async c=>updateDoc(ref(c.firestore()),{phase:'closed'}));await assertFails(getDoc(setup(db('host'))));await assertFails(setDoc(setup(db('host')),data()))});
test('playing party cannot overwrite examples',async()=>{await save();await env.withSecurityRulesDisabled(async c=>updateDoc(ref(c.firestore()),{phase:'playing'}));await assertFails(setDoc(setup(db('host')),data()))});
test('host transfer revokes old host writes and permits current host',async()=>{await save();await env.withSecurityRulesDisabled(async c=>updateDoc(ref(c.firestore()),{hostId:'member'}));await assertFails(setDoc(setup(db('host')),data()));await assertSucceeds(setDoc(setup(db('member')),data('member')))});
test('stale summary revision is rejected',async()=>{await assertFails(save('host',{...data(),revision:0}))});
test('failed summary rolls game settings back',async()=>{const d=data();d.settings.safeMode=false;await assertFails(save('host',d));assert.equal((await getDoc(ref(db('host')))).data().game,null)});
test('exactly five distinct prompt IDs required',async()=>{const d=data();d.prompts.pop();await assertFails(save('host',d));const duplicate=data();duplicate.prompts[4]=duplicate.prompts[0];await assertFails(save('host',duplicate))});
test('extra fields and forged writer rejected',async()=>{await assertFails(save('host',{...data(),secret:'unexpected'}));await assertFails(save('host',data('member')))});
test('changed settings make old summary visibly stale until resaved',async()=>{await save();await env.withSecurityRulesDisabled(async c=>updateDoc(ref(c.firestore()),{revision:2,game:{...game,rounds:4}}));const old=await getDoc(setup(db('member')));assert.equal(old.data().revision,1);await assertFails(setDoc(setup(db('host')),data()))});
