# Decks Backend & Party Ephemeral Session Integration Plan

## Overview

This plan defines the phased backend architecture for `lib/features/decks/` and its card-selection handoff into `lib/features/party/`, working directly on the `feature-party` branch (which already contains 100% of the merged Decks frontend from `sprint-6-decks-module`).

### Core Product & Architectural Rules

1. **Photos Stay Local in Decks (Zero Permanent Photo Uploads):**
   - Adding photos from Camera Roll (or Shuffle Search / Camera later) into **Decks** or **Quick Pics** never uploads image files to Firebase Storage.
   - Only lightweight metadata is persisted in Firestore: `localPath` (device file path) + `assetId` (`photo_manager` `AssetEntity.id` fallback so the phone can re-resolve the file if iOS/Android rotates temporary cache paths) + card presentation fields (`tiltDegrees`, `scale`, `panX`, `panY`, `rotation`).
2. **Firestore Layout Under `users/{uid}`:**
   - `users/{uid}/decks/{deckId}` — One document per deck, holding deck metadata (`name`, `color`, `favorited`, `orderIndex`, `tiltDegrees`, timestamps) and an ordered `cards` array capped at **52 cards** (~8 KB max per doc; press-and-hold reorder is a single document write).
   - `users/{uid}/quickPics/main` — Dedicated Quick Pics section stored as a single owner-scoped document with an ordered `cards` array capped at **100 cards** (~15 KB max; reorder is a single document write).
   - `users/{uid}` — Stores optional `isSocialdeckPlus: bool` flag (default `false`; free tier enforces max `2` decks).
3. **Ephemeral Session Photo Uploads for Party Only:**
   - When a player in a Party lobby picks **7 cards** (via *Single Deck*, *Free-to-Choose* across Decks/Quick Pics, or *Random*) and confirms their hand for that party session, **only those 7 photos** are compressed and uploaded to a temporary session-scoped Firebase Storage path:
     `partySessionsMedia/{partyId}/{uid}/{cardId}.jpg`
   - Their temporary `https://` download URLs are synced into `users/{uid}/partyDecks/{deckId}` and `users/{uid}/partyCards/{cardId}` so `FirebasePartyRepository.selectCards()` and `parties/{partyId}/hands/{uid}` satisfy the existing `^https://.*` Firestore rule without ever exposing local phone paths.
   - When the player leaves, is kicked, or the party ends/disbands (`closed`), those temporary session Storage files and ephemeral `partyCards` entries are deleted.
4. **Legacy Isolation:**
   - Ignore `test_decks` completely in application code (it has zero documents in `socialdeck-dev`), and **leave the legacy `match /test_decks/{deckId}` block untouched in `firestore.rules`** so the existing 69 rule-compatibility checks continue to pass.

---

## Architecture Diagram

```text
lib/features/decks/
├── domain/                                  [Pure Dart — NO Flutter UI, NO Firebase, NO Riverpod]
│   ├── deck_card_entity.dart                Immutable card model (id, localPath, assetId, tilt, transforms)
│   ├── deck_entity.dart                     Immutable deck model (id, name, colorKey, cards[<=52], ...)
│   ├── quick_pics_entity.dart               Immutable Quick Pics model (cards[<=100], updatedAt)
│   ├── decks_failure.dart                   Typed DecksError enum + DecksFailure exception + validation guards
│   └── decks_repository.dart                Abstract DecksRepository contract (streams + CRUD + reorder)
│
├── data/                                    [Adapters, Serialization, Local Asset Resolver, Firebase]
│   ├── decks_firestore_mapper.dart          Explicit Map <-> Entity serialization (schemaVersion: 1)
│   ├── mock_decks_repository.dart           In-memory reactive Stream repository (Phase 1–3 local testing)
│   ├── local_photo_resolver.dart            Resolves localPath; falls back to PhotoManager AssetEntity.id
│   └── firebase_decks_repository.dart       Firestore adapter for users/{uid}/decks & quickPics/main (Phase 4)
│
├── providers/                               [Riverpod 2 — Auth-scoped Streams & Action StateNotifiers]
│   ├── decks_providers.dart                 decksRepositoryProvider, decksWatchProvider, quickPicsWatchProvider
│   └── decks_actions_provider.dart          DecksActionsNotifier (loading/error guard, prevents double-taps)
│
└── presentation / existing screens          [ConsumerStatefulWidget / ConsumerWidget]
    ├── decks_home/decks_page.dart
    ├── decks_home/deck_cards_page.dart
    ├── decks_home/create_deck/new_deck_color_page.dart
    ├── decks_home/create_deck/new_deck_name_page.dart
    ├── quick_pics/quick_pics_page.dart
    └── shared/camera_roll/camera_roll_page.dart   (returns SelectedLocalPhoto { localPath, assetId })
```

---

## Coding Style & Commenting Standards (Mandatory Across All Phases)

Every new or modified file **must** follow `docs/policies/CODING_STYLE_GUIDE.md` and `docs/workflows/FRONTEND_BACKEND_WORKFLOW.txt`:

1. **Synthesized File Header Block:**
   ```dart
   /*-------------------------- deck_entity.dart ----------------------------*/
   // Immutable domain model representing one user-created deck in Decks.
   // Holds deck metadata and an ordered list of up to 52 local-reference cards
   // without importing Flutter widgets, Riverpod, or Firebase SDKs.
   //
   // Usage:
   //   final deck = DeckEntity(id: '...', name: 'Fire Pics', ...);
   /*--------------------------------------------------------------------------*/
   ```
2. **Section Dividers (Exact Formatting):**
   - `//-------------------------------- Imports --------------------------------//`
   - `//------------------------------- ClassName ------------------------------//`
   - `//*************************** Section Name **********************************//`
3. **High-Signal Comments Only:**
   - Explain **why** a constraint or guard exists (e.g., why `assetId` is stored alongside `localPath`, why `copyWith` freezes `List.unmodifiable`), never redundant comments that repeat obvious syntax.
4. **Ref Usage Rule in Presentation:**
   - `ref.watch(provider)` **only** inside `build()`.
   - `ref.read(provider.notifier)` **only** inside button/gesture callbacks.

---

## Phased Implementation Roadmap

### Phase 1: Domain Models, Repository Contract & Mock Repository Scaffolding
**Goal:** Establish the pure-Dart domain layer (`DeckCardEntity`, `DeckEntity`, `QuickPicsEntity`, `DecksFailure`, `DecksRepository`) and a reactive in-memory `MockDecksRepository` + `DecksFirestoreMapper` without touching UI screens or live Firestore yet.

- **Files to Create:**
  - `lib/features/decks/domain/decks_failure.dart` — `DecksError` (`invalidName`, `freeDeckLimitReached`, `deckCardLimitReached`, `quickPicsLimitReached`, `notFound`, `unauthenticated`, `invalidInput`, `storageError`), `DecksFailure`, and `requireDecks(...)`.
  - `lib/features/decks/domain/deck_card_entity.dart` — Immutable card (`id`, `localPath`, `assetId`, `tiltDegrees`, `scale`, `panX`, `panY`, `rotation`, `copyWith`, value equality).
  - `lib/features/decks/domain/deck_entity.dart` — Immutable deck (`id`, `name` max 16 chars, `colorKey`, `favorited`, `orderIndex`, `tiltDegrees`, `cards` max 52, `copyWith`, value equality).
  - `lib/features/decks/domain/quick_pics_entity.dart` — Immutable Quick Pics (`cards` max 100, `copyWith`, value equality).
  - `lib/features/decks/domain/decks_repository.dart` — Abstract `DecksRepository` interface defining streams (`watchDecks()`, `watchQuickPics()`, `watchIsSocialdeckPlus()`) and mutations (`createDeck`, `updateDeck`, `deleteDeck`, `reorderDecks`, `addCardsToDeck`, `reorderDeckCards`, `removeCardsFromDeck`, `addCardsToQuickPics`, `reorderQuickPics`, `removeCardsFromQuickPics`, `setSocialdeckPlus`).
  - `lib/features/decks/data/decks_firestore_mapper.dart` — Explicit `toMap`/`fromMap` serialization for `users/{uid}/decks/{deckId}` and `users/{uid}/quickPics/main` (`schemaVersion: 1`).
  - `lib/features/decks/data/mock_decks_repository.dart` — Reactive `StreamController.broadcast` mock repository enforcing the 2-deck free limit, 52-card deck cap, and 100-card Quick Pics cap.
- **Phase 1 Test Gate:**
  - Create and run `test/features/decks/decks_domain_and_mock_repository_test.dart` covering entity immutability, mapper round-trips, free-limit enforcement (`2` decks vs `Socialdeck+`), `52`-card / `100`-card caps, and deck/card reordering.

---

### Phase 2: Riverpod Providers & Camera Roll Asset-ID Upgrade
**Goal:** Build the Riverpod state/action layer (`providers/`) wired to `MockDecksRepository` first (per `FRONTEND_BACKEND_WORKFLOW.txt`), and update `CameraRollPage` so picked photos return both `localPath` and `assetId` (`SelectedLocalPhoto`).

- **Files to Create / Update:**
  - `lib/features/decks/providers/decks_providers.dart` — Auth-scoped `decksRepositoryProvider`, `decksWatchProvider`, `deckByIdProvider`, `quickPicsWatchProvider`, and `isSocialdeckPlusProvider`.
  - `lib/features/decks/providers/decks_actions_provider.dart` — `DecksActionsNotifier` + `DecksActionState` (`idle`, `loading`, `success`, `failure`) preventing double-submits and exposing clean async commands to pages.
  - `lib/features/decks/data/local_photo_resolver.dart` — Helper that verifies `File(card.localPath).existsSync()` and re-resolves via `PhotoManager` `AssetEntity.fromId(card.assetId)` if the OS moved the cached path.
  - `lib/features/decks/shared/camera_roll/camera_roll_page.dart` — Return a typed `List<SelectedLocalPhoto>` (`localPath` + `assetId`) while keeping smooth thumbnail caching.
- **Phase 2 Test Gate:**
  - Create `test/features/decks/decks_providers_test.dart` verifying provider stream updates, sign-out reset safety, double-tap protection in `DecksActionsNotifier`, and action error states.

---

### Phase 3: Convert Decks & Quick Pics Screens to `ConsumerStatefulWidget`
**Goal:** Migrate all live Decks screens off the temporary `DecksLibrary` singleton and onto Riverpod providers while keeping 100% of the Figma layout and `SDeckMoveGrid` animations intact.

- **Files to Update:**
  - `lib/features/decks/decks_home/decks_page.dart` — Convert to `ConsumerStatefulWidget`; watch `decksWatchProvider` & `isSocialdeckPlusProvider`; wire reorder and Socialdeck+ upgrade dialog through `decksActionsProvider.notifier`.
  - `lib/features/decks/decks_home/create_deck/new_deck_name_page.dart` — Create/update deck via `decksActionsProvider.notifier` and pass `deckId` cleanly to `DeckCardsPage`.
  - `lib/features/decks/decks_home/deck_cards_page.dart` — Watch live deck by `deckId` (`deckByIdProvider`); save Camera Roll picks (`localPath` + `assetId`) and drag-reorders via `decksActionsProvider.notifier`.
  - `lib/features/decks/quick_pics/quick_pics_page.dart` — Convert to `ConsumerStatefulWidget`; watch `quickPicsWatchProvider` so backing out of Quick Pics never loses cards again.
  - Deprecate/remove `DecksLibrary` singleton once zero references remain.
- **Phase 3 Test Gate:**
  - Create `test/features/decks/decks_pages_widget_test.dart` testing Decks Home empty/populated/free-limit states, Create Deck flow, Deck Cards persistence, and Quick Pics persistence across navigation pops.

---

### Phase 4: Firestore Repository & Security Rules (`users/{uid}/decks` & `quickPics`)
**Goal:** Implement `FirebaseDecksRepository`, add strict owner-only Firestore rules for `users/{uid}/decks/{deckId}` and `users/{uid}/quickPics/{docId}`, and swap the provider from mock to Firebase for authenticated sessions.

- **Files to Create / Update:**
  - `lib/features/decks/data/firebase_decks_repository.dart` — Transactional Firestore implementation bound to `uid` (`users/{uid}/decks/{deckId}`, `users/{uid}/quickPics/main`, and `users/{uid}.isSocialdeckPlus`), storing **only** local paths + asset IDs (zero Storage calls).
  - `firestore.rules` & `firestore.party.rules` — Append owner-only (`request.auth.uid == uid`) schema-validated rules for `decks/{deckId}` (max 52 cards, name 1–16 chars) and `quickPics/{docId}` (max 100 cards), leaving `test_decks` and all existing Party rules untouched.
  - `lib/features/decks/providers/decks_providers.dart` — Point default `decksRepositoryProvider` to `FirebaseDecksRepository(uid: user.uid)` (keeping `MockDecksRepository` injectable for widget tests and Dev Tools).
- **Phase 4 Test Gate:**
  - Create `test/features/decks/firebase_decks_repository_test.dart` (using `fake_cloud_firestore` or repository fakes) **plus** extend `test/party_rules/` emulator checks to confirm owner R/W works, cross-user access is denied, card caps are enforced, and all 69 existing baseline compatibility tests still pass.

---

### Phase 5: Party Card-Selection UI + Ephemeral Session Photo Upload & Cleanup
**Goal:** Build the Figma-accurate Party card picker (*Pick 7 Cards* sheet → *Single Deck*, *Free-to-Choose* with Quick Pics + Decks + bottom selection tray, and *Random*) and upload **only the 7 chosen cards** to session-scoped Firebase Storage for the duration of the party, deleting them when the session ends.

- **Files to Create / Update:**
  - `storage.rules` — Add session-scoped rule for `partySessionsMedia/{partyId}/{userId}/{cardId}` allowing owner writes during active lobby membership and member reads while the party is active, plus owner/member delete on leave/disband.
  - `lib/features/decks/data/party_session_card_sync_service.dart` — Resolves the 7 chosen local cards (`LocalPhotoResolver`), compresses them for fast mobile upload, uploads to `partySessionsMedia/{partyId}/{uid}/{cardId}.jpg`, writes temporary `https://` records into `users/{uid}/partyDecks` + `users/{uid}/partyCards`, calls `PartyActionsNotifier.selectCards(partyId, cardIds)`, and exposes `cleanupSessionMedia(partyId)` called on `leaveParty`, `disbandParty`, or ended-lobby detection.
  - `lib/features/decks/party_selection/` — Figma-aligned **Pick 7 Cards** method bottom sheet, **Pick a Deck** screen (`SDeckDeckTarget` grid with `<7` disabled dim and blue `selected` glow), and **Free-to-Choose** screen (Quick Pics banner + Decks grid + sticky `SDeckCardList` tray + `"# Cards Remaining"` / `"Use These 7 Cards"` / `"Use Any of N Cards"` CTA).
  - `lib/features/party/presentation/party_lobby_page.dart` — Update `pickCards(party)` handoff and hook session media cleanup into leave/disband/ended transitions.
- **Phase 5 Test Gate:**
  - Update `test/features/decks/party_screen_selection_test.dart` and add `test/features/decks/party_session_card_sync_test.dart` verifying all 3 selection modes, `https://` hand submission into `parties/{code}/hands/{uid}`, stale-party/revision guards, and automatic cleanup of temporary Storage objects + `partyCards` docs when leaving or disbanding a party.
