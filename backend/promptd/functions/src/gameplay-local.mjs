// IA: Explicit local gameplay entry point. Not exported by the deployed Firebase index.
// The old path remains selectable; host preview generation is untouched.
import {GameplayPrompts} from './gameplay.mjs';
import {PromptService} from './service.mjs';
import {FastGameplayPromptProvider} from './fast-gameplay-provider.mjs';
import {OpenAIPromptProvider} from './openai.mjs';
export function createLocalGameplayWorker({store,apiKey,strategy='compact-original',fetchImpl=fetch}) {
 if(!['compact-original','fast-v3','legacy'].includes(strategy))throw Error('Unknown gameplay strategy');
 const provider=strategy==='legacy'
  ?new OpenAIPromptProvider({apiKey,model:'gpt-6.1-sol',thinking:'low',fetchImpl})
  :new FastGameplayPromptProvider({apiKey,model:strategy==='fast-v3'?'gpt-6-luna':'gpt-6.1-sol',thinking:'low',fetchImpl});
 return new GameplayPrompts({store,generator:new PromptService({store:null,provider})});
}
