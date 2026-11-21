# Start-triggered gameplay prompts — local implementation

Host presses Start -> lock game roster/settings -> prepare and review Round 1 -> prepare later rounds in order.

- `functions/src/gameplay.mjs`: private, trusted orchestration; persists one reviewed round at a time through the existing transactional store interface. No AI work happens on `start()` until the worker runs.
- `prepareNext()` awaits generation and review, preserves earlier rounds, excludes previews and prior gameplay, blocks concurrent workers with a lease, and rejects stale worker results.
- `retry()` explicitly resumes after three failed worker attempts; retries never clear reviewed rounds. Each existing validation call may internally repair up to three times.
- 4/6/8 players and 1–5 rounds are supported. Odd rosters fail until the matchup contract is agreed.
- Generation supplies Round 1 readiness immediately; countdown, fade and animation belong to the frontend team and are not implemented here.
- One round per background task prioritizes the next playable round. It repeats API instructions; this is a latency-first baseline, not a proven cheapest batch size.

## Run local tests

From `backend/promptd/functions`: `npm ci`, `npm run sync`, `npm test`.

## Explicit paid benchmark

Run `node scripts/benchmark-gameplay.mjs <local-secret-file> <output-directory>` from the functions directory. The file must contain OPENAI_API_KEY; never pass its value as a CLI argument. It runs five synthetic scenarios sequentially using the configured default model, records provider-call timing/usage and reviewed prompts, and writes local SQLite snapshots and JSON. It does not write production Firebase data or deploy anything.

## Historical benchmark boundary (superseded by local integration below)

This module is deliberately not exported as a public callable. The trusted Start adapter still needs host/membership validation, authoritative game/settings lookup and atomic coordination with the gameplay team’s shared game record. Never accept client-supplied effective style or scores as authority.

A durable task dispatcher (for example Cloud Tasks), restricted worker endpoint, cancellation/cleanup, participant-safe status reads, matchup assignment/reveal permissions and app wiring remain to be implemented. Do not run promises in the background after a callable response. Current local benchmark explicitly awaits each worker unit; it does not simulate a deployed queue, real card selection, cold starts or mobile network latency.

Reviewed future prompts remain private server data. A game’s settings are immutable after Start. Each new game uses a new ID. No retention reserve or frontend redesign is included.

## Recorded benchmark limitations

The 8-player custom-topic run hit the existing 25-second transport limit during Round 2, including on its first recovery attempt. A separate recovery experiment uses `PROMPTD_GAMEPLAY_TEST_TIMEOUT_MS=45000` only in `resume-gameplay-benchmark.mjs`. This does not change the production provider default or the overall 80-second validation budget. Keep initial failure and recovery measurements separate.

`benchmark-gameplay.mjs ... --with-preview` runs an actual five-example generation and records all five as accepted test feedback before preparing four new gameplay prompts. This is an automated fixture approval, not a human quality endorsement. Its setup timing and gameplay timing are reported separately.

## Preferred local candidate: compact-original

Use `createLocalGameplayWorker({store, apiKey})` from `functions/src/gameplay-local.mjs`. The default local strategy is `compact-original`: the same gpt-6.1-sol model and low reasoning, with compact gameplay instructions and a separate compact semantic reviewer. Use `strategy: 'legacy'` to restore the original instruction set. `strategy: 'fast-v3'` selects the experimental smaller gpt-6-luna; it is not the preferred default after later-round failures. None of these choices changes the host preview service or deployed Firebase exports.

The compact instructions remove conflicting requirements to match a selected topic but also accept unrelated photo categories. Ordinary topic photos and imaginative captions are valid; exact rare scenes, unsafe requests, duplicates and rejected ideas are still checked. Unused generation angles and passing-card rationale text are removed from structured output. Content policy text, profile/feedback, local validation, topic labels, independent semantic review and repairs remain.

Early original-model four-prompt batches completed in 9.1 and 11.0 seconds, including review. These are measured samples, not a latency SLA or proof of identical quality. See the local faster-generation HTML report for all timings, outputs and limits. Real game integration, cloud dispatch and deployment remain pending.


## Local app integration — November 21, 2026

The debug-only `SOCIALDECK_LOCAL_GAMEPLAY=true` flag connects host Start to `startPromptdGame`. It uses demo-socialdeck-gameplay only, with Auth 9299, Firestore 8280, Functions 5201 and Storage 9199. Normal builds remain on the existing deployed service.

Start validates host identity, membership, 4/6/8 ready players, seven-card readiness, matching setup revision and a complete approved AI session. One transaction freezes settings/roster, creates a unique game and queues work. Repeated Start returns the same game. Client-supplied prompts/settings are not accepted.

The generation backend returns the current matchup prompt as soon as it is reviewed and ready. There is no forced 5-second countdown or 10-second reveal delay. The temporary preparation UI and its tests were removed at the user’s request. The frontend team owns countdown, animation, navigation and reveal timing; it can consume getPromptdGamePreparation. Later rounds remain server-private.

A separate local worker processes one reviewed round at a time and resumes durable queued work. It continues independently of the app. The cloud dispatcher is NOT deployed: production still needs a durable task queue/worker configuration before this flag can become the normal app flow. Never replace it with an unawaited callable promise.

### Run locally

0. Configure BOTH AI entry points. The independent worker reads its key-file argument, but setup-example callables require their own ignored `functions/.secret.local` containing `OPENAI_API_KEY`, and ignored `functions/.env.local` with `PROMPT_PROVIDER=openai` and `OPENAI_MODEL=gpt-6.1-sol`. Use the existing authorized local key; never commit these files. Restart the Firebase emulators after changing provider selection, exporting/importing local data first if needed. On this PC, launch Node with `NODE_OPTIONS=--use-system-ca` for the installed HTTPS trust configuration.
1. Start Firebase CLI from repository root with `emulators:start --config firebase.gameplay-test.json --project demo-socialdeck-gameplay --only auth,firestore,functions,storage`.
2. In functions directory, set GCLOUD_PROJECT=demo-socialdeck-gameplay, FIRESTORE_EMULATOR_HOST=127.0.0.1:8280 and FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9299. Run `node scripts/seed-gameplay-local.mjs`. This creates only synthetic local players and approved-preview fixtures.
3. Run `node scripts/test-game-start-local.mjs` for authenticated callable checks. It restores the lobby when finished.
4. Run `node scripts/gameplay-worker.mjs <existing-local-secret-file>`. Do not put API key values on the command line. Real AI calls incur provider usage; Firebase remains local.
5. Run Flutter with `--dart-define=SOCIALDECK_LOCAL_GAMEPLAY=true --dart-define=SOCIALDECK_LOCAL_TEST_LOGIN=true`. The second flag signs into the seeded demo host and opens party 123456. Without it, use normal demo login.

### Scope and remaining handoff

The earlier local UI experiment displayed real Round 1 text; that temporary UI adapter has now been removed. Its card-choice/voting screens are still presentation prototypes, so this generation integration supplies readiness and prompt data only. The first/last roster pairing is a local test adapter, not the team's final matchmaking contract. The gameplay team must supply authoritative match IDs and phase/round progression before production. All countdown/animation work belongs to the frontend team. No new preparation screen is included.

No production data, deployment or Git push is part of this local integration.


## Faster five-example setup — November 21, 2026

Local demo OpenAI callables now use `createSetupPromptProvider` with the same compact generation/review contract used for gameplay. Both generatePromptExamples and generateNextPrompts use it. The model stays gpt-6.1-sol with low reasoning. PromptService, content policy, local validation, independent semantic review, indexed repairs, feedback, accepted-card preservation and topic labels are unchanged.

This changes instructions and removes unused output fields; it cannot guarantee identical creative quality or latency. Three paired synthetic setups produced five approved compact examples in 5.5–13.3 seconds. Legacy took 25.7 and 61.6 seconds on two setups and failed after 62.0 seconds on the family setup. A separate authenticated local callable produced five in 7.5 seconds and replaced one in 4.9 seconds while preserving four approved records exactly. A replay of the same request returned the original examples.

Two live five-candidate reviewer probes passed for safety/age/privacy, rejected feedback and semantic duplication. All 79 backend regression tests pass. The first replacement benchmark fixture used an invalid feedback enum; that fixture was corrected to `other` and replacement was rerun successfully. No user reviews were overwritten.

Rollback: set `PROMPTD_SETUP_STRATEGY=legacy` in ignored `.env.local` and restart emulators, preserving local data. Production defaults remain legacy until separately approved deployment/configuration. No countdown or frontend screen changes are included.

Reproduce: `node scripts/benchmark-setup.mjs <secret-file> <output-folder>`; `node scripts/check-setup-quality.mjs <secret-file> <output-json>`; `GCLOUD_PROJECT=demo-socialdeck-gameplay node scripts/test-setup-callable-local.mjs <output-json>` with local emulators running. Live provider calls incur API usage; synthetic benchmark output should remain outside the Git checkout.

## Local card-selection testing

The debug Firebase app includes the demo Storage bucket. The local configuration uses `firestore.gameplay-test.rules` and `storage.gameplay-test.rules`: these allow the exact demo HTTP image URL and owner folder listing needed by the existing deck uploader. They are emulator-only copies; never deploy them. Keep their shared rules synchronized with the production rule files. Production rules and deck upload code were not changed by this local configuration.

Party selection follows the team-approved Feature---Promptd implementation: Single Deck, Free-to-Choose and Camera Roll all select exactly seven cards. There is no Random option or draw from a larger selection. Disband returns Home; uncertain exit responses are checked against server state before reporting failure.
