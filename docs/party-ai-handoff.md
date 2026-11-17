# Party / Custom AI integration handoff

## Included in this update

- Normal app flow: Party → Select Game / Game Library → Custom AI → group, topics and style → generate five examples → approve/reject → replace only rejected examples → finalize → Save & Continue → same live party.
- Multiple predefined/custom group and topic choices, optional group description and average group age, Safe Mode default on, and feedback reasons.
- Finalized examples retain their IDs/text/topic labels. Topics & Examples pages through those saved examples; it does not generate another batch.
- The host saves settings and the five-example summary together in a Firestore transaction. Members subscribe to `parties/{partyId}/aiSetup/current`, including after restarting. Membership, host, lobby phase and settings revision are checked. The Firestore rules addition leaves the existing team rules intact.
- Existing Decks screens can be opened from Pick 7 Cards in Single Deck, Free-to-Choose or Random preview mode. The shared selection draft survives deck navigation and is invalidated if the account/party/revision changes.

## Four-layer reference

| Layer | Main files | Responsibility |
| --- | --- | --- |
| Presentation | `lib/features/games/presentation/pages/prompt_custom_setup_page.dart`, `prompt_settings_page.dart`, `party_topics_examples_dialog.dart`; `lib/features/party/presentation/party_lobby_page.dart` | Approved screens, user input, navigation and current feedback |
| Provider/controller | `lib/features/games/providers/game_setup_provider.dart`, `custom_party_preview.dart` | Draft state, account scope, review/replacement flow and summary subscriptions |
| Domain | `lib/features/games/domain/game_setup_state.dart`, `prompt_ai.dart`, `party_ai_setup.dart` | Valid selections, five-example session/approval rules and repository contracts |
| Data | `lib/features/games/data/firebase_prompt_ai_repository.dart`, `firebase_party_ai_setup_repository.dart`, `party_ai_setup_mapper.dart` | Callable requests, account checks, Firestore transaction and serialization |

The Android launcher is `scripts/run-promptd-android.ps1`; it supplies the local AI Dart defines. Server source, pinned Firebase CLI and complete setup commands: [backend/promptd/README.md](../backend/promptd/README.md).

## What is deliberately unfinished

**The local Decks selection is a preview, not a saved multiplayer hand.** It does not upload photos, write the selected local files to Party, or enable Ready from that preview. The previous Party repository expects shared HTTPS card references. Temporary sharing, access control, retention and storage choices still need team agreement and implementation. Quick Pics remains outside this preview because its photos are not part of the shared saved-deck collection. Normal deck management retains its existing behavior.

The AI callable server is included but not deployed by this update. Existing Firebase app logins need no changes. The API key setup is only for developers running a local AI server; normal app users never enter a provider key. An ordinary build without `PROMPTD_PROJECT_ID` cannot generate examples. Use the documented emulator build for local AI testing. Existing saved summaries still come from team Firestore.

## Review checks, 2026-10-31

- Final rerun: 243 app tests passed (including all 239 feature tests). The default suite skips the opt-in live AI test; it was then enabled and passed separately.
- The live test generated five examples, kept four approved examples unchanged while replacing the rejected one, verified custom topic tags, and finalized five approved examples. The running server source/contracts matched the packaged source before the test.
- Android x64 debug build passed.
- Packaged AI server startup smoke passed: four callables loaded, local auth/authorization checked, no model API call. Firebase CLI 15.30.2 is pinned to match the working prototype.
- 52 AI backend tests passed with mocked providers/storage.
- AI summary and Party rules suites plus 69 existing-team permission compatibility cases passed against the local Firestore emulator.
- The repository still contains an unchanged default counter test (`test/widget_test.dart`) for an app screen that no longer exists; the full root test command fails there. It is not part of this feature update.
- Whole-repository analysis also sees private rollback source and an independent Widgetbook package without installed dependencies. Analyze `lib` and `test` to check the actual app. Existing lints in teammate source remain unchanged.

Regression review corrected the new summary provider's scoped dependencies and updated existing tests for the approved Game Library / options-menu navigation and Save & Continue label. Dev fixtures explicitly supply mock AI repositories; normal app builds retain the real adapter.

Private HTML reports, rollback backups, credentials, local logs and model evaluation results are excluded from this commit.
