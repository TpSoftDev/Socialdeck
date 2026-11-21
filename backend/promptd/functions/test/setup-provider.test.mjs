import {test} from 'node:test';import assert from 'node:assert/strict';
import {createSetupPromptProvider} from '../src/setup-provider.mjs';
import {FastGameplayPromptProvider} from '../src/fast-gameplay-provider.mjs';
import {OpenAIPromptProvider} from '../src/openai.mjs';
test('setup compact uses the same model and independent reviewer; legacy remains available',()=>{
 const options={name:'openai',apiKey:'test-key',model:'gpt-6.1-sol',thinking:'low'};
 const compact=createSetupPromptProvider({...options,strategy:'compact'});
 assert.ok(compact instanceof FastGameplayPromptProvider);assert.equal(compact.model,options.model);assert.equal(typeof compact.review,'function');
 const legacy=createSetupPromptProvider(options);assert.ok(legacy instanceof OpenAIPromptProvider);assert.equal(legacy instanceof FastGameplayPromptProvider,false);
 assert.throws(()=>createSetupPromptProvider({...options,strategy:'skip-review'}));
 assert.throws(()=>createSetupPromptProvider({...options,name:'gemini',strategy:'compact'}));
});
