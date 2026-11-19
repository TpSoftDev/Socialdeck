import {readFileSync} from 'node:fs';
import {PromptError} from './errors.mjs';
const calibration = readFileSync(new URL('./PROMPT_SIMPLE_WITTY.md', import.meta.url), 'utf8').trim();
// IA: One server-side switch restores the previous wording without changing
// safety, feedback, repairs, model selection, or already-approved examples.
export function promptStyle(name = process.env.PROMPTD_WRITING_STYLE || 'simple-witty-v1') {
  if (!['legacy-v1', 'simple-witty-v1'].includes(name)) {
    throw new PromptError('failed-precondition', 'Unknown PROMPTD_WRITING_STYLE.');
  }
  return {name, suffix: name === 'legacy-v1' ? '' : '\n\n' + calibration};
}
