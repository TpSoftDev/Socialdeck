# Party backend and integration

The `lib/features/party` module supplies shared Party state and a functional
lobby. Prompt'd gameplay and AI generation belong to the separate games feature.
Use the regular app or Dev Tools → Party Dev → Live Party for backend testing.
Other frontend previews still use demonstration data.

## Responsibilities

- `domain/`: immutable snapshots, validation, transition policies and contracts.
- `data/`: Firebase transactions, serialization and the owned-card read adapter.
- `providers/`: authentication-scoped repositories and disposable subscriptions.
- `presentation/`: Home controls, live lobby, invitations and card selection.
- `test/features/party/`: policy, repository, widget and simulation checks.
- `test/party_rules/`: local Firestore authorization, concurrency and compatibility checks.

The module follows the existing Riverpod 2 provider approach. It introduces no
application packages or code generation.

## Supported behavior

- Create/join with a six-digit code and one persistent active party per user.
- Maximum eight players, minimum two to start; everyone must be ready.
- Every signed-in player may host the free beta.
- Live membership, name changes, promotion, kick, leave and disband.
- A departing host transfers to the earliest remaining joined player. A solo
  host closes the party. The transaction uses the latest roster; choosing Leave
  never silently becomes an explicit Disband action in the UI.
- Game/settings changes increment a revision and invalidate prior readiness.
  Saving identical settings preserves readiness.
- Seven distinct owned cards per hand; each player's hand is private, including
  from the host. Selecting cards clears that player's Ready state.
- Single-deck and random modes draw seven cards. Handpicked candidates may exceed
  seven; confirmation draws seven from that local pool.
- Browsing decks preserves the selection shelf. Both Android Back and the app
  back arrow return from a deck to the deck list first.
- Switching selection method clears the saved hand and Ready; cancelling the
  method sheet does not. Deleted decks/cards cannot remain selectable in the UI.
- In-app invite creation, acceptance and decline. Acceptance joins atomically;
  code sharing works independently of the friends list.
- Host controls recheck current authority after dialogs. Card confirmation
  requires current membership, lobby phase and successfully loaded catalogs.
- Back navigation or closing a page does not remove persistent membership.

`startGame` only changes the phase to `playing`. It does not implement dealing,
rounds, submissions, voting, scores or results. Stored `mixCards` and `safeMode`
values are settings, not implementations of dealing or moderation.

## Firestore paths

| Path | Purpose |
| --- | --- |
| `parties/{sixDigitCode}` | Host, phase, ordered membership, game, revision, timestamps |
| `partySessions/{uid}` | Active party ID or null |
| `parties/{code}/hands/{uid}` | Private cards and selection revision |
| `parties/{code}/events/{eventId}` | Immutable promotion/kick notifications |
| `partyInvitations/{code}_{recipientUid}` | Sender, recipient, status and timestamp |
| `users/{uid}/partyDecks/{deckId}` | Owned deck name and optional favorite flag |
| `users/{uid}/partyCards/{cardId}` | Owned card's deck ID and HTTPS image URL |

Lobby records contain counts and readiness, never private image URLs. An
authenticated user who knows a code can fetch its lobby; unrestricted party
listing is denied. `memberIds` defines succession order because Firestore map
ordering is not join order. Initial event history is not replayed as notifications.

Repositories are bound to an authenticated UID. Auth changes recreate their
providers; disposing subscriptions never deletes membership. Use
`Party.isReady(uid)` instead of reading the raw Ready flag, because revisions
invalidate old selections.

```dart
final state = ref.watch(partyActionsProvider);
final party = ref.watch(activePartyProvider);
final actions = ref.read(partyActionsProvider.notifier);
// Await persistence and check mounted before navigating.
final success = await actions.createParty(name);
```

## Integration still needed

- The team's Decks prototype stores local photo IDs in `test_decks`; it does not
  populate the Party catalog with usable image URLs. Preserve that implementation
  and agree on the upload/adapter contract before connecting it. No existing
  decks or photos are migrated automatically.
- `partyFriendsProvider` returns an empty list until Social supplies actual
  friendships/presence. Code-based joins remain available.
- Character IDs are supported by the backend, but the character catalog/picker
  still needs integration. OS sharing, push notifications and visual polish are
  separate frontend work.
- No host election on disconnect, invitation expiry, permanent kick bans or
  closed-party cleanup policy is implemented. Closed codes are not reused.
- Google sign-in on the local Android build still needs a team project owner to
  register its signing fingerprint; the current CLI account cannot manage apps.
  This does not prevent email/password testing.

## Rules and deployment status

As of October 8, 2026, the normal Android test build targets `socialdeck-dev`.
Combined Firestore rules were deployed in the preceding integration step. The
original team rules were preserved verbatim; Party definitions were appended.
`firestore.rules` is that combined file. `storage.rules` is an unchanged snapshot
of the team's deployed Storage rules. Storage was not deployed by this work.

`firestore.party.rules` and `firebase.party.json` are for isolated local testing.
**Never deploy the standalone Party rules as the team's complete ruleset.**
They deny unrelated paths. Compatibility tests preserve existing team behavior,
including known broad profile/test-deck permissions; they do not endorse or
repair those permissions.

The October 8 audit below made no new cloud deployment or shared-data changes.
Git integration targets `Feature-Party`; pushing code does not deploy Firebase.

## Verification

```powershell
flutter test test/features/party test/outline_button_layout_test.dart test/welcome_layout_test.dart
dart analyze lib/features/party test/features/party
npm --prefix test/party_rules ci
./test/party_rules/node_modules/.bin/firebase emulators:exec --only firestore --project demo-socialdeck-party --config firebase.party.json "node --test test/party_rules/party_rules.test.cjs"
```

With a disposable local Firestore emulator on port 8085, compare a saved original
rules snapshot with the combined candidate:

```powershell
node test/party_rules/check_compatibility.cjs ORIGINAL_RULES_FILE OUTPUT_DIRECTORY
```

These tests use synthetic data and reset their local emulator projects. They
require no cloud credentials; do not use a shared emulator containing needed data.

October 8 audit results:

- 81 targeted Flutter tests passed, including 77 Party tests and a seeded simulation
  covering 30,000 policy transitions.
- 27 Firestore permission/concurrency tests passed using the combined rules.
- 69 compatibility scenarios matched the original team rules.
- Party Dart analysis: no issues.
- Card sampling uses seven random draws for a seven-card hand from a 10,000-card
  catalog. Deduplication still scans the catalog once. An exhaustive small-pool
  test checks selection without replacement and equal-probability outcomes.
- Regressions cover stale host dialogs, join-during-leave, removed players,
  closed/started lobbies, deleted decks, failed subscriptions and Android Back.
- Concurrency coverage includes duplicate creates, twelve simultaneous joins,
  duplicate joins, settings racing start, stale Ready after kick, and full-party
  disband with eight private hands.

The original `test/widget_test.dart` is the generated counter-app test and is not
part of the 81 checks above. A separate run fails because it omits ProviderScope
and still expects a counter app. It remains unchanged with the team code.

The installed Flutter version requires newer test-only lockfile resolutions than
the checkout. Checks/builds use the prepared temporary copy; the team's checked-in
dependency files are preserved. A prior live smoke test passed seven backend
groups using disposable accounts and cleaned them up. This audit uses local
tests and does not claim a complete live gameplay or Google sign-in test.
