# Prompt’d AI server for the Flutter app

This is a server-only snapshot of the existing Prompt’d prototype. The web UI and private reports are not included. Gemini/OpenAI calls, prompt instructions, feedback, replacement logic, quotas and validation stay on the server. The Flutter app uses `FirebasePromptAiRepository`.

## Current shared testing: host it on Ibrahim’s PC

Use [PC_HOSTING.md](PC_HOSTING.md). Ibrahim starts the sharing launcher and teammates run the app with the HTTPS URL it prints. They keep their existing Firebase login and need no API key or local AI server. The link works while Ibrahim’s PC is hosting and changes after a restart.

## Existing app login stays the same

If you can already sign into Socialdeck in your Android emulator, keep using that login. This integration does not require a new Firebase account, new project permissions or another Firebase sign-in configuration.

Hosted AI support is prepared, but the cloud service is **not deployed yet** because project-level API/secret permissions are missing. See [deployment status and instructions](DEPLOYMENT.md). After deployment and one-time tester allowlisting, normal `flutter run` uses hosted AI with the existing login. Teammates need no provider key or local server.

The separate setup below is only for developers running the **local AI server**. That server needs a provider API key: use a developer-owned key or a team-approved key shared privately. The mobile app and its players never receive or enter that key. Starting only the Android emulator does not start a local AI server; for shared testing, use the active PC sharing URL above.

<!-- IA: App authentication and local AI server credentials are separate. -->

## Run locally

Use Node 22, Java 21, Flutter and an Android SDK/emulator. Add Node, Java and Flutter to PATH. From `backend/promptd` (relative to the app checkout):

```powershell
npm ci
npm --prefix functions ci
npm run sync
Copy-Item functions/.env.example functions/.env.local
Copy-Item functions/.secret.local.example functions/.secret.local
```

Edit the local files: select `PROMPT_PROVIDER=openai` (or `gemini`), set the corresponding model, and provide a developer-owned or team-approved provider key in `.secret.local`. These files are ignored. The current OpenAI adapter defaults to `gpt-6.1-sol`; use a model your account can access. Never place provider keys in Flutter or a Dart define.

```powershell
npm run emulators
```

The pinned local Firebase CLI (15.30.2, matching the working prototype) is installed by `npm ci`; no global Firebase CLI is needed. Keep this terminal running.

Stop an earlier emulator on the same ports before starting a second instance. Auth uses 9099, Functions 5001, and Firestore 8080. Run Flutter from the app root in another terminal:

```powershell
flutter pub get
flutter emulators
# Start your Android AVD if it is not already open:
flutter emulators --launch YOUR_AVD_ID
powershell -ExecutionPolicy Bypass -File scripts/run-promptd-android.ps1 -LocalAi
```

The launcher defaults to hosted AI; `-LocalAi` selects this local server. The device defaults to `emulator-5554`; pass `-Device emulator-5556` if needed (`flutter devices` lists IDs). On macOS/Linux, use `flutter run --dart-define=PROMPTD_EMULATOR_HOST=10.0.2.2 --dart-define=PROMPTD_PROJECT_ID=demo-socialdeck-promptd` and choose the Android emulator. Sign into the team app, create a party, then choose Custom AI. The Android image should include Google Play services if using Google sign-in.

`10.0.2.2` reaches this computer from the Android emulator. The app still signs into the team Firebase project for Party/profile data. AI testing uses a separate anonymous emulator session; no team accounts are copied. Live model requests cost API credits even when Firebase runs locally. Unit tests below do not call a live model.

## Tests

```powershell
npm test
```

A local startup smoke check also loaded all four functions, rejected unauthenticated access and accepted an emulator-authenticated configuration request without calling a model. Run `node scripts/smoke.mjs` while the default demo emulators are running to repeat it.

The 60 server regressions cover PC-host authentication/persistence/limits, contracts, feedback, rejected-only replacement, unchanged accepted prompts, topic tags, model transport, deadlines and audience policy. They use fake storage/providers; live output quality and deployed Node 22 behavior require separate verification. This verification machine used Node 24; Node 22 is the configured functions runtime.

## Source map

- `functions/src/index.mjs`: authenticated callable endpoints; cloud tester allowlist.
- `functions/src/service.mjs`: five-card sessions, approvals, replacement and idempotency.
- `functions/src/structured-provider.mjs`: generation, semantic review and targeted repairs.
- `functions/src/PROMPT_GENERATOR.md`, `PROMPT_REVIEWER.md`, `CONTENT_POLICY.md`: model guidance.
- `functions/src/openai.mjs`, `gemini.mjs`: provider transports.
- `functions/src/firestore-store.mjs`: server session storage.
- `shared/prompt_system/`: canonical config and JSON contracts. The sync script copies these into ignored `functions/shared`.

## Hosted deployment and retention

`firebase.cloud.json` isolates our `promptd` functions codebase. It does not deploy team rules or other modules. See [DEPLOYMENT.md](DEPLOYMENT.md) for the current access blocker, secure server-key setup, tester allowlist and cloud verification steps. A configuration file alone does not mean the server is online.

AI session records have a 24-hour logical expiry. Physical Firestore TTL must be enabled separately for `promptdSessions`, `promptdRequests`, `promptdLimits` and `promptdRecent`. Saved Party summaries under `parties/{partyId}/aiSetup/current` are separate and do not inherit that expiry. No photo uploads or photo cleanup are implemented here.

This is the reference server snapshot for the mobile integration. Coordinate later prototype changes so the two copies do not silently diverge.

## If a fresh checkout cannot connect

- For current PC sharing, use the active HTTPS URL and command in [PC_HOSTING.md](PC_HOSTING.md). The host PC must be running. Teammates need no AI key.
- Hosted mode requires the shared cloud deployment to be finished and your Firebase UID to be allowed by its administrator. No local API key is needed.
- For explicit local mode only, keep `npm run emulators` running as well.
- Do not use plain `flutter run` for local AI; use `-LocalAi` or the explicit local defines above.
- Configure only the selected provider’s key/model. Provider access and billing errors are not Firebase sign-in errors.
- Allow local ports 5001/9099/8080 through your firewall without disabling security tools.
- Existing working app logins need no changes. Only if Google sign-in rejects a new developer’s debug certificate does a project owner need to register that developer’s Android SHA fingerprint. Players do not need Firebase Console/IAM access. No signing keys or private account credentials are included.
- Private HTML reports and local secret files are deliberately absent. The source and public configuration are included.
