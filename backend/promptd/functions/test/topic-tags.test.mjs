import test from 'node:test';
import assert from 'node:assert/strict';
import { StructuredPromptProvider } from '../src/structured-provider.mjs';
class Reviewer extends StructuredPromptProvider {
  tags = ['Fitness'];
  async request(system, context, schema) {
    assert.ok(system.includes('zero to three'));
    assert.deepEqual(schema.properties.checks.items.properties.topics.items.enum, ['Fitness', 'Memes']);
    return { checks: [{ index: 0, premise: 'Photo', comparison: 'new', issues: [], detail: '', topics: this.tags }], batchIssues: [], batchDetail: '' };
  }
}
test('IA: review keeps selected topic labels and repairs cards with no clear match', async () => {
  const p = new Reviewer();
  const context = {count: 1, profile: {topicLabels: ['Fitness', 'Memes']}};
  assert.deepEqual((await p.review(context, ['A photo prompt'], {})).topicTags, [['Fitness']]);
  p.tags = []; const unmatched = await p.review(context, ['A photo prompt'], {});
  assert.equal(unmatched.approved, false); assert.ok(unmatched.issues.includes('group_fit'));
  assert.deepEqual(unmatched.topicTags, [[]]);
  p.tags = ['Unselected topic']; await assert.rejects(p.review(context, ['A photo prompt'], {}));
  p.tags = undefined; await assert.rejects(p.review(context, ['A photo prompt'], {}));
});
