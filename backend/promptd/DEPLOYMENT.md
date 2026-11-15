# Hosted Prompt’d AI deployment

Status on 2026-11-15: **deployed and live-tested** in `socialdeck-dev`, `us-central1`.

- All four Node 22 callable functions are ACTIVE.
- `PROMPTD_ACCESS_MODE=signed-in` permits new and existing non-anonymous Firebase accounts. Authentication and per-user service limits remain required.
- The existing provider/model and generation/review/replacement logic are unchanged. The provider key is bound through the dedicated Secret Manager secret.
- 62 backend tests and 14 Flutter AI tests passed (the opt-in Flutter live test was skipped). A separate live HTTPS test used a new disposable Firebase email/password account: generated five tagged prompts, rejected one, preserved the approved four exactly, approved the replacement, and deleted the test account. Unauthenticated configuration access returned 401.
- A fresh debug APK was built without tunnel/local-AI overrides and installed in the Android emulator. Ibrahim confirmed Custom AI works after adding the cloud hostname to his AVG exception list. The separate full create-party and multi-phone flows were not retested. Existing adapter tests verify default cloud routing.
- TTL cleanup was requested for the four temporary AI collection groups only. Logical expiry remains 24 hours; physical TTL removal is asynchronous.
- Remaining infrastructure housekeeping: deployer lacks `artifactregistry.repositories.update`, so old build-image cleanup could not be configured. An authorized maintainer can configure a seven-day cleanup policy on `gcf-artifacts` in `us-central1`. This does not block the deployed functions.
- This migration changes only AI hosting/access code and its documentation. Party/Decks code, Firestore rules, and Storage rules are excluded.

<!-- IA: Record observed cloud verification separately from app UI testing. -->

## What teammates will do after deployment

Run the app normally and use their existing Firebase login. They do not run an AI server, enter an API key, or need Firebase Console access. Newly registered accounts work without manual allowlisting. Anonymous Firebase accounts and requests without a verified Firebase login are rejected. Stop any previous Flutter run with a tunnel/local override and rebuild normally.

## What the server administrator does once

1. Use the existing `socialdeck-dev` project. Enable Cloud Functions, Cloud Build, Artifact Registry, Cloud Run, and Secret Manager APIs. Firebase deployment may also request supporting APIs/service agents; review those in this project.
2. Give the deployer the required Cloud Functions deployment permissions and Service Account User access on the runtime/build service accounts it will use. Creating a callable also requires setting its invocation policy. The runtime needs Firestore access and access to only its provider secret. Secret Manager access is separate from normal Firebase app login. An owner can do this deployment directly instead of granting broader access to a developer.
3. From this folder, run `npm ci`, `npm --prefix functions ci`, and `npm test`. Use Node 22 for the configured cloud runtime.
4. Copy `cloud.env.example` to `functions/.env.socialdeck-dev`. Use the existing provider/model settings, and set `PROMPTD_ACCESS_MODE=signed-in` for normal signed-in users, or choose `allowlist` and enter the Firebase UIDs of allowed testers. That local file is ignored by Git. Leave App Check enforcement false until the app sends compatible tokens.
5. Store the team-approved provider API key in Secret Manager as `PROMPTD_OPENAI_API_KEY` (or `PROMPTD_GEMINI_API_KEY`). Use the Console's secret editor or the CLI's interactive input; do not put the key in a command, Flutter, Git, or the dotenv file. Inspect any existing secret with that name before replacing it.
6. Sign the Firebase CLI into an authorized deployment account, then run `npm run deploy:cloud`. This uses `firebase.cloud.json` and only the `promptd` functions codebase. It never deploys the team's root Firestore, Storage, Hosting, or Flutter configuration. The predeploy check rejects invalid access modes, missing testers in allowlist mode, credentials in dotenv, and a non-Promptd secret name. The upload excludes local env/secrets, tests, logs and HTML; generated shared contracts are included.
7. Enable Firestore TTL on the `expiresAt` timestamp for only these AI collection groups: `promptdSessions`, `promptdRequests`, `promptdLimits`, `promptdRecent`. Inspect existing TTL first. Logical expiry is already 24 hours; physical TTL deletion is asynchronous. Do not apply this TTL to Party records or saved Party summaries.
8. Test unauthenticated access, a denied account, and an allowed account. Generate five prompts, approve four, replace one rejected prompt, confirm the approved four stay unchanged, and approve the replacement. Test app restart and saved Party summaries separately. Then build the app normally, without local AI Dart defines.

## Function limits and behavior

The original generation/review/repair instructions, models, feedback, topic tags, rejected-only replacement, quotas and session logic are unchanged. Each function is capped at three instances, with concurrency ten and a 90-second timeout. Each user has the existing generation rate/daily limits. These are limits, not a guaranteed monthly spending cap. Hosting and provider usage are billed to the configured project/provider account. No computer needs to stay on once deployment succeeds.

The four HTTPS callable names remain `getPromptConfiguration`, `generatePromptExamples`, `generateNextPrompts`, and `submitPromptFeedback`, in `us-central1`. Calls require Firebase Authentication. The current signed-in mode rejects anonymous accounts; optional allowlist mode restricts access to configured testers. The AI service's internal Firestore records are written by the server; the current app rules do not expose these collections. The deployment does not change team rules.

## Files changed for hosting

- `lib/features/games/data/firebase_prompt_ai_repository.dart`: normal runs derive the hosted endpoint from the signed-in Firebase project; local emulators remain explicit.
- `scripts/run-promptd-android.ps1`: hosted default, optional `-LocalAi`.
- `backend/promptd/firebase.cloud.json`: functions-only codebase and upload exclusions.
- `backend/promptd/functions/src/index.mjs`: isolated cloud secret binding.
- `backend/promptd/scripts/check-cloud.mjs`: local deployment prerequisites.
- `test/features/games/prompt_ai_test.dart`: cloud routing/authentication/error regressions.

Official references: [Firebase codebases](https://firebase.google.com/docs/functions/organize-functions), [server secrets](https://firebase.google.com/docs/functions/config-env), [deployment IAM](https://cloud.google.com/functions/docs/reference/iam/roles), [Firestore TTL](https://firebase.google.com/docs/firestore/ttl).

<!-- IA: Keep deployment status honest. Preparing configuration does not make the cloud service live. -->

## Local antivirus troubleshooting

IA: On Ibrahim’s PC, AVG intercepted `us-central1-socialdeck-dev.cloudfunctions.net` with its own certificate. Android rejected the connection. A hostname exception restored the Google Trust Services certificate and the user confirmed AI generation works. This is not a standard teammate setup step. Keep TLS validation and antivirus enabled; investigate a certificate error before adding an exception.
