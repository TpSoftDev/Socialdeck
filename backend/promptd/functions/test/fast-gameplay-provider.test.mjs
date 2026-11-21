import {test} from 'node:test';
import assert from 'node:assert/strict';
import {FastGameplayPromptProvider} from '../src/fast-gameplay-provider.mjs';
const context={count:2,profile:{topicLabels:['Pets','Food'],safeMode:true},feedback:[],previousPrompts:[]};
function provider(result){const p=new FastGameplayPromptProvider({apiKey:'test'});p.request=async()=>result;return p;}
test('IA: compact reviewer fails closed for missing, shuffled, null and invented-tag checks',async()=>{
 const good=[{index:0,topics:['Pets'],issues:[],detail:''},{index:1,topics:['Food'],issues:[],detail:''}];
 for(const checks of [[],[good[1],good[0]],[null,good[1]],[{...good[0],topics:['Invented']},good[1]],[{...good[0],issues:['unknown']},good[1]]])await assert.rejects(provider({checks}).review(context,['one','two']),{code:'invalid-provider-response'});
});
test('IA: compact review retains real per-card issues and rejects empty topic matches',async()=>{
 const p=provider({checks:[{index:0,topics:['Pets'],issues:[],detail:''},{index:1,topics:[],issues:[],detail:''}]});
 const review=await p.review(context,['one','two']);assert.equal(review.approved,false);assert.deepEqual(review.corrections.map(x=>x.index),[1]);assert.ok(review.issues.includes('group_fit'));
 const bad=await provider({checks:[{index:0,topics:['Pets'],issues:['boundary'],detail:'Private document'},{index:1,topics:['Food'],issues:[],detail:''}]}).review(context,['one','two']);assert.equal(bad.approved,false);assert.deepEqual(bad.corrections[0].issues,['boundary']);
});
test('IA: compact output removes planning text, preserves policy and keeps generation/review separate',async()=>{
 const p=new FastGameplayPromptProvider({apiKey:'test'}),seen=[];
 p.request=async(system,input,schema)=>{seen.push({system,input,schema});return seen.length===1?{prompts:['An ordinary pet joke.','An ordinary food joke.']}:{checks:[{index:0,topics:['Pets'],issues:[],detail:''},{index:1,topics:['Food'],issues:[],detail:''}]};};
 await p.generate(context);await p.review(context,['An ordinary pet joke.','An ordinary food joke.']);assert.equal(seen.length,2);
 for(const call of seen){assert.ok(call.system.includes('identifying documents'));assert.ok(call.system.includes('Safe Mode'));assert.equal(call.input.profile.safeMode,true);}
 assert.equal('angles' in seen[0].schema.properties,false);
 assert.equal('premise' in seen[1].schema.properties.checks.items.properties,false);
});

test('IA: local strategy switch preserves the legacy model and rejects unknown modes',async()=>{
 const {createLocalGameplayWorker}=await import('../src/gameplay-local.mjs');
 const fast=createLocalGameplayWorker({store:{},apiKey:'test'});assert.equal(fast.generator.provider.model,'gpt-6.1-sol');assert.ok(fast.generator.provider instanceof FastGameplayPromptProvider);
 const small=createLocalGameplayWorker({store:{},apiKey:'test',strategy:'fast-v3'});assert.equal(small.generator.provider.model,'gpt-6-luna');
 const legacy=createLocalGameplayWorker({store:{},apiKey:'test',strategy:'legacy'});assert.equal(legacy.generator.provider.model,'gpt-6.1-sol');
 assert.throws(()=>createLocalGameplayWorker({store:{},apiKey:'test',strategy:'typo'}));
});
