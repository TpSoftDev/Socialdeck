// IA: Explicit paid live benchmark. Synthetic profiles only; no production Firebase writes.
// Usage: node scripts/benchmark-gameplay.mjs <secret-file> <output-directory>
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { resolve } from 'node:path';
import { randomUUID } from 'node:crypto';
import { OpenAIPromptProvider } from '../src/openai.mjs';
import { FastGameplayPromptProvider } from '../src/fast-gameplay-provider.mjs';
import { PromptService } from '../src/service.mjs';
import { GameplayPrompts } from '../src/gameplay.mjs';
import { LocalStore } from '../host/local-store.mjs';
import config from '../shared/config.json' with { type: 'json' };
const [secretPath,outputPath,mode] = process.argv.slice(2);
if(!secretPath || !outputPath) throw Error('Provide secret-file and output-directory paths. Never pass a key on the command line.');
const secret=readFileSync(secretPath,'utf8');
const line=secret.split(/\r?\n/).find(l=>/^OPENAI_API_KEY=/.test(l));
if(!line)throw Error('Local test key unavailable');
const apiKey=line.slice(line.indexOf('=')+1).trim().replace(/^['"]|['"]$/g,'');
const out=resolve(outputPath);mkdirSync(out,{recursive:true});
const scenarios=[
 {players:4,rounds:1,name:'Family / Light',style:'light',safe:true,age:14,groups:['family'],topics:['Pets','Food'],description:'Family with teenagers. Everyday photos, warm humor, no embarrassing personal questions.'},
 {players:6,rounds:2,name:'Friends / Bold',style:'bold',safe:true,age:24,groups:['close_friends'],topics:['Food','Weekend Trips','Pets'],description:'Friends who enjoy snacks, pets and short trips. Simple witty captions.'},
 {players:8,rounds:3,name:'College / Wild',style:'wild',safe:false,age:22,groups:['classmates'],topics:['College','Group Chat','Parties'],description:'Adult college friends; playful roasts and campus life. Easy to match ordinary phone photos.'},
 {players:4,rounds:4,name:'Coworkers / Light',style:'light',safe:true,age:30,groups:['coworkers'],topics:['Coffee','Work From Home','Lunch'],description:'Friendly colleagues playing after work. No personal humiliation or job-risk jokes.'},
 {players:8,rounds:5,name:'Friends / Bold / Custom topic',style:'bold',safe:true,age:25,groups:['close_friends'],topics:['Road Trips','Cooking Disasters','Our Dog Milo'],description:'Friends who travel and cook together. Milo is our dog. Other pet pictures can fit; do not require a specific photo of Milo.'},
];
if(mode === '--with-preview') { const college={...scenarios[2],rounds:1};scenarios.splice(0,scenarios.length,college); }
if(mode === '--fast-five-rounds') { const custom=scenarios[4];scenarios.splice(0,scenarios.length,custom); }
const fast=mode==='--fast-five-rounds';
const fastModel=process.env.PROMPTD_BENCHMARK_MODEL||'gpt-6-luna';
const report={date:new Date().toISOString(),model:fast?fastModel:'gpt-6.1-sol',strategy:'sequential reviewed round batches; no parallel scenarios',runs:[]};
for(let scenarioIndex=0;scenarioIndex<scenarios.length;scenarioIndex++) {
 const scenario=scenarios[scenarioIndex],calls=[];
 const measuredFetch=async(...args)=>{
  const started=Date.now();const payload=JSON.parse(args[1].body);const input=JSON.parse(payload.input[0].content[0].text);
  const call={kind:input.prompts?'review':'generation',count:input.count,startedAt:started};
  calls.push(call);
  try {const response=await fetch(...args);const data=await response.clone().json().catch(()=>({}));Object.assign(call,{ms:Date.now()-started,status:response.status,usage:data.usage??null});return response;}
  catch(error){Object.assign(call,{ms:Date.now()-started,error:error.name});throw error;}
 };
 const Provider=fast?FastGameplayPromptProvider:OpenAIPromptProvider;
 const provider=new Provider({apiKey,model:fast?fastModel:'gpt-6.1-sol',fetchImpl:measuredFetch});
 const generator=new PromptService({provider,store:null});
 const store=new LocalStore(resolve(out,`scenario-${scenarioIndex+1}.sqlite`));
 const worker=new GameplayPrompts({store,generator});
 const profile={contractVersion:1,groupTypes:scenario.groups,groupNote:'',styleLevel:scenario.style,moreOf:['funny'],moreOfNote:'',lessOf:[],lessOfNote:'',safeMode:scenario.safe,averageAge:scenario.age,groupDescription:scenario.description,topicLabels:scenario.topics};
 // Fixed synthetic preview exclusion demonstrates that preview cards are not gameplay input.
 let session={profile,effective:config.styles[scenario.style].base,feedback:[{text:'A very elaborate imaginary award ceremony for your leftovers.',accepted:false,reasons:['too_confusing'],explanation:'Simple and witty. Make it easy to picture a photo.'}],history:['A very elaborate imaginary award ceremony for your leftovers.'],priorPrompts:[]};
 const gameId=`bench-${Date.now()}-${scenarioIndex}`;
 const row={...scenario,gameId,roundsMeasured:[],calls};report.runs.push(row);
 if(mode === '--with-preview') {
  const setupService=new PromptService({store,provider});const setupStart=Date.now();
  try {
   const preview=await setupService.generate('benchmark-host',{contractVersion:1,requestId:randomUUID(),mode:'examples',count:5,profile});
   row.preview={ms:Date.now()-setupStart,prompts:preview.prompts};
   for(const prompt of preview.prompts) await setupService.feedback('benchmark-host',{contractVersion:1,requestId:randomUUID(),sessionId:preview.id,promptId:prompt.id,accepted:true,reason:'',explanation:''});
   session=await store.transact([`promptdSessions/${preview.id}`],([saved])=>({result:saved}));
   row.preview.calls=calls.splice(0,calls.length);console.log('PREVIEW '+JSON.stringify(row.preview));
  } catch(error) {
   row.error={stage:'preview',code:error.code??'internal',message:error.message};
   writeFileSync(resolve(out,'results.json'),JSON.stringify(report,null,2));console.log(JSON.stringify(row.error));store.close();continue;
  }
 }
 const start=Date.now();await worker.start({gameId,playerIds:Array.from({length:scenario.players},(_,i)=>`player${i+1}`),rounds:scenario.rounds,session});
 console.log(`START ${scenario.name}: ${scenario.players} players / ${scenario.rounds} rounds`);
 const save=()=>writeFileSync(resolve(out,'results.json'),JSON.stringify(report,null,2));
 for(let round=1;round<=scenario.rounds;round++) {
  const before=Date.now(),callStart=calls.length;let job;
  try {job=await worker.prepareNext(gameId);}
  catch(error){row.error={round,code:error.code??'internal',message:error.message};save();console.log(JSON.stringify(row.error));break;}
  const ready=job.ready.at(-1);
  row.roundsMeasured.push({round,ms:Date.now()-before,sinceStartMs:Date.now()-start,calls:calls.length-callStart,prompts:ready.prompts});
  console.log(JSON.stringify({name:scenario.name,...row.roundsMeasured.at(-1)}));save();
 }
 row.totalMs=Date.now()-start;
 row.round1Ms=row.roundsMeasured[0]?.sinceStartMs??null;
 row.backgroundMs=row.round1Ms===null?null:row.totalMs-row.round1Ms;
 row.completed=row.roundsMeasured.length===scenario.rounds;
 save();store.close();
}
console.log('Saved benchmark results to '+resolve(out,'results.json'));
