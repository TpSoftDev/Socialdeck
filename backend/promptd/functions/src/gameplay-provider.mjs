// IA: Opt-in gameplay-only calibration. Existing preview provider/default model is unchanged.
import {readFileSync} from 'node:fs';
import {OpenAIPromptProvider} from './openai.mjs';
const photoFit=readFileSync(new URL('./GAMEPLAY_PHOTO_FIT.md',import.meta.url),'utf8');
export class GameplayPromptProvider extends OpenAIPromptProvider {
  request(system,input,schema,options) {
    // IA: Same photo-fit rule in generation AND independent review prevents repair ping-pong.
    // All original policy, feedback, topic tagging and strict schemas remain in force.
    return super.request(system+'\n\n'+photoFit,input,schema,options);
  }
}
