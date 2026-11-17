// Only this adapter knows Gemini's REST API. No SDK or secret reaches the client.
import { StructuredPromptProvider } from './structured-provider.mjs';
import { PromptError } from './errors.mjs';
export class GeminiPromptProvider extends StructuredPromptProvider {
  constructor({ apiKey, model, thinking = 'low', fetchImpl = fetch, timeoutMs = 12000 }) {
    super();
    this.source = 'gemini';
    if (!/^gemini-[a-z0-9.-]*flash[a-z0-9.-]*$/.test(model ?? '')) throw new PromptError('failed-precondition', 'Configure a Gemini Flash model ID on the backend.');
    this.apiKey = apiKey; this.model = model; this.thinking = thinking; this.fetch = fetchImpl; this.timeoutMs = timeoutMs;
  }
  async request(system, input, schema) {
    if (!this.apiKey) throw new PromptError('failed-precondition', 'The backend Gemini secret is not configured.');
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), this.timeoutMs);
    try {
      const response = await this.fetch(`https://generativelanguage.googleapis.com/v1beta/models/${this.model}:generateContent`, {
        method: 'POST', signal: controller.signal,
        headers: { 'Content-Type': 'application/json', 'x-goog-api-key': this.apiKey },
        body: JSON.stringify({ systemInstruction: { parts: [{ text: system }] }, contents: [{ role: 'user', parts: [{ text: JSON.stringify(input) }] }], generationConfig: { temperature: 1, maxOutputTokens: 4096, thinkingConfig: { thinkingLevel: this.thinking }, responseMimeType: 'application/json', responseJsonSchema: schema } }),
      });
      if (response.status === 402) throw new PromptError('failed-precondition', 'Gemini API credits are depleted. Add credits in Google AI Studio, then retry.');
      if ([400, 401, 403, 404].includes(response.status)) throw new PromptError('failed-precondition', 'Check the server Gemini model, key, access, and low-thinking support.');
      if (!response.ok) throw new PromptError(response.status === 429 ? 'provider-rate-limited' : 'provider-unavailable', 'The model service could not complete this request.');
      const result = await response.json();
      const candidate = result.candidates?.[0];
      if (candidate?.finishReason !== 'STOP') throw new PromptError('invalid-provider-response', 'The model response was incomplete or blocked.');
      const text = candidate.content?.parts?.filter(p => !p.thought).map(p => p.text ?? '').join('');
      try { return JSON.parse(text); } catch { throw new PromptError('invalid-provider-response', 'The model returned invalid JSON.'); }
    } catch (error) {
      if (controller.signal.aborted) throw new PromptError('provider-timeout', 'The model response timed out.');
      if (error instanceof PromptError) throw error;
      throw new PromptError('provider-unavailable', 'The model service is unavailable.');
    } finally { clearTimeout(timer); }
  }
}
