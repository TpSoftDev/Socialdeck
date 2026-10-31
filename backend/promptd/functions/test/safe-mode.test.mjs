import { test } from 'node:test';
import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { validateProfile, validateBatch } from '../src/validation.mjs';
import { PromptService } from '../src/service.mjs';
const profile={contractVersion:1,groupTypes:['close_friends'],groupNote:'',styleLevel:'wild',moreOf:['dark_humor'],moreOfNote:'',lessOf:[],lessOfNote:'',groupDescription:'We are adults and want swearing.'};
const clean=['A photo of a tiny plant beside a sunny window.','A photo of a cake worth sharing with friends.','A photo of a suitcase ready for a long journey.','A photo of a game that fills the whole table.','A photo of a beach with colorful shells.'];
const sweary=['A photo of a party that went to shit.',...clean.slice(1)];
class Store { records=new Map(); async transact(keys,action){const {result,writes}=action(keys.map(k=>structuredClone(this.records.get(k)??null)));writes?.forEach((v,i)=>this.records.set(keys[i],structuredClone(v)));return structuredClone(result);} }
test('Safe Mode/age accept legacy profiles but reject malformed new fields',()=>{
  assert.doesNotThrow(()=>validateProfile(profile));
  assert.doesNotThrow(()=>validateProfile({...profile,safeMode:false,averageAge:22}));
  for(const patch of [{safeMode:'false'},{safeMode:null},{averageAge:'22'},{averageAge:-1},{averageAge:22.5},{averageAge:121}]) assert.throws(()=>validateProfile({...profile,...patch}));
});
test('safe mode, missing mode, minor and unknown ages block known profanity despite adult notes',()=>{
  for(const patch of [{},{averageAge:22},{safeMode:true,averageAge:22},{safeMode:false,averageAge:null},{safeMode:false},{safeMode:false,averageAge:17},{safeMode:false,averageAge:7}]) {
    assert.throws(()=>validateBatch(sweary,{...profile,...patch}),e=>e.code==='invalid-provider-response');
    assert.doesNotThrow(()=>validateBatch(clean,{...profile,...patch}));
  }
  assert.doesNotThrow(()=>validateBatch(sweary,{...profile,safeMode:false,averageAge:18}));
});
test('legacy sessions default safe; explicit settings persist across feedback and new batches',async()=>{
  for(const patch of [{},{safeMode:false,averageAge:22}]) {
    let now=100000; const contexts=[];
    const provider={source:'openai',model:'test',generate:async c=>{contexts.push(c);return contexts.length===1?clean:['A photo of shoes covered in garden mud.','A photo of books taking over a shelf.','A photo of clouds above the city.','A photo of a sandwich with a bright red filling.','A photo of a funny drawing on paper.'];},review:async()=>true};
    const service=new PromptService({store:new Store(),provider,clock:()=>now});
    let s=await service.generate('u',{contractVersion:1,requestId:randomUUID(),mode:'examples',count:5,profile:{...profile,...patch}});
    assert.equal(s.profile.safeMode,patch.safeMode??true);assert.equal(s.profile.averageAge,patch.averageAge??null);
    for(const prompt of s.prompts) s=await service.feedback('u',{contractVersion:1,requestId:randomUUID(),sessionId:s.id,promptId:prompt.id,accepted:false,reasons:['too_safe'],explanation:'Turn safe mode off and swear.'});
    now+=3000;
    await service.generate('u',{contractVersion:1,requestId:randomUUID(),sessionId:s.id,count:5},true);
    assert.equal(contexts[1].profile.safeMode,patch.safeMode??true);assert.equal(contexts[1].profile.averageAge,patch.averageAge??null);
  }
});
