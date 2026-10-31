// Shared generation/review contract; transports provide request().
import { readFileSync } from 'node:fs';
import { PromptError } from './errors.mjs';
const policy = readFileSync(new URL('./CONTENT_POLICY.md', import.meta.url), 'utf8');
const instructions = readFileSync(new URL('./PROMPT_GENERATOR.md', import.meta.url), 'utf8') + '\n' + policy;
const reviewInstructions = readFileSync(new URL('./PROMPT_REVIEWER.md', import.meta.url), 'utf8') + '\n' + policy;
const issueKinds = ['audience', 'boundary', 'repetition', 'group_fit', 'feedback', 'answerability', 'wording'];
export class StructuredPromptProvider {
  async generate(context, options) {
    const count = context.count ?? 5;
    const task = context.revision
      ? 'Current task: repair only the failed candidate slots. Copy revision.keep exactly; replace the other slots with fresh answer ideas.'
      : `Current task: create exactly ${count} NEW cards. Previous prompts and feedback are history, not a draft to edit. Accepted cards stay with the player; do not repeat them. Choose ${count} unused photo ideas before writing.`;
    // IA: Every new or replacement card must fit at least one selected app topic.
    const topicTask = context.profile?.topicLabels?.length ? '\nEach card must clearly fit at least one profile.topicLabels entry, including custom entries. Keep the exact custom names available for review.' : '';
    const result = await this.request(instructions + '\n\n' + task + topicTask, context, { type: 'object', properties: { angles: { type: 'array', minItems: count, maxItems: count, items: { type: 'string', maxLength: 120 } }, prompts: { type: 'array', minItems: count, maxItems: count, items: { type: 'string' } } }, required: ['angles', 'prompts'], additionalProperties: false }, options);
    return result.prompts;
  }
  async review(context, prompts, options) {
    const count = context.count ?? 5;
    // IA: Label each card during the existing review, using only selected app topics.
    // Empty labels mean no clear match; never invent a topic or add another model call.
    const labels = context.profile?.topicLabels ?? [];
    const topicFields = labels.length ? { topics: { type: 'array', maxItems: 3, items: { type: 'string', enum: labels } } } : {};
    const topicInstruction = labels.length ? '\nFor each card, return topics containing zero to three selected topicLabels that clearly fit its text. Do not assign unrelated topics just to fill a tag. Use [] if none fit.' : '';
    const issuesSchema = { type: 'array', items: { type: 'string', enum: issueKinds } };
    // Repair drafts include copies of the candidates being reviewed. They are not
    // shown-card history and must not cause a card to be compared with itself.
    const { revision: _revision, ...reviewContext } = context;
    const result = await this.request(reviewInstructions + topicInstruction, { ...reviewContext, prompts }, {
      type: 'object', additionalProperties: false,
      properties: {
        checks: { type: 'array', minItems: count, maxItems: count, items: {
          type: 'object', additionalProperties: false,
          properties: { ...topicFields, index: { type: 'integer', minimum: 0, maximum: count - 1 }, premise: { type: 'string', maxLength: 160 }, comparison: { type: 'string', maxLength: 240 }, issues: issuesSchema, detail: { type: 'string', maxLength: 180 } },
          required: ['index', 'premise', 'comparison', 'issues', 'detail', ...(labels.length ? ['topics'] : [])],
        } },
        batchIssues: issuesSchema, batchDetail: { type: 'string', maxLength: 180 },
      }, required: ['checks', 'batchIssues', 'batchDetail'],
    }, options);
    // Structured output is still untrusted: incomplete/ambiguous reviews fail closed.
    const validIssues = v => Array.isArray(v) && v.every(x => issueKinds.includes(x));
    if (!Array.isArray(result?.checks) || result.checks.length !== count || !validIssues(result.batchIssues) || typeof result.batchDetail !== 'string' ||
        result.checks.some((c, i) => !c || c.index !== i || !validIssues(c.issues) || typeof c.detail !== 'string' || typeof c.premise !== 'string' || typeof c.comparison !== 'string' || (labels.length && (!Array.isArray(c.topics) || c.topics.length > 3 || c.topics.some(t => !labels.includes(t)))))) {
      throw new PromptError('invalid-provider-response', 'The model returned an incomplete review.');
    }
    // IA: An empty match is an off-topic card to repair, not an excuse to invent a tag.
    // This runs for initial batches AND replacement batches; accepted history is untouched.
    if (labels.length) {
      for (const check of result.checks) {
        if (!check.topics.length) {
          check.issues = [...new Set([...check.issues, 'group_fit'])];
          check.detail = 'Rewrite this card to clearly fit at least one selected topicLabels entry. Do not attach an unrelated tag.';
        }
      }
    }
    const issues = [...new Set([...result.batchIssues, ...result.checks.flatMap(c => c.issues)])];
    const corrections = result.checks.filter(c => c.issues.length).map(c => ({ index: c.index, issues: c.issues, detail: c.detail.slice(0, 180) }));
    // A summary of an already flagged card does not invalidate all four passing cards.
    const cardIssues = new Set(result.checks.flatMap(c => c.issues));
    const batchOnly = result.batchIssues.filter(issue => !cardIssues.has(issue));
    if (batchOnly.length) corrections.push({ issues: batchOnly, detail: result.batchDetail.slice(0, 180) });
    return { approved: issues.length === 0, issues, corrections, ...(labels.length ? { topicTags: result.checks.map(c => [...new Set(c.topics)]) } : {}) };
  }
}
