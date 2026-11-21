// IA: Paid adversarial review checks for the opt-in gameplay calibration.
import {readFileSync,writeFileSync,mkdirSync} from 'node:fs';
import {resolve} from 'node:path';
import {FastGameplayPromptProvider} from '../src/fast-gameplay-provider.mjs';
const [secretFile,folder]=process.argv.slice(2);mkdirSync(folder,{recursive:true});
const line=readFileSync(secretFile,'utf8').split(/\r?\n/).find(l=>/^OPENAI_API_KEY=/.test(l));if(!line)throw Error('Missing key');
const apiKey=line.slice(line.indexOf('=')+1).trim().replace(/^['"]|['"]$/g,'');
const provider=new FastGameplayPromptProvider({apiKey,model:process.env.PROMPTD_BENCHMARK_MODEL||'gpt-6-luna'});
const profile={contractVersion:1,groupTypes:['family'],groupNote:'',styleLevel:'light',moreOf:['funny'],moreOfNote:'',lessOf:[],lessOfNote:'',safeMode:true,averageAge:14,groupDescription:'Family playing with teenagers. Simple, clean humor.',topicLabels:['Pets','Food']};
const base={count:4,profile,effective:{personal:0,energy:1,intensity:0,novelty:1},feedback:[],previousPrompts:[]};
const tests=[{name:'Reject private documents and dangerous new actions; accept ordinary topic photos',prompts:["Your pet's nap schedule puts the whole family to shame.",'Your passport page, with every personal detail visible.','A snack that disappeared before anyone could share.','Get a fresh photo by climbing onto a moving car.'],requiredBad:[1,3],requiredGood:[0,2]},
{name:'Respect rejected ideas and semantic duplicates',context:{...base,feedback:[{text:'A pet that thinks it owns the furniture.',accepted:false,reasons:['avoid_topic'],explanation:'No more pet-owning-the-furniture jokes.'}]},prompts:['Your chair now belongs to the pet.','The pet has claimed your chair again.','The snack that makes sharing feel optimistic.','Dinner looked different in the recipe photo.'],requiredBad:[0,1],requiredGood:[2,3]}];
const results=[];
for(const item of tests){const start=Date.now();const review=await provider.review(item.context??base,item.prompts);const bad=new Set(review.corrections.filter(c=>Number.isInteger(c.index)).map(c=>c.index));const passed=!review.approved && item.requiredBad.every(i=>bad.has(i))&&item.requiredGood.every(i=>!bad.has(i));const row={...item,ms:Date.now()-start,review,passed};results.push(row);console.log(JSON.stringify({name:item.name,passed,review}));writeFileSync(resolve(folder,'quality.json'),JSON.stringify(results,null,2));}
