import { GeminiPromptProvider } from './gemini.mjs';
import { OpenAIPromptProvider } from './openai.mjs';
import { PromptError } from './errors.mjs';
export function providerSettings(name = 'gemini') {
  if (name === 'openai') return { name, secret: 'OPENAI_API_KEY', modelEnv: 'OPENAI_MODEL', defaultModel: 'gpt-6.1-sol' };
  if (name === 'gemini') return { name, secret: 'GEMINI_API_KEY', modelEnv: 'GEMINI_MODEL', defaultModel: '' };
  throw new PromptError('failed-precondition', 'PROMPT_PROVIDER must be openai or gemini.');
}
export function createPromptProvider({ name = 'gemini', ...options }) {
  providerSettings(name);
  return name === 'openai' ? new OpenAIPromptProvider(options) : new GeminiPromptProvider(options);
}
