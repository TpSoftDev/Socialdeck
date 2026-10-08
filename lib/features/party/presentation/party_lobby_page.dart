import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../party.dart';
import '../domain/party_selection.dart';
import '../providers/party_social_provider.dart';
import 'party_cards_page.dart';
import 'party_feedback.dart';

/// Live Party screen. Back navigation never mutates membership.
class PartyLobbyPage extends ConsumerStatefulWidget {
  const PartyLobbyPage({super.key, required this.partyId});
  final String partyId;
  @override
  ConsumerState<PartyLobbyPage> createState() => _PartyLobbyPageState();
}

class _PartyLobbyPageState extends ConsumerState<PartyLobbyPage> {
  final seenEvents = <String>{};
  bool eventsInitialized = false;

  Future<bool> command(Future<bool> Function(PartyActionsNotifier) run) async {
    final ok = await run(ref.read(partyActionsProvider.notifier));
    if (mounted && !ok) {
      partyToast(
        context,
        partyErrorMessage(ref.read(partyActionsProvider).error),
      );
    }
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUserProvider)?.uid;
    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Sign in to use Party.')));
    }
    final busy = ref.watch(partyActionsProvider).isLoading;
    final snapshot = ref.watch(partyByIdProvider(widget.partyId));
    ref.listen(partyEventsProvider(widget.partyId), (previous, next) {
      final events = next.asData?.value;
      if (events == null) return;
      for (final event in events.reversed) {
        if (seenEvents.add(event.id) && eventsInitialized) {
          partyToast(
            context,
            event.type == 'promoted'
                ? '${event.name} is now the host.'
                : '${event.name} was kicked from the party.',
          );
        }
      }
      eventsInitialized = true;
    });
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: snapshot.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(partyErrorMessage(e)),
                    TextButton(
                      onPressed:
                          () =>
                              ref.invalidate(partyByIdProvider(widget.partyId)),
                      child: const Text('Retry'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ),
          data: (party) {
            if (party == null ||
                party.phase == PartyPhase.closed ||
                !party.members.containsKey(uid)) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('You are no longer in this party.'),
                    FilledButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Home'),
                    ),
                  ],
                ),
              );
            }
            final host = party.hostId == uid;
            final lobby = party.phase == PartyPhase.lobby;
            final me = party.members[uid]!;
            final ready = party.isReady(uid);
            final handSnapshot = ref.watch(partyHandProvider(party.id));
            final hand = handSnapshot.asData?.value;
            final currentHand = hand?.revision == party.revision ? hand : null;
            return Column(
              children: [
                SDeckTopNavigationBar(
                  left: SDeckTopBarLeft.back,
                  type: SDeckTopBarType.page,
                  right: SDeckTopBarRight.icon,
                  title:
                      party.game == null
                          ? (host ? 'Select Game' : 'No Game')
                          : "Prompt'd",
                  onLeftPressed: () => context.go('/home'),
                  rightIcon: Icon(host ? Icons.more_horiz : Icons.logout),
                  onRightPressed: busy ? null : () => leaveOptions(party, uid),
                ),
                if (busy) const LinearProgressIndicator(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (host && lobby)
                        OutlinedButton(
                          onPressed: busy ? null : () => gameSettings(party),
                          child: Text(
                            party.game == null
                                ? 'Game Library'
                                : 'Game Settings / Change Game',
                          ),
                        ),
                      if (!lobby)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Everyone is ready. The game has started.',
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Players'),
                          Text('${party.members.length}/8'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView(
                        // Reserve room for avatar, name and Ready at the user's text size.
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisExtent:
                              56 + MediaQuery.textScalerOf(context).scale(48),
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final member in party.members.values)
                            InkWell(
                              onTap:
                                  busy
                                      ? null
                                      : () => playerOptions(party, member, uid),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    child: Icon(
                                      member.uid == party.hostId
                                          ? Icons.star
                                          : Icons.person,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    member.name,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (party.isReady(member.uid))
                                    Text(
                                      'Ready ✓',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          if (party.members.length < 8 && lobby)
                            IconButton(
                              tooltip: 'Invite players',
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed:
                                  busy
                                      ? null
                                      : () => showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (_) => PartyInviteSheet(
                                              partyId: party.id,
                                            ),
                                      ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Cards'),
                      if (handSnapshot.isLoading)
                        const LinearProgressIndicator(),
                      if (handSnapshot.hasError) ...[
                        Text(partyErrorMessage(handSnapshot.error)),
                        TextButton(
                          onPressed:
                              () => ref.invalidate(partyHandProvider(party.id)),
                          child: const Text('Retry cards'),
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (currentHand != null && currentHand.cards.isNotEmpty)
                        SizedBox(
                          height: 90,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (final card in currentHand.cards)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.network(
                                    card.imageUrl,
                                    width: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => const SizedBox(
                                          width: 64,
                                          child: Icon(Icons.image),
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      OutlinedButton(
                        onPressed:
                            !busy && lobby && party.game != null
                                ? () => pickCards(party)
                                : null,
                        child: Text(
                          currentHand == null || currentHand.cards.isEmpty
                              ? 'Pick 7 Cards'
                              : 'Change Cards',
                        ),
                      ),
                      FilledButton(
                        onPressed:
                            !busy &&
                                    lobby &&
                                    party.game != null &&
                                    !handSnapshot.isLoading &&
                                    !handSnapshot.hasError &&
                                    (ready ||
                                        me.cardCount == 7 &&
                                            me.selectionRevision ==
                                                party.revision)
                                ? () =>
                                    command((a) => a.setReady(party.id, !ready))
                                : null,
                        child: Text(ready ? 'Unready' : 'Ready'),
                      ),
                      if (host && lobby)
                        FilledButton(
                          onPressed:
                              !busy && party.canStart
                                  ? () => command((a) => a.startGame(party.id))
                                  : null,
                          child: const Text('Start Game'),
                        ),
                      if (lobby && party.game != null && !party.canStart)
                        const Text(
                          'At least two players must be ready to start.',
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> confirm(
    String title,
    String text,
    String action, {
    bool Function(WidgetRef)? canConfirm,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder:
            (ctx) => Consumer(
              builder:
                  (context, ref, _) => AlertDialog(
                    title: Text(title),
                    content: Text(text),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Back'),
                      ),
                      FilledButton(
                        onPressed:
                            canConfirm == null || canConfirm(ref)
                                ? () => Navigator.pop(ctx, true)
                                : null,
                        child: Text(action),
                      ),
                    ],
                  ),
            ),
      ) ??
      false;

  Future<void> leaveOptions(Party party, String uid) async {
    final host = party.hostId == uid;
    final choice =
        host
            ? await showModalBottomSheet<String>(
              context: context,
              // Share the frontend team's component with the live backend flow.
              isScrollControlled: true,
              builder:
                  (ctx) => Consumer(
                    builder: (context, sheetRef, _) {
                      final canLeave =
                          _canActFromSnapshot(
                            sheetRef.watch(partyByIdProvider(party.id)),
                            sheetRef.watch(currentUserProvider)?.uid,
                            uid,
                          ) &&
                          !sheetRef.watch(partyActionsProvider).isLoading;
                      final canDisband =
                          canLeave &&
                          sheetRef
                                  .watch(partyByIdProvider(party.id))
                                  .asData
                                  ?.value
                                  ?.hostId ==
                              uid;
                      if (!canDisband) {
                        return SafeArea(
                          child: ListTile(
                            title: const Text('Leave Party'),
                            enabled: canLeave,
                            onTap:
                                canLeave
                                    ? () => Navigator.pop(ctx, 'leave')
                                    : null,
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        child: SDeckPartyLeavingBottomSheet(
                          onLeaveParty: () => Navigator.pop(ctx, 'leave'),
                          onDisbandParty: () => Navigator.pop(ctx, 'disband'),
                        ),
                      );
                    },
                  ),
            )
            : 'leave';
    if (!mounted || choice == null) return;
    // Leave is always a leave. The transaction decides succession from the latest roster.
    final disband = choice == 'disband';
    bool canConfirm(WidgetRef dialogRef) =>
        _canActFromSnapshot(
          dialogRef.watch(partyByIdProvider(party.id)),
          dialogRef.watch(currentUserProvider)?.uid,
          uid,
          hostOnly: disband,
        ) &&
        !dialogRef.watch(partyActionsProvider).isLoading;
    if (!_canStillAct(party.id, uid, hostOnly: disband)) return;
    if (!await confirm(
      'Wait!',
      disband
          ? 'End the party for everyone?'
          : 'Leave this party? If you are host, hosting transfers to a remaining player. If you are alone, the party closes.',
      disband ? 'Disband' : 'Leave',
      canConfirm: canConfirm,
    )) {
      return;
    }
    if (!mounted || !_canStillAct(party.id, uid, hostOnly: disband)) return;
    final ok = await command(
      (a) => disband ? a.disbandParty(party.id) : a.leaveParty(party.id),
    );
    if (mounted && ok) context.go('/home');
  }

  // Cached data is useful for display, but cannot authorize a pending action.
  bool _canActFromSnapshot(
    AsyncValue<Party?> snapshot,
    String? viewer,
    String uid, {
    bool hostOnly = false,
    bool lobbyOnly = false,
  }) {
    final party = snapshot.asData?.value;
    return !snapshot.isLoading &&
        !snapshot.hasError &&
        viewer == uid &&
        party != null &&
        party.phase != PartyPhase.closed &&
        party.members.containsKey(uid) &&
        (!hostOnly || party.hostId == uid) &&
        (!lobbyOnly || party.phase == PartyPhase.lobby);
  }

  bool _canStillAct(
    String id,
    String uid, {
    bool hostOnly = false,
    bool lobbyOnly = false,
  }) =>
      !ref.read(partyActionsProvider).isLoading &&
      _canActFromSnapshot(
        ref.read(partyByIdProvider(id)),
        ref.read(currentUserProvider)?.uid,
        uid,
        hostOnly: hostOnly,
        lobbyOnly: lobbyOnly,
      );

  bool _canManagePlayer(Party? party, String? uid, String target) =>
      party != null &&
      uid != null &&
      party.phase != PartyPhase.closed &&
      party.hostId == uid &&
      party.members.containsKey(uid) &&
      target != uid &&
      party.members.containsKey(target);

  bool _canStillManagePlayer(String partyId, String uid, String target) =>
      ref.read(currentUserProvider)?.uid == uid &&
      _canManagePlayer(
        ref.read(partyByIdProvider(partyId)).asData?.value,
        uid,
        target,
      );

  Future<void> playerOptions(
    Party party,
    PartyMember member,
    String uid,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder:
          (ctx) => Consumer(
            builder: (context, sheetRef, _) {
              // Sheets live on a separate route, so subscribe to role changes here too.
              final current =
                  sheetRef.watch(partyByIdProvider(party.id)).asData?.value;
              final viewer = sheetRef.watch(currentUserProvider)?.uid;
              final selected = current?.members[member.uid];
              final active =
                  current != null &&
                  current.phase != PartyPhase.closed &&
                  current.members.containsKey(uid) &&
                  viewer == uid &&
                  selected != null;
              final busy = sheetRef.watch(partyActionsProvider).isLoading;
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(selected?.name ?? member.name),
                      subtitle: Text(
                        !active
                            ? 'Player unavailable'
                            : member.uid == current.hostId
                            ? 'Host'
                            : 'Player',
                      ),
                    ),
                    if (active && member.uid == uid)
                      ListTile(
                        title: const Text('Change Name'),
                        onTap: busy ? null : () => Navigator.pop(ctx, 'name'),
                      ),
                    if (active &&
                        _canManagePlayer(current, uid, member.uid)) ...[
                      ListTile(
                        title: const Text('Promote to Host'),
                        onTap:
                            busy ? null : () => Navigator.pop(ctx, 'promote'),
                      ),
                      ListTile(
                        title: const Text('Kick'),
                        onTap: busy ? null : () => Navigator.pop(ctx, 'kick'),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
    );
    if (!mounted) return;
    if (action == 'name') {
      final name = await partyNameDialog(context, initial: member.name);
      if (mounted && name != null) {
        await command(
          (a) => a.updateIdentity(party.id, name, member.characterId),
        );
      }
    } else if (action == 'promote') {
      if (!_canStillManagePlayer(party.id, uid, member.uid)) return;
      await command((a) => a.promoteHost(party.id, member.uid));
    } else if (action == 'kick') {
      if (!_canStillManagePlayer(party.id, uid, member.uid)) return;
      final confirmed = await confirm(
        'Wait!',
        'Kick ${member.name}?',
        'Kick',
        canConfirm:
            (dialogRef) =>
                dialogRef.watch(currentUserProvider)?.uid == uid &&
                _canManagePlayer(
                  dialogRef.watch(partyByIdProvider(party.id)).asData?.value,
                  uid,
                  member.uid,
                ),
      );
      // Recheck after the dialog; a captured callback may outlive host rights.
      if (mounted &&
          confirmed &&
          _canStillManagePlayer(party.id, uid, member.uid)) {
        await command((a) => a.kickPlayer(party.id, member.uid));
      }
    }
  }

  Future<void> gameSettings(Party party) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null ||
        !_canStillAct(party.id, uid, hostOnly: true, lobbyOnly: true)) {
      return;
    }
    final game = await showModalBottomSheet<PartyGame>(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Consumer(
            builder:
                (context, sheetRef, _) => _PartyGameSheet(
                  game: party.game,
                  enabled:
                      _canActFromSnapshot(
                        sheetRef.watch(partyByIdProvider(party.id)),
                        sheetRef.watch(currentUserProvider)?.uid,
                        uid,
                        hostOnly: true,
                        lobbyOnly: true,
                      ) &&
                      !sheetRef.watch(partyActionsProvider).isLoading,
                ),
          ),
    );
    if (mounted &&
        game != null &&
        _canStillAct(party.id, uid, hostOnly: true, lobbyOnly: true)) {
      await command((a) => a.selectGame(party.id, game));
    }
  }

  Future<void> pickCards(Party party) async {
    final method = await showModalBottomSheet<PartySelectionMethod>(
      context: context,
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(title: Text('Pick 7 Cards')),
                for (final entry
                    in {
                      PartySelectionMethod.singleDeck:
                          'Single Deck — 7 random cards from one deck',
                      PartySelectionMethod.handpicked:
                          'Handpick — choose from any of your decks',
                      PartySelectionMethod.random:
                          'Random — 7 cards from all your decks',
                    }.entries)
                  ListTile(
                    title: Text(entry.value),
                    onTap: () => Navigator.pop(ctx, entry.key),
                  ),
              ],
            ),
          ),
    );
    if (!mounted || method == null) return;
    // Choosing another method resets the saved selection; merely opening does not.
    if (!await command((a) => a.selectCards(party.id, const [])) || !mounted) {
      return;
    }
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => PartyCardsPage(partyId: party.id, method: method),
      ),
    );
  }
}

class _PartyGameSheet extends StatefulWidget {
  const _PartyGameSheet({this.game, required this.enabled});
  final PartyGame? game;
  final bool enabled;
  @override
  State<_PartyGameSheet> createState() => _PartyGameSheetState();
}

class _PartyGameSheetState extends State<_PartyGameSheet> {
  late int rounds = widget.game?.rounds ?? 3;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Game Library · Prompt'd", style: TextStyle(fontSize: 22)),
          const Text('Open Beta · 2–8 players'),
          const SizedBox(height: 16),
          DropdownButton<int>(
            value: rounds,
            isExpanded: true,
            items: [
              for (var n = 1; n <= 5; n++)
                DropdownMenuItem(value: n, child: Text('$n rounds')),
            ],
            onChanged:
                widget.enabled ? (n) => setState(() => rounds = n!) : null,
          ),
          FilledButton(
            onPressed:
                !widget.enabled
                    ? null
                    : () => Navigator.pop(
                      context,
                      PartyGame(
                        rounds: rounds,
                        mixCards: widget.game?.mixCards ?? false,
                        safeMode: widget.game?.safeMode ?? false,
                      ),
                    ),
            child: const Text("Use Prompt'd"),
          ),
        ],
      ),
    ),
  );
}

/// Multi-recipient results are independent: one failure cannot hide successes.
class PartyInviteSheet extends ConsumerStatefulWidget {
  const PartyInviteSheet({super.key, required this.partyId});
  final String partyId;
  @override
  ConsumerState<PartyInviteSheet> createState() => _PartyInviteSheetState();
}

class _PartyInviteSheetState extends ConsumerState<PartyInviteSheet> {
  final selected = <String>{};
  bool busy = false;
  final results = <String, String>{};
  @override
  Widget build(BuildContext context) {
    ref.listen(partyFriendsProvider, (previous, next) {
      final items = next.asData?.value;
      if (items == null) return;
      final ids = items.map((friend) => friend.uid).toSet();
      if (selected.any((id) => !ids.contains(id))) {
        setState(() => selected.retainAll(ids));
      }
    });
    final friends = ref.watch(partyFriendsProvider);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .65,
        child: Column(
          children: [
            ListTile(
              title: const Text('Game Code'),
              subtitle: SelectableText(widget.partyId),
              trailing: IconButton(
                tooltip: 'Copy party code',
                icon: const Icon(Icons.copy),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: widget.partyId));
                  if (context.mounted) {
                    partyToast(context, 'Party code copied.');
                  }
                },
              ),
            ),
            const Text('Friends'),
            Expanded(
              child: friends.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (e, _) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(partyErrorMessage(e)),
                          TextButton(
                            onPressed:
                                () => ref.invalidate(partyFriendsProvider),
                            child: const Text('Retry friends'),
                          ),
                        ],
                      ),
                    ),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No friends available. Share your party code to invite players.',
                        ),
                      ),
                    );
                  }
                  final sorted = [...items]..sort((a, b) {
                    final online = (b.online ? 1 : 0).compareTo(
                      a.online ? 1 : 0,
                    );
                    return online != 0 ? online : a.name.compareTo(b.name);
                  });
                  return ListView(
                    children:
                        sorted
                            .map(
                              (friend) => CheckboxListTile(
                                title: Text(friend.name),
                                subtitle: Text(
                                  results[friend.uid] ??
                                      (friend.online ? 'Online' : 'Offline'),
                                ),
                                value: selected.contains(friend.uid),
                                onChanged:
                                    busy
                                        ? null
                                        : (v) => setState(() {
                                          if (v == true) {
                                            selected.add(friend.uid);
                                          } else {
                                            selected.remove(friend.uid);
                                          }
                                        }),
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ),
            FilledButton(
              onPressed:
                  busy ||
                          selected.isEmpty ||
                          friends.isLoading ||
                          friends.hasError
                      ? null
                      : send,
              child: Text(
                busy ? 'Sending…' : 'Invite ${selected.length} Friends',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> send() async {
    // A second callback can arrive before Flutter rebuilds the disabled button.
    if (busy || selected.isEmpty) return;
    final repository = ref.read(partyRepositoryProvider);
    // Recheck the current list even for callbacks captured before a rebuild.
    final friends = ref.read(partyFriendsProvider);
    if (friends.isLoading || friends.hasError) return;
    final available =
        friends.asData?.value.map((f) => f.uid).toSet() ?? <String>{};
    final targets = selected.where(available.contains).toList();
    if (targets.isEmpty) return;
    setState(() {
      busy = true;
      results.clear();
    });
    for (final uid in targets) {
      if (!mounted) break; // Closing the sheet cancels recipients not yet sent.
      try {
        await repository.invitePlayer(widget.partyId, uid);
        if (mounted) {
          setState(() {
            results[uid] = 'Invite sent';
            selected.remove(uid);
          });
        }
      } catch (error) {
        if (mounted) setState(() => results[uid] = partyErrorMessage(error));
      }
    }
    if (mounted) setState(() => busy = false);
  }
}

/// Resolve legacy Return to Game links from the signed-in user's session.
class PartySessionPage extends ConsumerWidget {
  const PartySessionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(activePartyProvider)
      .when(
        loading:
            () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error:
            (error, _) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(partyErrorMessage(error)),
                    TextButton(
                      onPressed: () => retryPartySession(ref),
                      child: const Text('Retry'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ),
            ),
        data:
            (party) =>
                party != null && party.phase != PartyPhase.closed
                    ? PartyLobbyPage(partyId: party.id)
                    : Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('You are not in a party.'),
                            TextButton(
                              onPressed: () => context.go('/home'),
                              child: const Text('Home'),
                            ),
                          ],
                        ),
                      ),
                    ),
      );
}
