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
- Party reads accepted Firebase friendships. Social friend-request flows and
  presence still need integration. Code-based joins remain available.
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


## October 15 frontend integration

Merged remote `Feature-Party` through `01348a18` without conflicts. Incoming
changes add working setup controls, fix custom text entry, and update lobby
previews. The existing games setup provider/repositories remain the team baseline.

Live Party now opens the team's `PromptSettingsPage` through
`PartySettingsPage`. It loads the persisted rounds, Mix Cards and Safe Mode into
a route-local draft. Back to Party awaits the existing Firebase Party command;
Cancel/system Back discard unsaved edits. Failed saves retain the draft for retry.
Saving identical values preserves readiness through the existing repository policy.

The page blocks stale callbacks after host/membership/phase/auth changes, failed
snapshots, or a settings revision change. A signed-out action provider now becomes
idle instead of throwing while the UI rebuilds. The settings heading wraps on
small phones without changing the shared header component.

Dev preview routes return to the appropriate Normal or Custom lobby. They remain
previews: use Home or Dev Tools > Party Dev > Live Party for persisted Party tests.
Custom environment/mood/keywords and prompt generation remain owned by the games
feature; its generation/feedback repository is still a mock. Mix Cards and Safe
Mode are saved preferences, not implementations of dealing or content filtering.

Validation: 95 targeted Flutter tests passed, including 14 new settings tests
covering actual preview routes, saving/retry, cancellation, sign-out, stale rights,
revision changes, duplicate taps, and 320x640 layout with round limits. The team's
original counter-app test remains excluded as described above. No Firebase rules,
shared data, dependency lockfiles, or cloud deployments changed in this wiring step.

Android x64 emulator APK builds successfully. The all-architecture APK build was
blocked while downloading an ARM engine dependency by the local Java trust-store
error (trustAnchors must be non-empty); it was not a Dart compilation failure.
No emulator was connected for installation during this pass.

### Follow-up race-condition audit (October 15)

- Live settings now pass their original revision through the action provider to
  the Firebase transaction. A concurrent settings change rejects the stale draft
  with a conflict instead of overwriting newer settings, including on retries.
- The settings route keeps observing the action provider during pending saves.
- Added stale-revision, matching-revision, and unchanged-settings write checks;
  widget tests also require live saves to forward their draft revision.
- Validation: 98 targeted tests passed, including 30,000 seeded lobby transitions;
  targeted Dart analysis passed. These are automated local checks, not a fresh
  live Firebase or device sign-in verification. No deployment or push performed.

### Shared team lobby integration (October 15, unpushed)

The normal `/home/party/:partyId` route and the live session route now render
`InviteSheetPage` with `PartyLobbyBinding`, rather than a separately built lobby.
The existing preview constructors still render sample data and are listed under
Frontend previews in Dev Tools. The live screen does not use those sample values.

- `party_lobby_binding.dart`: typed seats keyed by UID, party code, phase, host,
  readiness and callbacks; no Firebase dependency in the team UI.
- `invite_sheet_page.dart`: original layout consumes the optional binding; live
  mode uses the app shell navigation instead of adding another disabled navbar.
- `party_lobby_page.dart`: subscribes to Firebase, supplies the binding, and keeps
  guarded settings, invitations, cards, rename, promotion, kick, leave and start
  actions. Uses the team's options/profile-sheet components for live controls.
- Regression coverage includes same-name player IDs, live role changes, stale
  actions, narrow screens, settings persistence, and the existing Party policies.
- Emulator verification through normal Home: created party 103912, opened the
  team lobby, saved/reopened 4 rounds and Mix Cards, opened card selection and
  verified that an empty real catalog cannot be submitted.

Remaining integration boundaries (not implemented by this change):
- Decks prototype `test_decks.photoIds` is device-local media, not a shareable
  Party card catalog. No automatic photo upload/conversion is implemented.
- Social friend-request management and presence remain separate work; Party reads accepted friendships.
- Prompt'd custom AI generation and gameplay remain outside this Party lobby.
  Selecting game settings stores flags; it does not implement dealing/filtering.
- Two-device live joining, host transfer and full gameplay were not verified in
  this emulator pass; host/permission transitions are covered by widget/policy tests.

### Firebase friends used by Party

Party reads accepted records from `friends/{currentUid}/members/{friendUid}`.
Each record contains `username` and `status: accepted`; selections use the document
UID, so duplicate display names remain separate invite targets. Reciprocal records
are provisioned by trusted Social/admin flows. Clients may only read their own
records, and cannot forge friendships. This is a Party read adapter, not a new
friend-request UI. Presence is not implemented, so no online status is invented.

For emulator testing in `socialdeck-dev`, IA Test Alex and IA Test Sam are real
Auth/profile fixtures with reciprocal accepted records for ForasTest. Fixtures
are marked `testFixture: true`; credentials are kept outside the repository.
The existing `friends/test` placeholder and teammates' profiles are untouched.

### No-friends edge case preview

The empty-friends scenario is retained as an automated test fixture only.
It reuses the production invite screen with a locally scoped empty friends feed
and clearly labeled sample code `123456`. No Firebase records are changed.
Expected: the empty-state message appears, Invite is disabled, and copying the
code still works. The team can refine the shared empty-state UI later.

### Invitation feedback and edge cases

The live lobby uses Party Dev's toast queue: the invite sheet closes after the
batch, errors appear as **Invite Error**, and a successful batch shows **Invite
Sent** with the Social inbox description. Sending never adds a player to the
roster; they must accept. Existing members are rejected by UID in the transaction.
Full/closed/started parties, removed senders and account changes are guarded by
the repository. One failed recipient does not hide other successes. Closing the
sheet cancels unsent recipients; friends removed mid-batch are skipped. Repeated
invites reuse the same party/recipient document, so they do not duplicate inbox
entries. A recipient in another party must resolve their current membership
before accepting; sending an invite does not move them automatically.

### Migration and frontend edge-case review (IA)

Normal Party now uses the Dev event toast queue, keeps the player sheet open
when Kick confirmation is cancelled, renders received invites with the shared
People tile, uses the Home in-game-name preset when joining, and opens the shared
Game Library for first game selection. Normal leads to live settings; Custom AI
is unavailable in this live path while its backend remains unfinished.

Player sheets use the current account profile or accepted-friend names when
available. Unknown mutual counts and public-profile links are deliberately not
fabricated. Public-profile navigation still needs the Social feature. Card
selection uses shared navigation/buttons and a shared method sheet; its existing
saved-hand semantics and teammate-owned deck storage are unchanged. The duplicate
lobby code label was removed; code copying remains in the approved invite sheet.

The Edge Cases gallery and No Friends shortcut were removed from Dev Tools at
user request. Their local fixtures now live under test/features/party/support
and remain covered by automated regression tests. Production guards and empty,
loading, and error states are unchanged. The scenario explanations are provided
in the chat for frontend review, rather than exposed as app navigation.


### Invitation resend cooldown (IA)

Hey team: repeatedly sending an invite used to overwrite the same inbox entry
and refresh its timestamp without waiting. It did not create duplicate entries,
but users could still spam the send action.

1. Send an invitation to a friend.
2. Try again before 60 seconds have passed, even after reopening the sheet.
3. Show "Invite already sent" and leave the existing invitation unchanged.
4. Once 60 seconds have passed, allow a resend using the same inbox document.
5. A successful resend starts another 60-second cooldown.

The cooldown belongs to the party/recipient pair, not a particular sender or
screen. `createdAt` stores the last successful send time, including resends.
The repository checks it inside the transaction for useful feedback; Firebase
rules enforce the interval using server time. A device clock mismatch can affect
client feedback, but cannot bypass the server restriction. Accepting or declining
is allowed immediately. Declining does not reset the timer, and players already
in the party remain ineligible for invitations after the timer expires.

Regression checks cover immediate/59-second rejection, 60/61-second allowance,
server rejection of rapid resends, and decline without bypassing the cooldown.
This explanation stays in documentation; no Dev edge-case screen was added.


### Future frontend TODOs (IA)

- **Ready / Start layout review — deferred to frontend.**
  Hey frontend team: compare the normal Party lobby's Ready button, host Start
  Game button, and selected-card count with the approved frontend screens.
  Review placement, sizing, spacing, and enabled/disabled presentation on narrow
  screens and with larger text. This is a pending comparison, not a confirmed
  layout bug. Keep the existing readiness, membership, and host permission checks.
  The user deferred this review to future TODO; no behavior change was made. — IA


- **Invitation Join button is cramped/clipped — deferred to frontend.**
  Hey frontend team: receive a party invitation, then open Social → Inbox on a
  narrow phone/emulator. The row's image, text, decline icon and Join button
  share the available width; the Join label appears clipped/cramped. Review
  the fixed 40px button height together with the shared button padding and
  row spacing. Keep the existing design and join/decline permissions; verify
  readable labels in enabled and disabled states and with larger text.
  The user explicitly deferred this layout fix. No layout change was made. — IA


### Implemented edge case: invitation sender name unavailable (IA)

1. Someone sends you a party invitation.
2. The inbox resolves their name by sender UID: an available accepted-friend
   username first, then that sender's in-party name.
3. When available, show "[name] invited you" with the existing party code.
4. If the name is missing, blank, still loading, or cannot be read, show
   "Party invitation". Join and Decline remain governed by Party permissions.
5. A host transfer must not relabel the invitation as coming from the new host.

Implemented: sender-name wiring and generic fallback. This does not read private
profile documents or add profile-photo support. If the sender has left and no
friend name is available, the generic label remains.

Future frontend TODO — IA: review long names and text scaling in the invitation
tile. The current single-line title uses ellipsis; frontend may need to adjust
layout/spacing so the sender and action labels stay understandable. No new Dev
edge-case screen was added, and the deferred Join-button layout is unchanged.


### Practical edge cases: explanation, frontend TODO, and phone confirmation (IA)

These seven flows are the active checklist. Backend safeguards are implemented
and automatically tested; frontend approval and real-phone confirmation remain
pending. Rare account-switch/open-popup and same-account/two-device variants
remain regression tests only, not additional frontend or phone-testing tasks.

#### 1. Sending and receiving invitations

Here is the situation:
1. You select Alex and Sam and press Invite.
2. Alex receives an invitation, but Sam's request fails or Sam is already in the party.
3. Feedback must identify Alex's success and Sam's failure separately.
4. If you retry Alex within one minute, show that the invitation was already sent.
5. If you close the sheet during sending, stop remaining unsent recipients;
   a request already submitted may still finish.

Implemented: per-recipient results, named mixed successes, one-minute persisted
cooldown, duplicate-tap guard, and stopping after dismissal/access loss/closure.
The recipient can accept or decline in the real inbox. Available sender names
are shown with a generic fallback when unavailable.
Frontend TODO — IA: fix cramped Join text; review long sender names, empty inbox,
already-in-another-party messaging, cooldown feedback, mixed-result readability,
and explaining partial completion after closing. Use the existing team design.
Phone confirmation: send/accept/decline, resend before and after a minute, test a
mixed batch, and close a slow batch. Check actual inboxes against the messages.

#### 2. Joining a full party

Here is the situation:
1. The party has seven players and one free seat.
2. Two invitees try to join around the same time.
3. One joins; the other sees "This party is full (8 players)."
4. The unsuccessful invitee stays outside, can decline, or retry if a seat opens.

Implemented: transactional capacity check and independent server enforcement;
no ninth member or partial session/invitation claim. The name popup closes and
the inbox remains usable after rejection.
Frontend TODO — IA: review the full-party explanation and clear retry/decline
presentation without making a failed join appear successful.
Phone confirmation: attempt the final seat from two accounts; verify eight total
members and correct feedback/session state for the unsuccessful account.

#### 3. Leaving or getting kicked

Here is the situation:
1. The host opens Kick for Alex.
2. Alex leaves before the host confirms.
3. The popup says Alex is no longer in the party and disables Kick.
4. Similarly, if Alex has Change Name open when kicked, Alex cannot submit it.

Implemented: live membership guards and stale-callback checks; the Kick popup
explains departure. Party nicknames do not overwrite the account's default name.
Frontend TODO — IA: review removed-player messaging, disabled/closed dialog
behavior, and the path back to Home. Avoid a disabled button with no explanation.
Phone confirmation: leave while Kick is open, then separately kick a member with
Change Name open. Check both phones and verify the default name outside the party.

#### 4. Party disbanding

Here is the situation:
1. Members are viewing a party and another person has an invitation.
2. The host disbands it.
3. Members see "This party has ended" and can go Home.
4. The invited person tries to join using the old invitation and is rejected.

Implemented: closed-party guards, atomic disband/session handling, ended-lobby
feedback and Home navigation. Old invitations cannot revive the party; Decline
still works. Automatic expiry/removal of old invitations is not implemented.
Frontend TODO — IA: approve the ended-party screen and old-invitation message;
review whether an ended/expired label should replace a retryable Join control.
Automatic invitation cleanup remains separate future backend work.
Phone confirmation: disband while another phone views the lobby, then attempt to
accept an older invitation. Confirm no join, no stuck popup, and usable navigation.

#### 5. Connection loss and recovery

Here is the situation:
1. You are in a party and your phone loses its connection.
2. Firebase may temporarily retain previously loaded data.
3. Once it reports cache-only state, the app stops using that as current permission
   evidence and shows "Waiting for server confirmation."
4. When server-confirmed data returns, the screen recovers with current membership.

Implemented: metadata-aware Party/session streams, error/recovery handling,
permission guards, and transaction checks. Detection is not instantaneous; initial
loading can also produce cache-only data, so the message does not assert offline.
Frontend TODO — IA: approve loading/connection feedback, Retry and Home placement,
and how the screen communicates unavailable actions without appearing frozen.
Phone confirmation: disconnect/reconnect; also have the host remove the member
while disconnected and check that reconnecting does not restore old permissions.

#### 6. Friends loading, errors, and list changes

Here is the situation:
1. You open Social or the Party invitation sheet.
2. Friends may still be loading, genuinely empty, or unavailable due to a failed read.
3. These states must not all appear as "no friends."
4. A friend removed from the available list during selection/sending must not
   remain a hidden invitation target.

Implemented: Social and Party share accepted Firebase friendships; loading,
empty and retry states exist. Missing recipients are skipped during a batch.
This list check is not a new server friendship-authorization rule.
Frontend TODO — IA: approve loading, no-friends, and retry designs. Explain that
sharing the party code is still available when there are no friends to select.
Phone confirmation: check the empty list, normal loading, a failed read/retry,
and an updated friends list; compare Social with Party's invitation sheet.

#### 7. Host handover

Here is the situation:
1. You are the host and promote another member.
2. The new host gains host-only controls.
3. You remain a member, but cannot kick, promote again, or disband as the old host.
4. The new host can transfer ownership again; members may still invite friends.

Implemented: transactional host transfer, role-aware controls, stale-action
guards, and the shared New Host notification. Ordinary invitation permission
belongs to members, not exclusively to the host.
Frontend TODO — IA: confirm the New Host notification and updated host/member
controls clearly communicate the handover using the approved team design.
Phone confirmation: promote on one phone, check both accounts' controls, and have
the new host promote another member. Verify old-host actions are unavailable.

### Backend/integration verification summary (IA)

- Party/session streams require server confirmation before serving as permission
  evidence and recover on metadata changes even when the data is unchanged.
- Transactions and rules prevent over-capacity joins, stale invitation acceptance,
  and unauthorized membership/host changes. Failed joins do not claim a session.
- Mixed batches identify successful recipients and failed recipients separately.
  Successfully sent recipients leave the selection; there is no automatic retry.
- Closing the invitation route stops unsent recipients even during its exit
  animation. In-flight requests cannot be recalled by closing the screen.
- After a membership/auth/closed-party rejection, the remaining batch stops and
  explains that remaining invitations were not sent. Earlier successes remain.
- Friends removed during a batch are skipped; repeated callbacks while busy do
  not create a duplicate batch. The friends-list check is a client guard, not a
  newly introduced server friendship authorization rule.

### Remaining frontend presentation review (IA)

Keep the earlier Join-button and Ready/Start TODOs. Also review sender-name
truncation, ordinary invitation success/error/partial-result feedback, full or
ended-party messages, removed-player dialogs, and connection loading/retry states.
Functional feedback exists; final visual approval and the phone confirmations
above are pending. Review these within their existing screens rather than
creating a new frontend task for every timing variation.

Public-profile viewing, real "Knows" counts, photos/presence and invitation expiry
remain future feature work. No Dev edge-case gallery is restored. The agreed
review is closed after the final regression run; do not keep expanding the list.
