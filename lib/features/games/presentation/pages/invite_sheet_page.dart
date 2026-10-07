/*-------------------- invite_sheet_page.dart -----------------------*/
// Isolated Prompt'd party lobby sandbox.
// Opened from Party Dev so the lobby and its invite sheet can be built without
// changing the live party or social flows.
//
// Custom AI (default) shows the play-style helper. Normal mode omits it —
// that is the Play Prompt'd → Normal destination.
// Serves both lobby roles: the host sees Your Options (meatballs), a player
// sees leave. Tapping your own seat opens a Change Name profile sheet.
// Either can open the invite sheet from the free seat.
//
// Assembled from existing design system components. Player avatars and the
// cards target use SDeckVisualPlaceholder until the Rive PlayerCard lands.
/*--------------------------------------------------------------------------*/

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/home/presentation/dialogs/home_party_flow_dialogs.dart';

//------------------------------- PartyLobbyRole ------------------------------//
/// Who is looking at the lobby. Drives the top bar action and the helper copy;
/// both roles can still invite from the free seat.
enum PartyLobbyRole { host, player }

//------------------------------- PartyPlayMode -------------------------------//
/// Prompt'd setup choice from the Play Prompt'd sheet.
/// Custom AI shows the lobbyHelper chips; Normal skips that block.
enum PartyPlayMode { normal, customAi }

//------------------------------- InviteSheetPage -----------------------------//
class InviteSheetPage extends StatefulWidget {
  const InviteSheetPage({
    super.key,
    this.role = PartyLobbyRole.host,
    this.playMode = PartyPlayMode.customAi,
  });

  final PartyLobbyRole role;

  /// Nullable so a hot reload of an already-mounted lobby cannot crash when
  /// this field did not exist on the previous widget instance.
  final PartyPlayMode? playMode;

  @override
  State<InviteSheetPage> createState() => _InviteSheetPageState();
}

class _InviteSheetPageState extends State<InviteSheetPage>
    with SingleTickerProviderStateMixin {
  /// Party capacity. The grid always renders this many slots.
  static const int _maxPlayers = 8;

  /// Slots per grid row, matching the Figma 4×2 layout.
  static const int _slotsPerRow = 4;

  /// Figma largeImageTarget height.
  static const double _cardsTargetHeight = 128.0;

  /// Figma topBar sticker slot height. Width follows the artwork's aspect ratio.
  static const double _stickerHeight = SDeckSize.size48;

  /// Figma lobbyHelper inner content width — keeps the chip row wrapping
  /// tightly instead of spanning the full screen.
  static const double _lobbyHelperWidth = 280.0;

  // TODO(backend): replace with the live party code from the lobby provider.
  static const String _gameCode = '123456';

  // TODO(backend): replace with the live party roster from the lobby provider.
  // Normal Figma seats only the host. Custom AI sandbox also seats thabang
  // (owns Prompt'd → can be promoted) and bolu (does not → Promote disabled).
  static const List<String> _normalHostRoster = <String>['ethan'];
  static const List<String> _customHostRoster = <String>[
    'ethan',
    'thabang',
    'bolu',
  ];
  static const List<String> _playerRoster = <String>['ethan', 'thabang'];

  // TODO(backend): replace with the signed-in user's friends from Social.
  // Host list matches the happy-path invite sheet. The player list includes
  // eth6n (In Party) so the invite-error edge case can be exercised without
  // a live roster check.
  static const List<SDeckFriendSheetEntry> _hostFriends =
      <SDeckFriendSheetEntry>[
        SDeckFriendSheetEntry(username: 'tpsoftdev', indicatorText: 'Home'),
        SDeckFriendSheetEntry(username: 'bolu'),
        SDeckFriendSheetEntry(username: 'friend2'),
        SDeckFriendSheetEntry(username: 'friend3'),
      ];

  static const List<SDeckFriendSheetEntry> _playerFriends =
      <SDeckFriendSheetEntry>[
        SDeckFriendSheetEntry(username: 'eth6n', indicatorText: 'In Party'),
        SDeckFriendSheetEntry(username: 'bolu'),
        SDeckFriendSheetEntry(username: 'friend2'),
        SDeckFriendSheetEntry(username: 'friend3'),
      ];

  // TODO(backend): replace with the play styles chosen during party setup.
  static const List<(String, SDeckChipColor)> _playStyles =
      <(String, SDeckChipColor)>[
        ('Coworkers', SDeckChipColor.tangerine),
        ('Dark Humor', SDeckChipColor.mintGreen),
        ('Brainrot', SDeckChipColor.vibrantYellow),
      ];

  //------------------------------- Toast state ------------------------------//
  /// Drops in from above the top bar, then eases back out.
  static const Duration _toastEnterDuration = Duration(milliseconds: 320);
  static const Duration _toastExitDuration = Duration(milliseconds: 420);

  late final AnimationController _toastAnim = AnimationController(
    vsync: this,
    duration: _toastEnterDuration,
  );

  late final Animation<Offset> _toastSlide = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _toastAnim,
      curve: SDeckMotionCurve.easeDecelerate,
      reverseCurve: SDeckMotionCurve.easeInOut,
    ),
  );

  ({SDeckToastStatus status, String title, String description})? _toast;
  final List<({SDeckToastStatus status, String title, String description})>
  _toastQueue =
      <({SDeckToastStatus status, String title, String description})>[];
  Timer? _toastDismissTimer;

  /// Guards against the `dismissed` status that `forward(from: 0)` emits, which
  /// would otherwise clear the toast as soon as it appeared.
  bool _toastAwaitingRemoval = false;

  bool get _isHost => widget.role == PartyLobbyRole.host;

  /// In-game name of the signed-in user. Lazy so a hot reload cannot crash,
  /// and so Change Name can rewrite it without touching the role default.
  String? _inGameNameOverride;
  String get _selfUsername =>
      _inGameNameOverride ??= _isHost ? 'ethan' : 'thabang';

  /// Account username on the self profile card. Distinct from the in-game name
  /// so the party can stay anonymous in the lobby grid.
  String get _selfAccountUsername => _isHost ? 'eth6n' : 'tpsoftdev';

  /// Mutable copy of the seated players. Lazily filled so a hot reload, which
  /// skips [initState], cannot leave the list uninitialized.
  List<String>? _rosterOverride;

  bool get _isCustomAi =>
      (widget.playMode ?? PartyPlayMode.customAi) == PartyPlayMode.customAi;

  List<String> get _initialRoster {
    if (!_isHost) return _playerRoster;
    return _isCustomAi ? _customHostRoster : _normalHostRoster;
  }

  List<String> get _roster =>
      _rosterOverride ??= List<String>.from(_initialRoster);

  List<SDeckFriendSheetEntry> get _friends =>
      _isHost ? _hostFriends : _playerFriends;

  @override
  void dispose() {
    _toastAnim.removeStatusListener(_onToastAnimationStatus);
    _toastAnim.dispose();
    _toastDismissTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _toastAnim.addStatusListener(_onToastAnimationStatus);
  }

  //*************************** Invite Flow **********************************//
  void _openInviteSheet() {
    showSDeckFriendSheet(
      context: context,
      gameCode: _gameCode,
      friends: _friends,
      onInvite: _onInvite,
    );
  }

  /// Invites land in the recipient's Social inbox, so the roster is unchanged
  /// until they accept. Failures (already in the party) get an error toast;
  /// anyone the mock treats as invitable still gets the success toast, queued
  /// so each one stays up for the wait-token duration.
  void _onInvite(List<String> usernames) {
    if (usernames.isEmpty) return;

    final List<String> alreadyInParty =
        usernames.where(_isAlreadyInParty).toList();
    final List<String> invited =
        usernames.where((String name) => !_isAlreadyInParty(name)).toList();

    for (final String name in alreadyInParty) {
      _enqueueToast(
        status: SDeckToastStatus.error,
        title: 'Invite Error',
        description: '$name is already in the party.',
      );
    }
    if (invited.isNotEmpty) {
      _enqueueToast(
        status: SDeckToastStatus.success,
        title: 'Invite Sent',
        description: 'It will be in their inbox in the Social tab.',
      );
    }
  }

  /// Frontend stand-in for the server's "already seated" check. Live invites
  /// should key off party membership from the backend, not this indicator.
  bool _isAlreadyInParty(String username) {
    if (_roster.contains(username)) return true;
    for (final SDeckFriendSheetEntry friend in _friends) {
      if (friend.username == username) {
        return friend.indicatorText == 'In Party';
      }
    }
    return false;
  }

  //*************************** Your Options *********************************//
  /// Host meatballs. Reuses [showSDeckBottomSheet] with no close control.
  void _openYourOptions() {
    showSDeckBottomSheet(
      context: context,
      title: 'Your Options',
      showCloseButton: false,
      buttons: <Widget>[
        SDeckSolidButton(
          text: 'Game Settings',
          size: SDeckButtonSize.large,
          fullWidth: true,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.settings,
            size: SDeckSize.size24,
            color: context.component.solidButtonIcon,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            context.push(AppPaths.promptSettingsDev);
          },
        ),
        SDeckOutlineButton(
          text: 'Change Name',
          size: SDeckButtonSize.large,
          fullWidth: true,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.edit,
            size: SDeckSize.size24,
            color: context.component.outlineButtonIcon,
          ),
          onPressed: () => _closeOverlayThen(_showChangeNameDialog),
        ),
        SDeckOutlineButton(
          text: 'Leave',
          size: SDeckButtonSize.large,
          fullWidth: true,
          color: SDeckOutlineButtonColor.brightCoral,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.leave,
            size: SDeckSize.size24,
            color: context.semantic.error,
          ),
          onPressed: () => _closeOverlayThen(_leaveParty),
        ),
      ],
    );
  }

  /// True when Leave should skip the Leave/Disband dialog and just disband:
  /// host is alone, or nobody else in the party owns a game that can host.
  bool get _shouldSkipLeaveDialog {
    if (!_isHost) return false;
    if (_roster.length <= 1) return true;
    return !_roster.any(
      (String name) => name != _selfUsername && _canPromoteToHost(name),
    );
  }

  /// Host meatballs Leave, or the player's top-bar leave icon.
  void _leaveParty() {
    if (_shouldSkipLeaveDialog) {
      _exitLobby();
      return;
    }
    if (_isHost) {
      HomePartyFlowDialogs.showLeavePartyThen(
        context,
        onLeaveParty: _exitLobby,
        onDisbandParty: _exitLobby,
      );
      return;
    }
    _showPlayerLeaveDialog();
  }

  /// Player confirmation: leave this party. Disband is host-only.
  Future<void> _showPlayerLeaveDialog() async {
    final double dialogWidth =
        MediaQuery.sizeOf(context).width - 2 * SDeckSpace.margin32;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
          child: SDeckDialog(
            title: 'Leave Party',
            description: 'Are you sure you want to leave your current party?',
            showVisualPlaceholder: false,
            dialogWidth: dialogWidth,
            primaryButtonText: 'Leave',
            onPrimaryPressed: () => Navigator.of(dialogContext).pop(true),
            onClose: () => Navigator.of(dialogContext).pop(false),
          ),
        );
      },
    );

    if (confirmed == true && mounted) {
      _exitLobby();
    }
  }

  void _exitLobby() {
    if (context.canPop()) {
      context.pop();
    }
  }

  /// Pop the current sheet, then run [next] on the next frame so a follow-up
  /// dialog is not fighting the sheet route.
  void _closeOverlayThen(VoidCallback next) {
    Navigator.of(context, rootNavigator: true).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) next();
    });
  }

  Future<void> _showChangeNameDialog() async {
    final String? updated = await showDialog<String>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
      builder: (BuildContext dialogContext) {
        return _ChangeNameDialog(
          initialName: _selfUsername,
          dialogContext: dialogContext,
        );
      },
    );

    if (updated != null && mounted) {
      _applyInGameName(updated);
    }
  }

  void _applyInGameName(String name) {
    final String previous = _selfUsername;
    setState(() {
      final int index = _roster.indexOf(previous);
      if (index >= 0) {
        _roster[index] = name;
      }
      _inGameNameOverride = name;
    });
  }

  //*************************** Player Profile ********************************//
  /// Opens the seated player's sheet. Your own seat is Change Name only;
  /// another player's sheet is Promote + Kick for the host.
  void _openPlayerSheet(String username) {
    if (username == _selfUsername) {
      _openSelfSheet();
      return;
    }

    showSDeckProfileBottomSheet(
      context: context,
      title: username,
      // In-game name + mutual friends. Username stays off the card for anonymity.
      avatarIndicatorType: SDeckAvatarIndicatorType.textOnly,
      avatarIndicatorText: 'Knows 3+',
      avatarIndicatorAvatar: SDeckVisualPlaceholder(
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
      ),
      navLink: true,
      navLinkTitle: 'View',
      // TODO(party): push this player's profile.
      onNavLinkTap: () {},
      buttons: _isHost ? _hostPlayerActions(username) : null,
    );
  }

  /// Figma self profile: in-game name + account username, no View, card is
  /// inert. Change Name is the only action.
  void _openSelfSheet() {
    showSDeckProfileBottomSheet(
      context: context,
      title: _selfUsername,
      avatarIndicatorType: SDeckAvatarIndicatorType.textOnly,
      avatarIndicatorText: _selfAccountUsername,
      navLink: false,
      buttons: <Widget>[
        SDeckSolidButton(
          text: 'Change Name',
          size: SDeckButtonSize.large,
          fullWidth: true,
          iconLocation: SDeckButtonIconLocation.left,
          iconTextGap: SDeckSpace.gap6,
          icon: SDeckIcons(
            SDeckIcon.edit,
            size: SDeckSize.size24,
            color: context.component.solidButtonIcon,
          ),
          onPressed: () => _closeOverlayThen(_showChangeNameDialog),
        ),
      ],
    );
  }

  List<Widget> _hostPlayerActions(String username) {
    final bool canHost = _canPromoteToHost(username);
    return <Widget>[
      SDeckSolidButton(
        text: 'Promote to Host',
        size: SDeckButtonSize.large,
        fullWidth: true,
        enabled: canHost,
        iconLocation: SDeckButtonIconLocation.left,
        iconTextGap: SDeckSpace.gap6,
        icon: SDeckIcons(
          SDeckIcon.crown,
          size: SDeckSize.size24,
          color: context.component.solidButtonIcon,
        ),
        onPressed: canHost ? () => _promoteToHost(username) : () {},
      ),
      SDeckOutlineButton(
        text: 'Kick',
        size: SDeckButtonSize.large,
        fullWidth: true,
        color: SDeckOutlineButtonColor.brightCoral,
        iconLocation: SDeckButtonIconLocation.left,
        iconTextGap: SDeckSpace.gap6,
        icon: SDeckIcons(
          SDeckIcon.x,
          size: SDeckSize.size24,
          color: context.semantic.error,
        ),
        onPressed: () => _showKickDialog(username),
      ),
    ];
  }

  /// Account username shown in kick / promote copy. Distinct from the in-game
  /// name on the player card so the party can stay anonymous in the lobby grid.
  // TODO(backend): resolve the seated player's Social username from the party.
  String _accountUsername(String inGameName) {
    switch (inGameName) {
      case 'thabang':
        return 'tpsoftdev';
      case 'ethan':
        return 'eth6n';
      default:
        return inGameName;
    }
  }

  /// True when this seated player owns a game and can take host.
  // TODO(backend): replace with the live ownership check from the party.
  bool _canPromoteToHost(String inGameName) => inGameName == 'thabang';

  /// Figma Promote Host: close the sheet and notify the party. The current
  /// user stays on this lobby; live host transfer is a backend concern.
  void _promoteToHost(String inGameName) {
    Navigator.of(context, rootNavigator: true).pop();
    _enqueueToast(
      status: SDeckToastStatus.info,
      title: 'New Host',
      description: '${_accountUsername(inGameName)} will now lead the party.',
    );
  }

  /// Figma Kick Player Edge Case: confirm before removing someone, then
  /// return to the lobby with a note toast. Back leaves the profile sheet up.
  Future<void> _showKickDialog(String inGameName) async {
    final String username = _accountUsername(inGameName);
    final double dialogWidth =
        MediaQuery.sizeOf(context).width - 2 * SDeckSpace.margin32;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
          child: SDeckDialog(
            title: 'Wait!',
            description: 'Are you sure you want to kick $username?',
            showClose: false,
            dialogWidth: dialogWidth,
            secondaryButtonText: 'Back',
            onSecondaryPressed: () => Navigator.of(dialogContext).pop(false),
            primaryAction: SDeckSolidButton(
              text: 'Kick',
              size: SDeckButtonSize.medium,
              fullWidth: true,
              color: SDeckSolidButtonColor.brightCoral,
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ),
        );
      },
    );

    if (confirmed == true && mounted) {
      _kickPlayer(inGameName, username);
    }
  }

  void _kickPlayer(String inGameName, String username) {
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _roster.remove(inGameName);
    });
    _enqueueToast(
      status: SDeckToastStatus.note,
      title: 'Player Kicked',
      description: '$username is no longer in the party.',
    );
  }

  //*************************** Toast ****************************************//
  void _enqueueToast({
    required SDeckToastStatus status,
    required String title,
    required String description,
  }) {
    final ({SDeckToastStatus status, String title, String description})
    payload = (status: status, title: title, description: description);
    if (_toast == null && !_toastAnim.isAnimating) {
      _displayToast(payload);
    } else {
      _toastQueue.add(payload);
    }
  }

  void _displayToast(
    ({SDeckToastStatus status, String title, String description}) payload,
  ) {
    _toastDismissTimer?.cancel();
    _toastAwaitingRemoval = false;
    setState(() => _toast = payload);
    _toastAnim.duration = _toastEnterDuration;
    _toastAnim.forward(from: 0);
    _toastDismissTimer = Timer(SDeckMotionDuration.wait, () {
      if (mounted) _dismissToast();
    });
  }

  void _dismissToast() {
    _toastDismissTimer?.cancel();
    _toastDismissTimer = null;
    if (_toast == null) return;
    _toastAwaitingRemoval = true;
    _toastAnim.duration = _toastExitDuration;
    _toastAnim.reverse();
  }

  void _onToastAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && _toastAwaitingRemoval) {
      _toastAwaitingRemoval = false;
      if (!mounted) return;
      setState(() => _toast = null);
      if (_toastQueue.isNotEmpty) {
        _displayToast(_toastQueue.removeAt(0));
      }
    }
  }

  //*************************** Build ****************************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: context.semantic.surface,
      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: 0,
        // Sandbox only — tab switching stays disabled while this lives in Party Dev.
        onTap: (int _) {},
        items: SDeckBottomNavBar.defaultItems,
      ),
      // The toast overlays the top bar, so it sits above the page content.
      body: Stack(
        children: [
          _buildLobby(context),
          if (_toast != null) _buildToastLayer(context),
        ],
      ),
    );
  }

  //*************************** Lobby ****************************************//
  Widget _buildLobby(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          SDeckTopNavigationBar(
            left: SDeckTopBarLeft.back,
            type: SDeckTopBarType.page,
            right: SDeckTopBarRight.icon,
            centerWidget: Image.asset(
              SDeckIcon.promptdSticker,
              height: _stickerHeight,
              fit: BoxFit.contain,
            ),
            // The host manages the party; a player can only leave it.
            rightIcon: SDeckIcons(
              _isHost ? SDeckIcon.more : SDeckIcon.leave,
              size: SDeckSize.size36,
              color:
                  _isHost
                      ? context.component.navigationIcon
                      : context.semantic.error,
            ),
            onRightPressed: _isHost ? _openYourOptions : _leaveParty,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                SDeckSpace.margin16,
                SDeckSpace.paddingZero,
                SDeckSpace.margin16,
                SDeckSpace.padding16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isCustomAi) ...[
                    _buildLobbyHelper(context),
                    const SizedBox(height: SDeckSpace.gap16),
                  ],

                  //------------------- Players ------------------//
                  SDeckSectionHeader(
                    title: 'Players',
                    supportingText: '${_roster.length}/$_maxPlayers',
                    padded: false,
                  ),
                  const SizedBox(height: SDeckSpace.gap12),
                  _buildPlayerGrid(context),
                  const SizedBox(height: SDeckSpace.gap16),

                  //------------------- Cards --------------------//
                  const SDeckSectionHeader(title: 'Cards', padded: false),
                  const SizedBox(height: SDeckSpace.gap12),
                  SDeckImageTarget(
                    title: 'Pick 7 Cards',
                    description: 'Choose from one or many decks.',
                    height: _cardsTargetHeight,
                    centerContent: true,
                    // TODO(party): push the deck / card selection flow.
                    onTap: () {},
                  ),
                  const SizedBox(height: SDeckSpace.gap16),

                  //------------------- Ready --------------------//
                  // Stays disabled until the host has picked their cards.
                  SDeckSolidButton(
                    text: 'Ready',
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    enabled: false,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //*************************** Toast Layer **********************************//
  /// Sits over the top bar, inset from the safe area like the Figma Safe Area
  /// frame. Tapping the close glyph dismisses it early.
  Widget _buildToastLayer(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SDeckSpace.padding16,
            SDeckSpace.padding16,
            SDeckSpace.padding16,
            SDeckSpace.paddingZero,
          ),
          child: SlideTransition(
            position: _toastSlide,
            child: Align(
              alignment: Alignment.topCenter,
              child: SDeckToast(
                status: _toast!.status,
                title: _toast!.title,
                description: _toast!.description,
                onDismiss: _dismissToast,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //*************************** Lobby Helper *********************************//
  /// Figma lobbyHelper: caption over a centered, wrapping chip list.
  Widget _buildLobbyHelper(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _lobbyHelperWidth,
        child: Column(
          children: [
            Text(
              // The host picked the styles; a player inherits the host's choice.
              _isHost
                  ? 'You chose to play based on:'
                  : 'You will play based on:',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.caption.copyWith(color: context.semantic.secondary),
            ),
            const SizedBox(height: SDeckSpace.gap12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: SDeckSpace.gap4,
              runSpacing: SDeckSpace.gap4,
              children: <Widget>[
                for (final (String label, SDeckChipColor color) in _playStyles)
                  SDeckChip(label: label, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Player Grid **********************************//
  /// Renders [_maxPlayers] slots: joined players first, then a single invite
  /// target in the next free slot, then empty placeholders for the remainder.
  /// The invite target disappears once the party is full.
  Widget _buildPlayerGrid(BuildContext context) {
    final List<Widget> slots = <Widget>[];
    for (int i = 0; i < _maxPlayers; i++) {
      if (i < _roster.length) {
        final String username = _roster[i];
        slots.add(
          _PlayerSlot(
            username: username,
            onTap: () => _openPlayerSheet(username),
          ),
        );
      } else if (i == _roster.length) {
        slots.add(_InviteSlot(onTap: _openInviteSheet));
      } else {
        slots.add(const _EmptySlot());
      }
    }

    final List<Widget> rows = <Widget>[];
    for (int start = 0; start < slots.length; start += _slotsPerRow) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: SDeckSpace.gap8));
      }
      rows.add(
        _buildSlotRow(
          slots.sublist(start, (start + _slotsPerRow).clamp(0, slots.length)),
        ),
      );
    }
    return Column(children: rows);
  }

  /// Equal-width slots aligned to the top so avatar rows line up even though
  /// only the player slot carries a username beneath it.
  Widget _buildSlotRow(List<Widget> slots) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < slots.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: SDeckSpace.gap12));
      }
      children.add(Expanded(child: slots[i]));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

//=============================== _PlayerSlot =================================//
/// Figma playerBlockTarget, Player state: circular avatar + in-game name.
class _PlayerSlot extends StatelessWidget {
  const _PlayerSlot({required this.username, this.onTap});

  final String username;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO(party): swap for the Rive PlayerCard once rive is a dependency.
            AspectRatio(
              aspectRatio: 1,
              child: SDeckVisualPlaceholder(
                borderRadius: BorderRadius.circular(
                  SDeckRadius.borderRadius999,
                ),
              ),
            ),
            const SizedBox(height: SDeckSpace.gap4),
            Text(
              username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.footer.copyWith(
                color: context.component.selectionTargetTitleText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//=============================== _InviteSlot =================================//
/// Figma addTarget: square plus target sized to one grid slot.
/// SDeckAddTarget is fixed at 116×156 for deck creation, so it cannot be
/// reused inside this grid.
class _InviteSlot extends StatelessWidget {
  const _InviteSlot({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(
      SDeckRadius.borderRadius48,
    );
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashFactory: NoSplash.splashFactory,
          overlayColor: const WidgetStatePropertyAll<Color?>(
            Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.semantic.tertiary,
              borderRadius: radius,
              border: Border.all(
                color: context.component.selectionTargetBorder,
                width: SDeckSize.size4,
              ),
            ),
            child: Center(
              child: SDeckIcons(
                SDeckIcon.plus,
                size: SDeckSize.size48,
                color: context.component.iconTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//=============================== _EmptySlot ==================================//
/// Figma playerBlockTarget, Empty state: a dashed ring for an unclaimed seat.
class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _DashedRingPainter(
          color: context.semantic.tertiary,
          strokeWidth: SDeckSize.size4,
        ),
      ),
    );
  }
}

//============================ _DashedRingPainter =============================//
/// Paints a dashed circle inscribed in the given size. Painted rather than
/// shipped as an asset so the dashes stay evenly spaced at any cell width and
/// the ring picks up the theme color.
class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  /// Target arc lengths in logical pixels, before rounding to a whole number of
  /// dashes. Tuned against the Figma empty seat.
  static const double _dashLength = 12.0;
  static const double _gapLength = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Inset by half the stroke so the ring is not clipped by the bounds.
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    if (radius <= 0) return;

    final Rect bounds = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    // Round to a whole number of dash+gap pairs so the ring closes evenly
    // instead of leaving a short dash where the sweep wraps around.
    const double pairLength = _dashLength + _gapLength;
    final int dashCount = math.max(
      1,
      (2 * math.pi * radius / pairLength).round(),
    );
    final double pairSweep = 2 * math.pi / dashCount;
    final double dashSweep = pairSweep * (_dashLength / pairLength);

    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(bounds, i * pairSweep, dashSweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

//============================ _ChangeNameDialog ==============================//
/// Figma Change Name inputDialog. Prefills the current in-game name; Update
/// stays disabled while the field is empty, then applies immediately.
class _ChangeNameDialog extends StatefulWidget {
  const _ChangeNameDialog({
    required this.initialName,
    required this.dialogContext,
  });

  final String initialName;
  final BuildContext dialogContext;

  @override
  State<_ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<_ChangeNameDialog> {
  static final List<TextInputFormatter> _formatters = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(32),
    FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
  ];

  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );
  late final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _close() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (Navigator.of(widget.dialogContext).canPop()) {
      Navigator.of(widget.dialogContext).pop();
    }
  }

  void _submit() {
    final String trimmed = _controller.text.trim();
    if (trimmed.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (Navigator.of(widget.dialogContext).canPop()) {
      Navigator.of(widget.dialogContext).pop(trimmed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool nameOk = _controller.text.trim().isNotEmpty;
    final double width =
        MediaQuery.sizeOf(context).width - 2 * SDeckSpace.padding24;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(SDeckSpace.margin32),
      child: SDeckInputDialog(
        title: 'Change Name',
        showDescription: false,
        showVisualPlaceholder: true,
        showClose: true,
        showInputSideIcons: false,
        dialogWidth: width,
        onClose: _close,
        inputLabel: 'In-Game Name',
        placeholder: 'Enter a name',
        supportingText: 'This is only visible in this party.',
        primaryButtonText: 'Update',
        primaryButtonEnabled: nameOk,
        onPrimaryPressed: _submit,
        inputState: SDeckInputState.hint,
        controller: _controller,
        focusNode: _focus,
        autofocus: true,
        onSubmitted: (_) => _submit(),
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        maxLength: 32,
        inputFormatters: _formatters,
        enableSuggestions: false,
        autocorrect: false,
      ),
    );
  }
}
