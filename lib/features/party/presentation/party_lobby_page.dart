import 'package:flutter/material.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/games/presentation/pages/party_lobby_binding.dart';
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
import 'party_settings_page.dart';
import 'package:socialdeck/features/profile/providers/profile_data_provider.dart';
import 'package:socialdeck/features/games/presentation/pages/prompt_setup_host_page.dart';

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
  final feedback = ValueNotifier<PartyLobbyNotice?>(null);
  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
  }

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
          feedback.value = event.type == 'promoted'
              ? PartyLobbyNotice(
                  SDeckToastStatus.info,
                  'New Host',
                  '${event.name} will now lead the party.',
                )
              : PartyLobbyNotice(
                  SDeckToastStatus.note,
                  'Player Kicked',
                  '${event.name} is no longer in the party.',
                );
        }
      }
      eventsInitialized = true;
    });
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: snapshot.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(partyErrorMessage(e)),
                TextButton(
                  onPressed: () =>
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
                    // IA: Disbanding is different from being removed. Explain
                    // why the lobby ended, and keep Home available for exit.
                    Text(party?.phase == PartyPhase.closed
                        ? 'This party has ended.'
                        : party == null
                            ? 'This party is no longer available.'
                            : 'You are no longer in this party.'),
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
            // The normal app and Live Party Dev now render the team's lobby.
            return InviteSheetPage(
              playMode: PartyPlayMode.normal,
              live: PartyLobbyBinding(
                code: party.id,
                feedback: feedback,
                seats: [
                  for (final member in party.members.values)
                    PartyLobbySeat(
                      member.uid,
                      member.name,
                      ready: party.isReady(member.uid),
                    ),
                ],
                isHost: host,
                gameSelected: party.game != null,
                busy: busy,
                ready: ready,
                playing: !lobby,
                onBack: () => context.go('/home'),
                onOptions: (leave) => liveOptions(party, uid, leave),
                onLeave: () => exitParty(party.id, uid),
                onDisband: () => exitParty(party.id, uid, disband: true),
                // Dialogs have their own route: watching only the lobby does not
                // refresh an already-open confirmation when the host changes.
                disbandGuard: (builder) => Consumer(
                  builder: (_, dialogRef, _) {
                    final allowed =
                        _canActFromSnapshot(
                          dialogRef.watch(partyByIdProvider(party.id)),
                          dialogRef.watch(currentUserProvider)?.uid,
                          uid,
                          hostOnly: true,
                        ) &&
                        !dialogRef.watch(partyActionsProvider).isLoading;
                    return builder(allowed);
                  },
                ),
                onPlayer: (id) {
                  final current = ref
                      .read(partyByIdProvider(party.id))
                      .asData
                      ?.value;
                  final member = current?.members[id];
                  if (current != null && member != null) {
                    playerOptions(current, member, uid);
                  }
                },
                onInvite: !busy && lobby && party.members.length < 8
                    ? (notify) => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
                        builder: (sheetContext) => PartyInviteSheet(
                          partyId: party.id,
                          onComplete: (notices) {
                            Navigator.of(sheetContext).pop();
                            for (final notice in notices) {
                              notify(notice);
                            }
                          },
                        ),
                      )
                    : null,
                onSettings: host && lobby && !busy
                    ? () => gameSettings(party)
                    : null,
                onCards: !busy && lobby && party.game != null
                    ? () => pickCards(party)
                    : null,
                cardsTitle: currentHand == null || currentHand.cards.isEmpty
                    ? 'Pick 7 Cards'
                    : 'Change Cards',
                cardsDescription: '${currentHand?.cards.length ?? 0}/7 cards selected. Choose from one or many decks.',
                cardsStatus: handSnapshot.hasError
                    ? TextButton(
                        onPressed: () =>
                            ref.invalidate(partyHandProvider(party.id)),
                        child: const Text('Retry cards'),
                      )
                    : null,
                onReady:
                    !busy &&
                        lobby &&
                        party.game != null &&
                        !handSnapshot.isLoading &&
                        !handSnapshot.hasError &&
                        (ready ||
                            me.cardCount == 7 &&
                                me.selectionRevision == party.revision)
                    ? () => command((a) => a.setReady(party.id, !ready))
                    : null,
                onStart: host && lobby && !busy && party.canStart
                    ? () => command((a) => a.startGame(party.id))
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> liveOptions(Party party, String uid, VoidCallback leave) async {
    if (party.hostId != uid) {
      leave();
      return;
    }
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => Consumer(
        builder: (ctx, sheetRef, _) {
          final snapshot = sheetRef.watch(partyByIdProvider(party.id));
          final viewer = sheetRef.watch(currentUserProvider)?.uid;
          final busy = sheetRef.watch(partyActionsProvider).isLoading;
          final active = !busy && _canActFromSnapshot(snapshot, viewer, uid);
          final host = active && snapshot.asData?.value?.hostId == uid;
          return SingleChildScrollView(
            child: SDeckBottomSheet(
              title: 'Your Options',
              showCloseButton: false,
              buttons: [
                SDeckSolidButton(
                  text: 'Game Settings',
                  size: SDeckButtonSize.large,
                  iconLocation: SDeckButtonIconLocation.left,
                  icon: SDeckIcons(
                    SDeckIcon.settings,
                    size: SDeckSize.size24,
                    color: context.component.solidButtonIcon,
                  ),
                  fullWidth: true,
                  onPressed:
                      host && snapshot.asData?.value?.phase == PartyPhase.lobby
                      ? () => Navigator.pop(ctx, 'settings')
                      : null,
                ),
                SDeckOutlineButton(
                  text: 'Change Name',
                  size: SDeckButtonSize.large,
                  iconLocation: SDeckButtonIconLocation.left,
                  icon: SDeckIcons(
                    SDeckIcon.edit,
                    size: SDeckSize.size24,
                    color: context.component.outlineButtonIcon,
                  ),
                  fullWidth: true,
                  onPressed: active ? () => Navigator.pop(ctx, 'name') : null,
                ),
                SDeckOutlineButton(
                  text: 'Leave',
                  size: SDeckButtonSize.large,
                  iconLocation: SDeckButtonIconLocation.left,
                  icon: SDeckIcons(
                    SDeckIcon.leave,
                    size: SDeckSize.size24,
                    color: context.semantic.error,
                  ),
                  fullWidth: true,
                  color: SDeckOutlineButtonColor.brightCoral,
                  onPressed: active ? () => Navigator.pop(ctx, 'leave') : null,
                ),
              ],
            ),
          );
        },
      ),
    );
    if (!mounted || !_canStillAct(party.id, uid)) return;
    final current = ref.read(partyByIdProvider(party.id)).asData!.value!;
    if (action == 'settings') await gameSettings(current);
    if (action == 'leave') leave();
    if (action == 'name' && mounted) await renameInParty(party.id, uid);
  }

  Future<void> renameInParty(String partyId, String actorId) async {
    if (!mounted || !_canStillAct(partyId, actorId)) return;
    final member = ref
        .read(partyByIdProvider(partyId))
        .asData!
        .value!
        .members[actorId]!;
    // Reuse the exact Party Dev dialog; only the permission/data binding differs.
    final name = await showDialog<String>(
      context: context,
      barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
      builder: (dialogContext) => Consumer(
        builder: (_, dialogRef, _) => PartyChangeNameDialog(
          initialName: member.name,
          dialogContext: dialogContext,
          maxLength: 24, // Current backend nickname limit.
          enabled:
              _canActFromSnapshot(
                dialogRef.watch(partyByIdProvider(partyId)),
                dialogRef.watch(currentUserProvider)?.uid,
                actorId,
              ) &&
              !dialogRef.watch(partyActionsProvider).isLoading,
        ),
      ),
    );
    // A nickname belongs only to this membership, never to the account profile.
    if (!mounted || name == null || !_canStillAct(partyId, actorId)) return;
    final current = ref
        .read(partyByIdProvider(partyId))
        .asData!
        .value!
        .members[actorId]!;
    // Saving the same nickname needs no Firestore transaction or loading state.
    if (name == current.name) return;
    await command((a) => a.updateIdentity(partyId, name, current.characterId));
  }

  Future<bool> confirm(
    String title,
    String text,
    String action, {
    bool Function(WidgetRef)? canConfirm,
    String Function(WidgetRef)? liveDescription,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (ctx) => Consumer(
          builder: (context, ref, _) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
            child: SDeckDialog(
              title: title,
              description: liveDescription?.call(ref) ?? text,
              showClose: false,
              dialogWidth:
                  MediaQuery.sizeOf(context).width - 2 * SDeckSpace.margin32,
              secondaryButtonText: 'Back',
              onSecondaryPressed: () => Navigator.pop(ctx, false),
              primaryAction: SDeckSolidButton(
                text: action,
                size: SDeckButtonSize.medium,
                fullWidth: true,
                color: SDeckSolidButtonColor.brightCoral,
                onPressed: canConfirm == null || canConfirm(ref)
                    ? () {
                        // IA: A captured callback can outlive the enabled state.
                        if (canConfirm == null || canConfirm(ref)) {
                          Navigator.pop(ctx, true);
                        }
                      }
                    : null,
              ),
            ),
          ),
        ),
      ) ??
      false;

  // The team's UI owns confirmation; recheck permissions before writing.
  Future<void> exitParty(
    String partyId,
    String uid, {
    bool disband = false,
  }) async {
    if (!mounted ||
        ref.read(partyActionsProvider).isLoading ||
        !_canStillAct(partyId, uid, hostOnly: disband)) {
      return;
    }
    final ok = await command(
      (a) => disband ? a.disbandParty(partyId) : a.leaveParty(partyId),
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
      _canStillAct(partyId, uid, hostOnly: true) &&
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (context, sheetRef, _) {
          // Sheets live on a separate route, so subscribe to role changes here too.
          final snapshot = sheetRef.watch(partyByIdProvider(party.id));
          final current = snapshot.asData?.value;
          final viewer = sheetRef.watch(currentUserProvider)?.uid;
          final selected = current?.members[member.uid];
          final active =
              !snapshot.isLoading &&
              !snapshot.hasError &&
              current != null &&
              current.phase != PartyPhase.closed &&
              current.members.containsKey(uid) &&
              viewer == uid &&
              selected != null;
          final busy = sheetRef.watch(partyActionsProvider).isLoading;
          // Keep the self card tied to the account username. Other-player cards
          // retain the requested frontend preview until Social is connected.
          final knownFriends = sheetRef.watch(partyFriendsProvider).asData?.value ?? [];
          final matchingFriends = knownFriends.where((f) => f.uid == member.uid);
          final accountName = member.uid == uid
              ? sheetRef.watch(profileDataProvider).asData?.value.username
              : matchingFriends.isEmpty ? null : matchingFriends.first.name;
          return SingleChildScrollView(
            child: SDeckProfileBottomSheet(
              title: selected?.name ?? member.name,
              avatarIndicatorType: SDeckAvatarIndicatorType.textOnly,
              avatarIndicatorText: !active
                  ? 'Player unavailable'
                  : member.uid == uid ? accountName ?? 'Player' : 'Knows 3+',
              // TODO(IA): 'Knows 3+' is the requested design placeholder, not a
              // measured count. Replace it with Social data when available.
              navLink: active && member.uid != uid,
              navLinkTitle: 'View',
              // TODO(IA): Route to this member's public profile once implemented.
              // Explain the missing destination instead of silently ignoring taps.
              onNavLinkTap: active && member.uid != uid
                  ? () => showDialog<void>(
                      context: ctx,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Profile coming soon'),
                        content: const Text('Viewing player profiles is not connected yet. “Knows 3+” is a design placeholder for now.'),
                        actions: [TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('OK'),
                        )],
                      ),
                    )
                  : null,
              buttons: [
                if (active && member.uid == uid)
                  SDeckSolidButton(
                    text: 'Change Name',
                    size: SDeckButtonSize.large,
                    iconLocation: SDeckButtonIconLocation.left,
                    icon: SDeckIcons(
                      SDeckIcon.edit,
                      size: SDeckSize.size24,
                      color: context.component.solidButtonIcon,
                    ),
                    fullWidth: true,
                    onPressed: busy ? null : () => Navigator.pop(ctx, 'name'),
                  ),
                if (active && _canManagePlayer(current, uid, member.uid)) ...[
                  SDeckSolidButton(
                    text: 'Promote to Host',
                    size: SDeckButtonSize.large,
                    iconLocation: SDeckButtonIconLocation.left,
                    icon: SDeckIcons(
                      SDeckIcon.crown,
                      size: SDeckSize.size24,
                      color: context.component.solidButtonIcon,
                    ),
                    fullWidth: true,
                    onPressed: busy
                        ? null
                        : () => Navigator.pop(ctx, 'promote'),
                  ),
                  SDeckOutlineButton(
                    text: 'Kick',
                    size: SDeckButtonSize.large,
                    iconLocation: SDeckButtonIconLocation.left,
                    icon: SDeckIcons(
                      SDeckIcon.x,
                      size: SDeckSize.size24,
                      color: context.semantic.error,
                    ),
                    fullWidth: true,
                    color: SDeckOutlineButtonColor.brightCoral,
                    onPressed: busy
                        ? null
                        : () async {
                            // Keep the profile sheet underneath, as in Party Dev.
                            final confirmed = await confirm(
                              'Wait!',
                              'Are you sure you want to kick ${member.name}?',
                              'Kick',
                              // IA: Explain a departure while this dialog is open;
                              // do not leave a disabled Kick button without context.
                              liveDescription: (dialogRef) {
                                final latest = dialogRef.watch(partyByIdProvider(party.id));
                                if (!latest.isLoading && !latest.hasError &&
                                    latest.asData?.value != null &&
                                    !latest.asData!.value!.members.containsKey(member.uid)) {
                                  return '${member.name} is no longer in this party.';
                                }
                                return 'Are you sure you want to kick ${member.name}?';
                              },
                              canConfirm: (dialogRef) =>
                                  _canActFromSnapshot(
                                    dialogRef.watch(
                                      partyByIdProvider(party.id),
                                    ),
                                    dialogRef.watch(currentUserProvider)?.uid,
                                    uid,
                                    hostOnly: true,
                                  ) &&
                                  !dialogRef
                                      .watch(partyActionsProvider)
                                      .isLoading &&
                                  _canManagePlayer(
                                    dialogRef
                                        .watch(partyByIdProvider(party.id))
                                        .asData
                                        ?.value,
                                    uid,
                                    member.uid,
                                  ),
                            );
                            if (ctx.mounted &&
                                confirmed &&
                                _canStillManagePlayer(
                                  party.id,
                                  uid,
                                  member.uid,
                                )) {
                              Navigator.pop(ctx, 'kick');
                            }
                          },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
    if (!mounted) return;
    if (action == 'name' && mounted) {
      if (member.uid == uid) await renameInParty(party.id, uid);
    } else if (action == 'promote') {
      if (!_canStillManagePlayer(party.id, uid, member.uid)) return;
      await command((a) => a.promoteHost(party.id, member.uid));
    } else if (action == 'kick') {
      if (!_canStillManagePlayer(party.id, uid, member.uid)) return;
      // Recheck after the dialog; a captured callback may outlive host rights.
      if (mounted && _canStillManagePlayer(party.id, uid, member.uid)) {
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
    if (party.game == null) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (libraryContext) => PromptSetupHostPage(
            live: true,
            onBack: () => Navigator.pop(libraryContext),
            onNormal: () async {
              // Recheck after the library was open; no captured host permissions.
              if (!mounted || !libraryContext.mounted || !_canStillAct(party.id, uid, hostOnly: true, lobbyOnly: true)) {
                return;
              }
              final current = ref
                  .read(partyByIdProvider(party.id))
                  .asData!
                  .value!;
              final saved = await Navigator.of(libraryContext).push<bool>(
                MaterialPageRoute<bool>(
                  builder: (_) =>
                      PartySettingsPage(party: current, actorId: uid),
                ),
              );
              // A confirmed write must not wait for the snapshot listener.
              // Cancel returns null, so it keeps the Game Library open.
              if (mounted && libraryContext.mounted && saved == true) {
                Navigator.pop(libraryContext);
              }
            },
          ),
        ),
      );
    } else {
      await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => PartySettingsPage(party: party, actorId: uid),
        ),
      );
    }
  }

  Future<void> pickCards(Party party) async {
    final method = await showModalBottomSheet<PartySelectionMethod>(
      context: context,
      builder: (ctx) => SDeckBottomSheet(
        title: 'Pick 7 Cards',
        buttons: [
          for (final entry in {
            PartySelectionMethod.singleDeck: 'Single Deck',
            PartySelectionMethod.handpicked: 'Handpick',
            PartySelectionMethod.random: 'Random',
          }.entries)
            SDeckSolidButton(
              text: entry.value,
              fullWidth: true,
              onPressed: () => Navigator.pop(ctx, entry.key),
            ),
        ],
      ),
    );
    if (!mounted || method == null) return;
    // Choosing another method resets the saved selection; merely opening does not.
    // Hey, whoever is working on card selection: you can accidentally lose
    // your selected cards just by exploring another option:
    // 1. You've already selected 7 cards.
    // 2. Press Change Cards and choose another method, such as Random or Handpick.
    // 3. Our code immediately clears your saved cards and resets Ready.
    // 4. Press Back without saving replacements.
    // 5. You return with 0 cards selected instead of your original seven.
    // I think we should keep the old cards and Ready status until the new
    // selection is confirmed, so cancel leaves everything unchanged. - IA
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

/// Multi-recipient results are independent: one failure cannot hide successes.
class PartyInviteSheet extends ConsumerStatefulWidget {
  const PartyInviteSheet({super.key, required this.partyId, this.onComplete});
  final ValueChanged<List<PartyInviteNotice>>? onComplete;
  final String partyId;
  @override
  ConsumerState<PartyInviteSheet> createState() => _PartyInviteSheetState();
}

class _PartyInviteSheetState extends ConsumerState<PartyInviteSheet> {
  final selected = <String>{};
  bool busy = false;

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
    return Material(
      color: context.semantic.surface,
      child: SingleChildScrollView(
        child: friends.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: SDeckOutlineButton(
              text: 'Retry friends',
              onPressed: () => ref.invalidate(partyFriendsProvider),
            ),
          ),
          data: (items) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No friends available. Share your party code to invite players.',
                  ),
                ),
              // The same friend sheet used in Game Dev, with UIDs instead of names
              // as selection keys so two friends may safely share a display name.
              SDeckFriendSheet(
                gameCode: widget.partyId,
                friends: [
                  for (final friend in items)
                    SDeckFriendSheetEntry(
                      id: friend.uid,
                      username: friend.name,
                      indicatorText: friend.online ? 'Online' : null,
                    ),
                ],
                selectedIds: selected,
                enabled: !busy,
                onSelectionChanged: (id) => setState(() {
                  if (!selected.remove(id)) selected.add(id);
                }),
                onInvite: (_) => send(),
                onCopyCode: () async {
                  await Clipboard.setData(ClipboardData(text: widget.partyId));
                  if (context.mounted) {
                    partyToast(context, 'Party code copied.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> send() async {
    // IA: A retained button callback must not read context after disposal.
    if (!mounted) return;
    // IA: A popped sheet stays mounted during its closing animation. Capture
    // its route so a completed request cannot start the next send after dismissal.
    // Already submitted Firebase work cannot be recalled by closing the UI.
    final route = ModalRoute.of(context);
    bool canContinue() => mounted && (route?.isActive ?? true);
    // A second callback can arrive before Flutter rebuilds the disabled button.
    if (!canContinue() || busy || selected.isEmpty) return;
    final repository = ref.read(partyRepositoryProvider);
    // Recheck the current list even for callbacks captured before a rebuild.
    final friends = ref.read(partyFriendsProvider);
    if (friends.isLoading || friends.hasError) return;
    // Resolve selected recipients once; keep the per-send availability recheck.
    final namesById = {for (final friend in friends.asData?.value ?? <PartyFriend>[]) friend.uid: friend.name};
    final targets = selected.where(namesById.containsKey).toList();
    if (targets.isEmpty) return;
    setState(() {
      busy = true;
    });
    final notices = <PartyInviteNotice>[];
    final sentNames = <String>[];
    for (final uid in targets) {
      if (!canContinue()) break; // Closing the sheet cancels recipients not yet sent.
      // A friend may disappear while an earlier recipient is being sent.
      final currentFriends = ref.read(partyFriendsProvider);
      if (currentFriends.isLoading || currentFriends.hasError) {
        notices.add(
          const PartyInviteNotice(
            success: false,
            description:
                'Friends could not be refreshed. Reopen the invite sheet and retry.',
          ),
        );
        break;
      }
      if (!(currentFriends.asData?.value.any((f) => f.uid == uid) ?? false)) {
        notices.add(
          const PartyInviteNotice(
            success: false,
            description: 'A selected friend is no longer available.',
          ),
        );
        continue;
      }
      try {
        await repository.invitePlayer(widget.partyId, uid);
        if (canContinue()) {
          setState(() {
            sentNames.add(namesById[uid]!);
            selected.remove(uid);
          });
        }
      } catch (error) {
        // IA: Loss of membership/auth or a closed party invalidates the rest
        // of the batch. Keep prior successes, but do not send more doomed calls.
        final stopBatch = error is PartyFailure && const {
          PartyError.forbidden, PartyError.closed, PartyError.unauthenticated,
          PartyError.permissionDenied,
        }.contains(error.code);
        if (canContinue()) {
          final name = namesById[uid]!;
          notices.add(
            PartyInviteNotice(
              success: false,
              description:
                  error is PartyFailure &&
                      error.code == PartyError.alreadyInParty
                  ? '$name is already in the party.'
                  : '$name: ${partyErrorMessage(error)}${stopBatch ? ' Remaining invitations were not sent.' : ''}',
            ),
          );
        }
        if (stopBatch) break;
      }
    }
    if (!canContinue()) return;
    // Match Party Dev: errors first, then one success toast for the batch.
    // Do not add anyone to the roster; they must accept in Social.
    if (sentNames.isNotEmpty) {
      // IA: For mixed results name the successful recipients, so a success
      // toast cannot be mistaken for confirmation that the whole batch worked.
      notices.add(
        PartyInviteNotice(
          success: true,
          description: notices.isEmpty
              ? 'It will be in their inbox in the Social tab.'
              : 'Sent to ${sentNames.join(', ')}. It will be in their Social inbox.',
        ),
      );
    }
    setState(() => busy = false);
    widget.onComplete?.call(notices);
  }
}

/// Resolve legacy Return to Game links from the signed-in user's session.
class PartySessionPage extends ConsumerWidget {
  const PartySessionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(activePartyProvider)
      .when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(
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
        data: (party) => party != null && party.phase != PartyPhase.closed
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
