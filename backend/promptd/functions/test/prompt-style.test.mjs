import {test} from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync} from 'node:fs';
import {createHash} from 'node:crypto';
import {StructuredPromptProvider} from '../src/structured-provider.mjs';
import {promptStyle} from '../src/prompt-style.mjs';
const source = name => readFileSync(new URL('../src/' + name, import.meta.url), 'utf8');
test('legacy source is preserved byte-for-byte',()=>{
  const hashes=JSON.parse(source('prompt-versions/legacy-v1/sha256.json'));
  for(const [name,hash] of Object.entries(hashes)) {
    for(const path of [name,'prompt-versions/legacy-v1/'+name])
      assert.equal(createHash('sha256').update(readFileSync(new URL('../src/'+path,import.meta.url))).digest('hex'),hash);
  }
});
test('style selection supports exact rollback and rejects unknown settings',()=>{
  assert.equal(promptStyle('legacy-v1').suffix,'');
  assert.match(promptStyle('simple-witty-v1').suffix,/5-12 familiar spoken words/);
  assert.throws(()=>promptStyle('typo'),e=>e.code==='failed-precondition');
});
test('generation and review receive same calibration; legacy receives original instructions',async()=>{
  for(const style of ['legacy-v1','simple-witty-v1']) {
    const p=new StructuredPromptProvider();p.writingStyle=promptStyle(style);
    const captured=[];
    p.request=async(system,input)=>{captured.push({system,input});return captured.length===1
      ? {prompts:['An ordinary photo prompt.']}
      : {checks:[{index:0,premise:'Everyday',comparison:'',issues:[],detail:''}],batchIssues:[],batchDetail:''};};
    const context={count:1,profile:{},feedback:[{accepted:true,text:'Keep this exact card.'}]};
    await p.generate(context);await p.review(context,['An ordinary photo prompt.']);
    const task='Current task: create exactly 1 NEW cards. Previous prompts and feedback are history, not a draft to edit. Accepted cards stay with the player; do not repeat them. Choose 1 unused photo ideas before writing.';
    assert.equal(captured[0].system,source('PROMPT_GENERATOR.md')+'\n'+source('CONTENT_POLICY.md')+'\n\n'+task+p.writingStyle.suffix);
    assert.equal(captured[1].system,source('PROMPT_REVIEWER.md')+'\n'+source('CONTENT_POLICY.md')+p.writingStyle.suffix);
    assert.deepEqual(captured[0].input,context);
    assert.equal(context.feedback[0].text,'Keep this exact card.');
  }
});
