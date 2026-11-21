// IA: Paid latency experiment; existing defaults and independent review remain unchanged.
import { readFileSync,writeFileSync,mkdirSync } from 'node:fs';
import { resolve } from 'node:path';
import { OpenAIPromptProvider } from '../src/openai.mjs';
import { PromptService } from '../src/service.mjs';
import { FastGameplayPromptProvider } from '../src/fast-gameplay-provider.mjs';
import { GameplayPromptProvider } from '../src/gameplay-provider.mjs';
import config from '../shared/config.json' with {type:'json'};
const [secretFile,folder,baselineFile]=process.argv.slice(2);
if(!secretFile||!folder||!baselineFile)throw Error('Usage: node scripts/benchmark-latency.mjs <secret-file> <output-directory> <baseline-results.json>');
const line=readFileSync(secretFile,'utf8').split(/\r?\n/).find(l=>/^OPENAI_API_KEY=/.test(l));if(!line)throw Error('Missing key');
const apiKey=line.slice(line.indexOf('=')+1).trim().replace(/^['"]|['"]$/g,'');mkdirSync(folder,{recursive:true});
const baseline=JSON.parse(readFileSync(baselineFile,'utf8'));
const model=process.env.PROMPTD_BENCHMARK_MODEL || 'gpt-6.1-sol';
const thinking=process.env.PROMPTD_BENCHMARK_EFFORT || 'low';
const Provider=process.env.PROMPTD_BENCHMARK_COMPACT==='1'?FastGameplayPromptProvider:process.env.PROMPTD_BENCHMARK_PHOTO_FIT==='1'?GameplayPromptProvider:OpenAIPromptProvider;
const report={model,thinking,compact:Provider===FastGameplayPromptProvider,photoFit:Provider===GameplayPromptProvider,strategy:'unchanged instructions, schemas and independent review',runs:[]};
for(const index of JSON.parse(process.env.PROMPTD_BENCHMARK_CASES || '[0,1,2,4,2,0]')) {
 const original=baseline.runs[index],calls=[];
 const provider=new Provider({apiKey,model,thinking,fetchImpl:async(...args)=>{
  const start=Date.now();const request=JSON.parse(args[1].body),input=JSON.parse(request.input[0].content[0].text);const call={kind:input.prompts?'review':'generation'};calls.push(call);
  try{const response=await fetch(...args);const data=await response.clone().json().catch(()=>({}));Object.assign(call,{ms:Date.now()-start,status:response.status,usage:data.usage,errorCode:data.error?.code,errorParam:data.error?.param});
   if(input.prompts&&data.status==='completed'){try{const parsed=JSON.parse(data.output.filter(x=>x.type==='message').flatMap(x=>x.content).filter(x=>x.type==='output_text').map(x=>x.text).join(''));call.review=parsed;call.issues=parsed.checks?.filter(x=>x.issues?.length).map(x=>({index:x.index,issues:x.issues,detail:x.detail}));}catch{}}
   return response;
  }catch(error){Object.assign(call,{ms:Date.now()-start,error:error.name});throw error;}
 }});
 const profile={contractVersion:1,groupTypes:original.groups,groupNote:'',styleLevel:original.style,moreOf:['funny'],moreOfNote:'',lessOf:[],lessOfNote:'',safeMode:original.safe,averageAge:original.age,groupDescription:original.description,topicLabels:original.topics};
 const session={profile,effective:config.styles[original.style].base,feedback:[{text:'A very elaborate imaginary award ceremony for your leftovers.',accepted:false,reasons:['too_confusing'],explanation:'Simple and witty. Make it easy to picture a photo.'}],history:['A very elaborate imaginary award ceremony for your leftovers.'],priorPrompts:[]};
 const row={name:original.name,count:original.players/2,calls};report.runs.push(row);console.log('START '+row.name+' / '+row.count);const start=Date.now();
 try{row.result=await new PromptService({provider,store:null}).generateValidated(session,row.count);}catch(error){row.error={code:error.code,message:error.message};}
 row.ms=Date.now()-start;writeFileSync(resolve(folder,'results.json'),JSON.stringify(report,null,2));console.log(JSON.stringify({name:row.name,count:row.count,ms:row.ms,texts:row.result?.texts,calls:calls.length,error:row.error}));
 if(row.error?.code==='failed-precondition')break;
}
