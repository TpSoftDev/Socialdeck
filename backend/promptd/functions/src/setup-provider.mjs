// IA: Reuse the tested compact gameplay contract for setup without changing the model,
// policy, session service, approval/replacement logic or the legacy rollback path.
import {createPromptProvider} from './provider.mjs';
import {FastGameplayPromptProvider} from './fast-gameplay-provider.mjs';
import {PromptError} from './errors.mjs';
export function createSetupPromptProvider({strategy='legacy',...options}) {
 if(!['legacy','compact'].includes(strategy))throw new PromptError('failed-precondition','Unknown setup generation strategy.');
 if(strategy==='compact') {
  if(options.name!=='openai')throw new PromptError('failed-precondition','Compact setup requires OpenAI.');
  return new FastGameplayPromptProvider(options);
 }
 return createPromptProvider(options);
}
