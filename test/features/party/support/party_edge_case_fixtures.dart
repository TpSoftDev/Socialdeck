import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/presentation/party_invitations_list.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/features/profile/providers/profile_data_provider.dart';
import 'package:socialdeck/features/profile/domain/profile_data_state.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

enum PartyEdgeCase {
  profileDetails('Incomplete profile details', 'Open a player: use known account names only. Public-profile navigation and mutual counts still need the Social feature.'),
  startControls('Ready and Start layout', 'Review the live Start Game control and selected-card count; these need frontend layout sign-off.'),
  cardsError('Card catalog unavailable', 'Open Pick 7 Cards and a method: design a retryable catalog failure.'),
  inboxError('Inbox unavailable', 'Design inbox retry separately from an empty inbox.'),
  signedOut('Signed out', 'Design the sign-in-required state; party actions must be unavailable.'),
  noFriends('No friends', 'Keep code copying available; Invite stays disabled.'),
  friendsLoading('Friends loading', 'Design the waiting state before friends arrive.'),
  friendsError('Friends unavailable', 'Design retry without showing a false empty list.'),
  alreadyJoined('Already in party', 'Invite Guest: show Invite Error, with no roster change.'),
  partialInvite('Mixed invite results', 'Select Guest and Alex: show error, then success.'),
  inviteError('Invite connection failure', 'Invite Alex: show a retryable error, not success.'),
  emptyInbox('Empty inbox', 'No pending invitations. Keep the rest of Social available.'),
  blockedInbox('Already in another party', 'Join is disabled; Decline remains available.'),
  lobbyLoading('Lobby loading', 'Design the waiting state; no enabled actions.'),
  lobbyError('Lobby connection lost', 'Design retry without authorizing actions from stale data.'),
  removed('Removed from party', 'Design the exit state after a kick or membership removal.'),
  closed('Party ended', 'Design the exit state after disband.'),
  full('Party full', 'Eight seats; no extra invite slot.'),
  emptyCards('No playable cards', 'Open Pick 7 Cards: explain missing catalog without fake cards.'),
  permissionChange('Permission changes', 'Schedule a change, then open Change Name or Kick. Submission must become unavailable.');
  const PartyEdgeCase(this.title, this.note);
  final String title, note;
}

class _PreviewUser implements User {
  @override
  String get uid => 'host';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PreviewRepository implements PartyRepository {
  _PreviewRepository(this.scenario) {
    party = Party(id: '123456', hostId: 'host', game: const PartyGame(), members: {
      if (scenario != PartyEdgeCase.removed) 'host': const PartyMember(uid: 'host', name: 'You'),
      'guest': const PartyMember(uid: 'guest', name: 'Guest'),
      if (scenario == PartyEdgeCase.full)
        for (var i=0; i<6; i++) 'p$i': PartyMember(uid: 'p$i', name: 'Player $i'),
    }, phase: scenario == PartyEdgeCase.closed ? PartyPhase.closed : PartyPhase.lobby);
  }
  final PartyEdgeCase scenario;
  late Party party;
  final changes = StreamController<Party?>.broadcast();
  @override
  Stream<Party?> watchParty(String id) async* {
    if (scenario == PartyEdgeCase.lobbyLoading) { yield* const Stream<Party?>.empty(); return; }
    if (scenario == PartyEdgeCase.lobbyError) throw const PartyFailure(PartyError.network);
    yield party;
    yield* changes.stream;
  }
  void change({bool remove = false}) {
    party = party.copyWith(hostId: 'guest', members: remove ? {'guest': party.members['guest']!} : party.members);
    changes.add(party);
  }
  @override
  Future<void> invitePlayer(String partyId, String recipientId) async {
    if (scenario == PartyEdgeCase.inviteError) throw const PartyFailure(PartyError.network);
    if (party.members.containsKey(recipientId)) throw const PartyFailure(PartyError.alreadyInParty);
  }
  // Unimplemented fixture actions deliberately fail locally; never delegate to Firebase.
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.error(const PartyFailure(PartyError.network));
}

class PartyEdgePreview extends StatefulWidget {
  const PartyEdgePreview({super.key, required this.scenario});
  final PartyEdgeCase scenario;
  @override
  State<PartyEdgePreview> createState() => _PartyEdgePreviewState();
}
class _PartyEdgePreviewState extends State<PartyEdgePreview> {
  late final repo = _PreviewRepository(widget.scenario);
  Timer? timer;
  @override
  void dispose() { timer?.cancel(); repo.changes.close(); super.dispose(); }
  Stream<List<PartyFriend>> friends() {
    if (widget.scenario == PartyEdgeCase.friendsLoading) return const Stream.empty();
    if (widget.scenario == PartyEdgeCase.friendsError) return Stream.error(const PartyFailure(PartyError.network));
    return Stream.value(widget.scenario == PartyEdgeCase.noFriends ? [] : const [
      PartyFriend(uid: 'guest', name: 'Guest'), PartyFriend(uid: 'alex', name: 'Alex'),
    ]);
  }
  @override
  Widget build(BuildContext context) => ProviderScope(overrides: [
    currentUserProvider.overrideWithValue(widget.scenario == PartyEdgeCase.signedOut ? null : _PreviewUser()),
    partyRepositoryProvider.overrideWithValue(repo),
    partyActionsProvider.overrideWith((ref) => PartyActionsNotifier(repo)),
    partyByIdProvider('123456').overrideWith((ref) => repo.watchParty('123456')),
    // Sender-name lookup for the separate invitation stays local too.
    partyByIdProvider('654321').overrideWith((ref) => Stream.value(null)),
    partyFriendsProvider.overrideWith((ref) => friends()),
    profileDataProvider.overrideWith((ref) async => const ProfileDataState(username: 'IA Preview')),
    activePartyIdProvider.overrideWith((ref) => Stream.value('123456')),
    activePartyProvider.overrideWith((ref) => AsyncData(widget.scenario == PartyEdgeCase.blockedInbox ? repo.party : null)),
    partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
    partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
    partyDecksProvider.overrideWith((ref) => Stream.value([])),
    partyAllCardsProvider.overrideWith((ref) => widget.scenario == PartyEdgeCase.cardsError ? Stream.error(const PartyFailure(PartyError.network)) : Stream.value([])),
    partyInvitationsProvider.overrideWith((ref) => widget.scenario == PartyEdgeCase.inboxError ? Stream.error(const PartyFailure(PartyError.network)) : Stream.value(widget.scenario == PartyEdgeCase.emptyInbox ? [] : const [
      PartyInvitation(id: '654321_host', partyId: '654321', senderId: 'alex', recipientId: 'host', status: PartyInvitationStatus.pending),
    ])),
  ], child: Navigator(onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => Scaffold(
    appBar: AppBar(title: Text(widget.scenario.title),
      leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(12), child: Text('IA — Dev fixture: ${widget.scenario.note}')),
      if (widget.scenario == PartyEdgeCase.permissionChange) Wrap(children: [
        TextButton(onPressed: () { timer?.cancel(); timer = Timer(const Duration(seconds: 5), () => repo.change()); }, child: const Text('Transfer host in 5s')),
        TextButton(onPressed: () { timer?.cancel(); timer = Timer(const Duration(seconds: 5), () => repo.change(remove: true)); }, child: const Text('Remove me in 5s')),
      ]),
      Expanded(child: widget.scenario == PartyEdgeCase.emptyInbox || widget.scenario == PartyEdgeCase.blockedInbox || widget.scenario == PartyEdgeCase.inboxError
        ? const SingleChildScrollView(child: PartyInvitationsList(showEmpty: true))
        : const PartyLobbyPage(partyId: '123456')),
    ]),
  ))));
}
