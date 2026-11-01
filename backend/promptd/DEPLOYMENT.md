# Hosted Prompt’d AI deployment

Status on 2026-10-31: prepared locally, **not deployed**. The team's Firebase project already has billing enabled. The authorized university account can create functions, but Cloud Functions and Secret Manager APIs are disabled and it cannot enable APIs or create secrets. A project owner must complete that setup or provide deployment access.

The temporary alternative is now [PC hosting](PC_HOSTING.md); it requires no cloud deployment permission. Cloud deployment below remains pending.

## What teammates will do after deployment

Run the app normally and use their existing Firebase login. They do not run an AI server, enter an API key, or need Firebase Console access. During team testing, the server administrator adds each tester's Firebase Authentication UID to the server allowlist once. A signed-in account that is not listed receives an access error.

## What the server administrator does once

1. Use the existing `socialdeck-dev` project. Enable Cloud Functions, Cloud Build, Artifact Registry, Cloud Run, and Secret Manager APIs. Firebase deployment may also request supporting APIs/service agents; review those in this project.
2. Give the deployer the required Cloud Functions deployment permissions and Service Account User access on the runtime/build service accounts it will use. Creating a callable also requires setting its invocation policy. The runtime needs Firestore access and access to only its provider secret. Secret Manager access is separate from normal Firebase app login. An owner can do this deployment directly instead of granting broader access to a developer.
3. From this folder, run `npm ci`, `npm --prefix functions ci`, and `npm test`. Use Node 22 for the configured cloud runtime.
4. Copy `cloud.env.example` to `functions/.env.socialdeck-dev`. Use the existing provider/model settings, and enter the actual Firebase Authentication UIDs of allowed testers. That local file is ignored by Git. Leave App Check enforcement false until the app sends compatible tokens.
5. Store the team-approved provider API key in Secret Manager as `PROMPTD_OPENAI_API_KEY` (or `PROMPTD_GEMINI_API_KEY`). Use the Console's secret editor or the CLI's interactive input; do not put the key in a command, Flutter, Git, or the dotenv file. Inspect any existing secret with that name before replacing it.
6. Sign the Firebase CLI into an authorized deployment account, then run `npm run deploy:cloud`. This uses `firebase.cloud.json` and only the `promptd` functions codebase. It never deploys the team's root Firestore, Storage, Hosting, or Flutter configuration. The predeploy check rejects missing testers, credentials in dotenv, and a non-Promptd secret name. The upload excludes local env/secrets, tests, logs and HTML; generated shared contracts are included.
7. Enable Firestore TTL on the `expiresAt` timestamp for only these AI collection groups: `promptdSessions`, `promptdRequests`, `promptdLimits`, `promptdRecent`. Inspect existing TTL first. Logical expiry is already 24 hours; physical TTL deletion is asynchronous. Do not apply this TTL to Party records or saved Party summaries.
8. Test unauthenticated access, a denied account, and an allowed account. Generate five prompts, approve four, replace one rejected prompt, confirm the approved four stay unchanged, and approve the replacement. Test app restart and saved Party summaries separately. Then build the app normally, without local AI Dart defines.

## Function limits and behavior

The original generation/review/repair instructions, models, feedback, topic tags, rejected-only replacement, quotas and session logic are unchanged. Each function is capped at three instances, with concurrency ten and a 90-second timeout. Each user has the existing generation rate/daily limits. These are limits, not a guaranteed monthly spending cap. Hosting and provider usage are billed to the configured project/provider account. No computer needs to stay on once deployment succeeds.

The four HTTPS callable names remain `getPromptConfiguration`, `generatePromptExamples`, `generateNextPrompts`, and `submitPromptFeedback`, in `us-central1`. Calls require Firebase Authentication and the team tester allowlist. The AI service's internal Firestore records are written by the server; the current app rules do not expose these collections. The deployment does not change team rules.

## Files changed for hosting

- `lib/features/games/data/firebase_prompt_ai_repository.dart`: normal runs derive the hosted endpoint from the signed-in Firebase project; local emulators remain explicit.
- `scripts/run-promptd-android.ps1`: hosted default, optional `-LocalAi`.
- `backend/promptd/firebase.cloud.json`: functions-only codebase and upload exclusions.
- `backend/promptd/functions/src/index.mjs`: isolated cloud secret binding.
- `backend/promptd/scripts/check-cloud.mjs`: local deployment prerequisites.
- `test/features/games/prompt_ai_test.dart`: cloud routing/authentication/error regressions.

Official references: [Firebase codebases](https://firebase.google.com/docs/functions/organize-functions), [server secrets](https://firebase.google.com/docs/functions/config-env), [deployment IAM](https://cloud.google.com/functions/docs/reference/iam/roles), [Firestore TTL](https://firebase.google.com/docs/firestore/ttl).

<!-- IA: Keep deployment status honest. Preparing configuration does not make the cloud service live. -->
