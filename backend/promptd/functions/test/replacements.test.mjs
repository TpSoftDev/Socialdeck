import {test} from 'node:test';
import assert from 'node:assert/strict';
import {randomUUID} from 'node:crypto';
import {PromptService} from '../src/service.mjs';
import {PromptError} from '../src/errors.mjs';
import {StructuredPromptProvider} from '../src/structured-provider.mjs';
class Store {records=new Map();async transact(keys,fn){const {result,writes}=fn(keys.map(k=>structuredClone(this.records.get(k)??null)));writes?.forEach((v,i)=>this.records.set(keys[i],structuredClone(v)));return structuredClone(result);}}
const batches=[['A photo of a sunny beach with shells.','A photo of a cake worth sharing.','A photo of shoes covered in garden mud.','A photo of a suitcase packed for adventure.','A photo of a dog asleep on the sofa.'],['A photo of a board game filling the table.','A photo of a bright umbrella in the rain.'],['A photo of a library shelf overflowing with books.']];
const profile={contractVersion:1,groupTypes:['close_friends'],groupNote:'Friends playing board games.',styleLevel:'bold',moreOf:[],moreOfNote:'',lessOf:[],lessOfNote:'',groupDescription:''};
test('two rejected then one rejected preserves accepted cards, history and replay; failure remains retryable',async()=>{
 let now=100000, call=0, outage=false; const contexts=[];
 const service=new PromptService({store:new Store(),clock:()=>now,provider:{model:'test',generate:async c=>{if(outage)throw new PromptError('provider-unavailable','test outage');contexts.push(c);return batches[call++];},review:async()=>true}});
 let s=await service.generate('u',{contractVersion:1,requestId:randomUUID(),mode:'examples',count:5,profile});const original=structuredClone(s.prompts);
 const vote=async(p,accepted)=>{s=await service.feedback('u',{contractVersion:1,requestId:randomUUID(),sessionId:s.id,promptId:p.id,accepted,reasons:accepted?[]:['too_generic'],explanation:accepted?'':'More board game humor.'});};
 const next=()=>({contractVersion:1,requestId:randomUUID(),sessionId:s.id,count:5,replaceRejected:true});
 for(let i=0;i<5;i++)await vote(original[i],i<3);
 now+=3000;let req=next();s=await service.generate('u',req,true);assert.equal(contexts[1].count,2);assert.equal(contexts[1].feedback.length,5);assert.deepEqual(s.prompts.slice(0,3),original.slice(0,3));assert.deepEqual(await service.generate('u',req,true),s);
 await vote(s.prompts[3],true);await vote(s.prompts[4],false);const kept=structuredClone(s.prompts.slice(0,4));
 now+=3000;req=next();outage=true;await assert.rejects(service.generate('u',req,true));outage=false;now+=3000;s=await service.generate('u',req,true);
 assert.equal(contexts[2].count,1);assert.equal(contexts[2].feedback.length,7);assert.equal(contexts[2].previousPrompts.length,7);assert.deepEqual(s.prompts.slice(0,4),kept);assert.equal(s.prompts.length,5);
 await vote(s.prompts[4],true);assert.equal(s.prompts.filter(p=>s.feedback.some(f=>f.promptId===p.id&&f.accepted)).length,5);
 now+=3000;await assert.rejects(service.generate('u',next(),true),e=>e.code==='failed-precondition');
});
test('provider generation and review schemas request exactly one or two replacement cards',async()=>{
 for(const count of [1,2]){const p=new StructuredPromptProvider();p.request=async(_instructions,context,schema)=>{
 if(schema.properties.prompts){assert.equal(schema.properties.prompts.minItems,count);assert.equal(schema.properties.angles.maxItems,count);return {prompts:batches[0].slice(0,count)};}
 assert.equal(schema.properties.checks.maxItems,count);assert.equal(schema.properties.checks.items.properties.index.maximum,count-1);
 return {checks:context.prompts.map((_,index)=>({index,premise:'photo',comparison:'',issues:[],detail:''})),batchIssues:[],batchDetail:''};};
 const prompts=await p.generate({count});assert.equal(prompts.length,count);assert.equal((await p.review({count},prompts)).approved,true);}
});

// IA: Custom Other names must survive initial generation, replacement and feedback saves.
test('custom topic names survive replacements and approved cards keep their tags',async()=>{
 let now=100000,call=0;const contexts=[];
 const service=new PromptService({store:new Store(),clock:()=>now,provider:{model:'test',
 generate:async c=>{contexts.push(c);return call++===0?batches[0]:[batches[1][0]];},
 review:async(c,texts)=>({approved:true,topicTags:texts.map(()=>['Campus life'])})}});
 let s=await service.generate('u',{contractVersion:1,requestId:randomUUID(),mode:'examples',count:5,
 profile:{...profile,moreOfNote:'Campus life',topicLabels:['Campus life']}});
 const kept=structuredClone(s.prompts.slice(0,4));
 for(let i=0;i<5;i++)s=await service.feedback('u',{contractVersion:1,requestId:randomUUID(),sessionId:s.id,
 promptId:s.prompts[i].id,accepted:i<4,reasons:i<4?[]:['too_generic'],explanation:''});
 now+=3000;s=await service.generate('u',{contractVersion:1,requestId:randomUUID(),sessionId:s.id,count:5,replaceRejected:true},true);
 assert.deepEqual(contexts[1].profile.topicLabels,['Campus life']);
 assert.deepEqual(s.prompts.slice(0,4),kept);assert.deepEqual(s.prompts[4].topics,['Campus life']);
 s=await service.feedback('u',{contractVersion:1,requestId:randomUUID(),sessionId:s.id,promptId:s.prompts[4].id,accepted:true,reasons:[],explanation:''});
 assert.ok(s.prompts.every(p=>p.topics[0]==='Campus life'));
});
