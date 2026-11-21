// IA: Resume a failed local benchmark without regenerating reviewed rounds.
import {readFileSync,writeFileSync} from 'node:fs';
import {resolve} from 'node:path';
import {FastGameplayPromptProvider} from '../src/fast-gameplay-provider.mjs';
import {OpenAIPromptProvider} from '../src/openai.mjs';
import {PromptService} from '../src/service.mjs';
import {GameplayPrompts} from '../src/gameplay.mjs';
import {LocalStore} from '../host/local-store.mjs';
const [secretFile,folder]=process.argv.slice(2);
const line=readFileSync(secretFile,'utf8').split(/\r?\n/).find(l=>/^OPENAI_API_KEY=/.test(l));
if(!line)throw Error('Key unavailable');
const apiKey=line.slice(line.indexOf('=')+1).trim().replace(/^['"]|['"]$/g,'');
const baseline=JSON.parse(readFileSync(resolve(folder,'results.json'),'utf8'));const index=baseline.runs.findIndex(r=>r.completed===false);
if(index<0)throw Error('No failed game to resume');
const row=baseline.runs[index],calls=[];
const measuredFetch=async(...args)=>{const start=Date.now();const payload=JSON.parse(args[1].body);const input=JSON.parse(payload.input[0].content[0].text);const call={kind:input.prompts?'review':'generation',count:input.count};calls.push(call);try{const response=await fetch(...args);const data=await response.clone().json().catch(()=>({}));Object.assign(call,{ms:Date.now()-start,status:response.status,usage:data.usage});return response;}catch(error){Object.assign(call,{ms:Date.now()-start,error:error.name});throw error;}};
const timeoutMs=Number(process.env.PROMPTD_GAMEPLAY_TEST_TIMEOUT_MS || 25000);
const Provider=process.env.PROMPTD_BENCHMARK_COMPACT==='1'?FastGameplayPromptProvider:OpenAIPromptProvider;
const provider=new Provider({apiKey,model:process.env.PROMPTD_BENCHMARK_MODEL||'gpt-6.1-sol',fetchImpl:measuredFetch,timeoutMs});
const store=new LocalStore(resolve(folder,`scenario-${index+1}.sqlite`));
const worker=new GameplayPrompts({store,generator:new PromptService({provider,store:null})});
let job=await worker.read(row.gameId);const original=JSON.stringify(job.ready);
const result={model:provider.model,compact:Provider===FastGameplayPromptProvider,requestTimeoutMs:timeoutMs,gameId:row.gameId,startedAt:new Date().toISOString(),preservedRounds:job.ready.length,roundsMeasured:[],calls};const start=Date.now();
const save=()=>writeFileSync(resolve(folder,'recovery.json'),JSON.stringify(result,null,2));
while(job.ready.length<job.rounds){const before=Date.now(),callStart=calls.length;try{job=await worker.prepareNext(row.gameId);const last=job.ready.at(-1);result.roundsMeasured.push({round:last.round,ms:Date.now()-before,calls:calls.length-callStart,prompts:last.prompts});console.log(JSON.stringify(result.roundsMeasured.at(-1)));save();}catch(error){result.error={code:error.code,message:error.message};console.log(JSON.stringify(result.error));break;}}
result.elapsedMs=Date.now()-start;result.completed=job.ready.length===job.rounds;
result.originalRoundsUnchanged=JSON.stringify(job.ready.slice(0,result.preservedRounds))===original;save();store.close();
