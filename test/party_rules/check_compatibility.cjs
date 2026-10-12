// Usage: node check_compatibility.cjs DEPLOYED_FIRESTORE_RULES OUTPUT_DIRECTORY
// Runs only against the local emulator. Does not log in, deploy, or use live data.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { spawnSync } = require('node:child_process');

const [baselineArg, outputArg] = process.argv.slice(2);
assert.ok(baselineArg && outputArg, 'Supply the deployed rules snapshot and output directory');
const baselinePath = path.resolve(baselineArg);
const output = path.resolve(outputArg);
const partyPath = path.resolve(__dirname, '../../firestore.party.rules');
const baseline = fs.readFileSync(baselinePath, 'utf8');
const party = fs.readFileSync(partyPath, 'utf8');
function splitRules(source) {
  const marker = 'match /databases/{database}/documents {';
  assert.equal(source.split(marker).length, 2, 'Expected one Firestore database match');
  const start = source.indexOf(marker) + marker.length;
  const ending = /\r?\n\s*}\s*\r?\n\s*}\s*$/.exec(source);
  assert.ok(ending && ending.index > start, 'Unexpected Firestore wrapper');
  return { prefix: source.slice(0, start), body: source.slice(start, ending.index),
    suffix: source.slice(ending.index) };
}
const base = splitRules(baseline);
const addition = splitRules(party);
// Keep the original source verbatim; insert only the Party definitions.
const inserted = '\n    // Party additions; existing team rules above are unchanged.\n' + addition.body;
const combined = base.prefix + base.body + inserted + base.suffix;
assert.equal(combined.replace(inserted, ''), baseline);
fs.mkdirSync(output, { recursive: true });
const combinedPath = path.join(output, 'firestore.combined.rules');
assert.notEqual(combinedPath, baselinePath, 'Never overwrite the deployed snapshot');
fs.writeFileSync(combinedPath, combined);
const sha = value => crypto.createHash('sha256').update(value).digest('hex');
const report = { baseline: baselinePath, baselineSha256: sha(baseline),
  partySha256: sha(party), combinedSha256: sha(combined),
  originalRulesPreservedExactly: true, emulator: '127.0.0.1:8085', suites: [] };
for (const file of ['compatibility.test.cjs', 'party_rules.test.cjs']) {
  const result = spawnSync(process.execPath, ['--test', '--test-reporter=tap', file], {
    cwd: __dirname, encoding: 'utf8', timeout: 240000,
    env: { ...process.env, FIREBASE_BASELINE_RULES: baselinePath,
      PARTY_RULES_FILE: combinedPath, FIRESTORE_EMULATOR_HOST: '127.0.0.1:8085',
      PARTY_TEST_PROJECT: 'demo-socialdeck-compat-party' },
  });
  fs.writeFileSync(path.join(output, file + '.log'), (result.stdout || '') + (result.stderr || ''));
  const totals = (result.stdout || '').split(/\r?\n/).filter(s => /^# (tests|pass|fail|duration_ms) /.test(s));
  report.suites.push({ file, exitCode: result.status, totals, error: result.error?.message });
  console.log(file + ': ' + totals.join(', '));
  fs.writeFileSync(path.join(output, 'results.json'), JSON.stringify(report, null, 2));
  if (result.status !== 0) { process.exitCode = 1; break; }
}
console.log('Results and candidate rules: ' + output);
