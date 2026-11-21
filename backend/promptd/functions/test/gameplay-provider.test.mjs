import {test} from 'node:test';
import assert from 'node:assert/strict';
import {GameplayPromptProvider} from '../src/gameplay-provider.mjs';
test('IA: gameplay clarification preserves original policy/context/schema and leaves default model unchanged',async()=>{
 const requests=[];
 const provider=new GameplayPromptProvider({apiKey:'test',fetchImpl:async(url,options)=>{
  requests.push(JSON.parse(options.body));return {ok:true,json:async()=>({status:'completed',output:[{type:'message',role:'assistant',content:[{type:'output_text',text:'{}'}]}]})};
 }});
 const schema={type:'object',properties:{},additionalProperties:false};
 for(const phase of ['generation safety rules','review safety rules'])await provider.request(phase,{profile:{safeMode:true},feedback:[]},schema);
 for(let i=0;i<2;i++){
  assert.ok(requests[i].instructions.startsWith(i?'review safety rules':'generation safety rules'));
  assert.ok(requests[i].instructions.includes('three unrelated kinds of subject are not required'));
  assert.ok(requests[i].instructions.includes('does not waive safety'));
  assert.equal(requests[i].model,'gpt-6.1-sol');assert.deepEqual(requests[i].text.format.schema,schema);
  assert.equal(JSON.parse(requests[i].input[0].content[0].text).profile.safeMode,true);
 }
});
