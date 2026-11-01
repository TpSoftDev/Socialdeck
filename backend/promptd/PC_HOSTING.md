# Run Prompt’d AI from Ibrahim’s PC

This is the temporary team-testing option while Firebase cloud deployment permissions are being resolved. The existing AI instructions, review logic and rejected-only replacement are reused.

## On Ibrahim’s computer

Double-click `scripts/Start Promptd AI.cmd`, or run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/start-promptd-share.ps1
```

Wait for **AI sharing is READY**. The launcher checks the public link before calling it ready, then prints the teammate command. Keep this terminal, computer and internet connection running. To stop, press Ctrl+C or double-click `scripts/Stop Promptd AI.cmd`. Stopping lets current requests save before the tunnel closes. Starting twice is blocked so two servers cannot overwrite each other’s controls.

The launcher uses the already configured provider key in ignored `backend/promptd/functions/.secret.local`. No key is printed or sent to teammates. Only the host needs this configuration. Local `.host.local` can specify `PROMPTD_CLOUDFLARED` if cloudflared is not on PATH. Prerequisites for a new host computer are Node 22.13+ (this machine was tested with Node 24), `npm ci`, `npm --prefix functions ci`, a provider key/model and [cloudflared](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/downloads/).

## What teammates run

From the app checkout, use the URL printed by the host:

```powershell
flutter pub get
flutter run --dart-define=PROMPTD_SERVER_URL=https://THE-HOST-LINK.trycloudflare.com
```

Or on Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run-promptd-android.ps1 -ServerUrl https://THE-HOST-LINK.trycloudflare.com
```

Sign into Socialdeck normally, create/open a party, and choose Custom AI. Teammates need no AI provider key, local server, or Firebase deployment permissions. The host link is an API, not the web prototype UI.

The temporary hostname changes when sharing restarts. Teammates must stop their previous Flutter run and run the command again with the new URL; hot reload cannot change a Dart define. A stable hostname would require setting up a named tunnel/domain separately. Ordinary `flutter run` without the sharing define still selects the future Firebase-hosted endpoint, which is not deployed yet. `-LocalAi` remains the private, original emulator-only development mode.

## Data flow and access

App → HTTPS Cloudflare tunnel → AI server on Ibrahim’s PC → existing AI provider.

The user approved Cloudflare for this testing flow. Firebase login tokens and prompt data pass through Cloudflare; the provider key stays on the host PC. The API verifies real Firebase token signatures, project, expiry and non-anonymous login. It refuses emulator-auth mode and never exposes emulator controls, source files or secrets. During this temporary setup, signed-in, non-anonymous accounts in `socialdeck-dev` can use the link. Set `PROMPTD_TESTER_UIDS` to a comma-separated UID list in the host’s private configuration if restricting it to specific accounts.

The token verifier does not query administrative token-revocation status; existing tokens are valid until expiry. This avoids requiring new Firebase administrative credentials on the PC. Requests still use the existing per-user session ownership checks.

Temporary AI drafts, feedback and rate counters are stored privately in `backend/promptd/.share.local/sessions.sqlite`, so valid sessions survive restarting the host. Records expire after 24 hours without an update and expired records are removed at startup/hourly while running. This is separate from finalized Party summaries, which remain saved in team Firebase. No photo upload, Decks behavior, Party rules or profile/login code changes are included.

The PC wrapper allows at most three concurrent generations and 100 generation attempts per UTC day across the host, in addition to existing per-user limits. Cached completed retries do not count twice; failed generation attempts do count. `PROMPTD_HOST_DAILY_LIMIT` can adjust the host limit from 1 to 1000. These request limits are not a dollar spending cap. Existing provider API charges still apply.

## If Windows works but the Android app cannot connect

IA: A successful PC health check does not prove Android trusts the same HTTPS certificate. On this PC, Android reported `CERTIFICATE_VERIFY_FAILED`, and the tunnel certificate issuer was `AVG Web/Mail Shield Root` rather than the site's public certificate chain.

Keep HTTPS certificate verification and AVG enabled. Add only the current sharing hostname to AVG's Website/Domain exceptions, then retry in the app. Do not accept every certificate or put an antivirus root certificate in the app. A new Quick Tunnel hostname may need a new exception on this host computer. This is one reason a stable hostname is preferable for repeated team testing.

## Source map

- `lib/features/games/data/firebase_prompt_ai_repository.dart`: validated HTTPS sharing override and existing Firebase user token.
- `backend/promptd/functions/host/server.mjs`: only the four AI routes; authentication, body limits, request concurrency and host-wide quota.
- `backend/promptd/functions/host/local-store.mjs`: transactional temporary session storage, using the same interface as the Firestore store.
- `backend/promptd/functions/host/start.mjs`: existing provider/service wiring, loopback-only listener, expiry and shutdown.
- `backend/promptd/scripts/share.mjs`: tunnel lifecycle, public health check, generated connection instructions and local stop request.
- `scripts/start-promptd-share.ps1`, `stop-promptd-share.ps1`: host controls.
- `scripts/run-promptd-android.ps1`: teammate app launch with `-ServerUrl`.
- `backend/promptd/functions/test/pc-host.test.mjs` and `test/features/games/prompt_ai_test.dart`: hosting regressions.

All paths above are relative to the app repository. IA comments explain the changes in code. The private HTML report, keys, SQLite database, tunnel state and logs are excluded from commits/deployments.

[Cloudflare Quick Tunnel limitations](https://developers.cloudflare.com/tunnel/get-started/quick-tunnels/) include changing hostnames and no uptime guarantee. This is for team testing, not permanent production hosting.
