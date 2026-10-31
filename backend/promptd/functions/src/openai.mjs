// OpenAI transport stays on the server; generation/review logic is shared.
import { StructuredPromptProvider } from './structured-provider.mjs';
import { PromptError } from './errors.mjs';
export class OpenAIPromptProvider extends StructuredPromptProvider {
  constructor({ apiKey, model = 'gpt-6.1-sol', thinking = 'low', fetchImpl = fetch, timeoutMs = 25000 }) {
    super();
    if (!/^gpt-[a-zA-Z0-9.-]+$/.test(model ?? '')) throw new PromptError('failed-precondition', 'Configure an OpenAI GPT model ID on the backend.');
    this.source = 'openai'; this.apiKey = apiKey; this.model = model; this.thinking = thinking; this.fetch = fetchImpl; this.timeoutMs = timeoutMs;
  }
  async request(system, input, schema, { timeoutMs = this.timeoutMs } = {}) {
    if (!this.apiKey) throw new PromptError('failed-precondition', 'The backend OPENAI_API_KEY secret is not configured.');
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), Math.min(this.timeoutMs, timeoutMs));
    try {
      const response = await this.fetch('https://api.openai.com/v1/responses', {
        method: 'POST', signal: controller.signal,
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${this.apiKey}` },
        body: JSON.stringify({ model: this.model, instructions: system,
          input: [{ role: 'user', content: [{ type: 'input_text', text: JSON.stringify(input) }] }],
          store: false, reasoning: { effort: this.thinking }, max_output_tokens: 4096,
          text: { format: { type: 'json_schema', name: 'promptd_result', strict: true, schema } },
        }),
      });
      if (!response.ok) {
        // Inspect only the error code, never echo provider text, keys or user data.
        const error = await response.json().catch(() => ({}));
        if (error?.error?.code === 'insufficient_quota' || response.status === 402) throw new PromptError('failed-precondition', 'The OpenAI project has no available API budget. Ask the project administrator to check billing and limits.');
        if ([400, 401, 403, 404].includes(response.status)) throw new PromptError('failed-precondition', 'Check the server OpenAI key, model access, and Responses API permissions.');
        throw new PromptError(response.status === 429 ? 'provider-rate-limited' : 'provider-unavailable', 'The model service could not complete this request.');
      }
      const result = await response.json();
      const content = Array.isArray(result?.output) ? result.output.filter(item => item.type === 'message' && item.role === 'assistant').flatMap(item => item.content ?? []) : [];
      if (content.some(part => part.type === 'refusal')) throw new PromptError('failed-precondition', 'OpenAI declined this request. Adjust the group preferences or content request, then try again.');
      if (result?.status !== 'completed') throw new PromptError('invalid-provider-response', 'The OpenAI response was incomplete.');
      const text = content.filter(part => part.type === 'output_text').map(part => part.text ?? '').join('');
      try { return JSON.parse(text); } catch { throw new PromptError('invalid-provider-response', 'OpenAI returned invalid JSON.'); }
    } catch (error) {
      if (controller.signal.aborted) throw new PromptError('provider-timeout', 'The model response timed out.');
      if (error instanceof PromptError) throw error;
      throw new PromptError('provider-unavailable', 'The model service is unavailable.');
    } finally { clearTimeout(timer); }
  }
}
