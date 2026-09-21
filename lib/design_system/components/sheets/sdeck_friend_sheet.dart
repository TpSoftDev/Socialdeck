/*--------------------------- sdeck_friend_sheet.dart -------------------------*/
// Invite sheet for party lobbies: the party's game code, a horizontal list of
// friends that can be multi-selected, and an invite action that reflects the
// current selection.
//
// The sheet owns the selection so callers only have to react to the final
// invite. Tapping the scrim closes it without inviting anyone.
//
// Usage:
//   showSDeckFriendSheet(
//     context: context,
//     gameCode: '123456',
//     friends: const [
//       SDeckFriendSheetEntry(username: 'tpsoftdev', indicatorText: 'Home'),
//       SDeckFriendSheetEntry(username: 'bolu'),
//     ],
//     onInvite: (List<String> usernames) { ... },
//   )
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import '../../tokens/index.dart';
import '../../themes/text_theme.dart';
import '../avatar/profile_card_enums.dart';
import '../avatar/sdeck_profile_card_placeholder.dart';
import '../buttons/button_enums.dart';
import '../buttons/sdeck_solid_button.dart';
import '../placeholders/sdeck_visual_placeholder.dart';
import '../sections/sdeck_section_header.dart';
import '../selection_target/friend_block_target_enums.dart';
import '../selection_target/sdeck_friend_block_target.dart';

//--------------------------- SDeckFriendSheetEntry --------------------------//
/// One friend in the sheet's list.
class SDeckFriendSheetEntry {
  const SDeckFriendSheetEntry({
    required this.username,
    this.indicatorText,
    this.profile,
  });

  final String username;

  /// Activity status shown under the username, e.g. 'Home' or 'In Party'. A
  /// non-null value marks the friend as online, which also sorts them first.
  final String? indicatorText;

  /// Avatar for this friend. Falls back to the responsive placeholder when null.
  final Widget? profile;

  bool get isOnline => indicatorText != null;
}

//------------------------------ SDeckFriendSheet ----------------------------//
class SDeckFriendSheet extends StatefulWidget {
  //------------------------------- Properties -------------------------------//

  /// The party's join code, shown in full above the friend list.
  final String gameCode;

  /// Friends available to invite. Online friends are listed first.
  final List<SDeckFriendSheetEntry> friends;

  /// Receives the usernames selected when the invite button is pressed.
  final ValueChanged<List<String>> onInvite;

  //------------------------------- Constructor ------------------------------//
  const SDeckFriendSheet({
    super.key,
    required this.gameCode,
    required this.friends,
    required this.onInvite,
  });

  @override
  State<SDeckFriendSheet> createState() => _SDeckFriendSheetState();
}

class _SDeckFriendSheetState extends State<SDeckFriendSheet> {
  /// Figma friendBlockTarget cell. Fixed so the list scrolls past the sheet edge
  /// instead of squeezing avatars as the friend count grows.
  static const double _friendWidth = 108.0;
  static const double _friendHeight = 150.0;

  final Set<String> _selected = <String>{};

  /// Online first, preserving the caller's order within each group.
  List<SDeckFriendSheetEntry> get _orderedFriends {
    final List<SDeckFriendSheetEntry> online = <SDeckFriendSheetEntry>[];
    final List<SDeckFriendSheetEntry> offline = <SDeckFriendSheetEntry>[];
    for (final SDeckFriendSheetEntry friend in widget.friends) {
      (friend.isOnline ? online : offline).add(friend);
    }
    return <SDeckFriendSheetEntry>[...online, ...offline];
  }

  void _toggle(String username) {
    setState(() {
      if (!_selected.remove(username)) {
        _selected.add(username);
      }
    });
  }

  /// Names the single selection so the host can confirm who they are inviting,
  /// and falls back to a count once that would not fit.
  String get _inviteLabel {
    if (_selected.length == 1) return 'Invite ${_selected.first}';
    if (_selected.length > 1) return 'Invite ${_selected.length} Friends';
    return 'Invite';
  }

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.component.sheetSurface,
        boxShadow: SDeckBoxShadows.boxShadowHigh(context.semantic.shadow),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            SDeckSpace.padding16,
            SDeckSpace.padding24,
            SDeckSpace.padding16,
            SDeckSpace.padding48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGameCode(context),
              const SizedBox(height: SDeckSpace.gap12),
              SDeckSectionHeader(
                title: 'Friends',
                supportingText: '${widget.friends.length}',
                padded: false,
              ),
              const SizedBox(height: SDeckSpace.gap12),
              _buildFriendList(),
              const SizedBox(height: SDeckSpace.gap12),
              SDeckSolidButton(
                text: _inviteLabel,
                size: SDeckButtonSize.large,
                fullWidth: true,
                enabled: _selected.isNotEmpty,
                onPressed: () => widget.onInvite(_selected.toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //*************************** Helper Methods ******************************//

  //------------------------------- Game Code -------------------------------//
  Widget _buildGameCode(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(
      SDeckRadius.borderRadius16,
    );
    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          // TODO(party): swap for the Rive combination lock once rive is a dependency.
          Positioned.fill(
            child: SDeckVisualPlaceholder(borderRadius: radius),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SDeckSpace.padding12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Game Code:',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: context.semantic.secondary,
                      ),
                ),
                Text(
                  widget.gameCode,
                  style: Theme.of(context).textTheme.h1.copyWith(
                        color: context.semantic.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------- Friend List -----------------------------//
  /// Scrolls horizontally: four cells already overflow the sheet at the Figma
  /// width, and the list grows with the user's friend count.
  Widget _buildFriendList() {
    final List<SDeckFriendSheetEntry> friends = _orderedFriends;
    return SizedBox(
      height: _friendHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: friends.length,
        separatorBuilder: (_, __) => const SizedBox(width: SDeckSpace.gap8),
        itemBuilder: (BuildContext context, int index) {
          final SDeckFriendSheetEntry friend = friends[index];
          return SizedBox(
            width: _friendWidth,
            child: SDeckFriendBlockTarget(
              username: friend.username,
              indicatorText: friend.indicatorText,
              profile: friend.profile ??
                  const SDeckProfileCardPlaceholder(
                    variant: SDeckProfileCardVariant.responsive,
                  ),
              state: _selected.contains(friend.username)
                  ? SDeckFriendBlockTargetState.selected
                  : SDeckFriendBlockTargetState.enabled,
              onTap: () => _toggle(friend.username),
            ),
          );
        },
      ),
    );
  }
}

//========================== showSDeckFriendSheet =============================//
/// Presents [SDeckFriendSheet] as a modal. Tapping the scrim dismisses without
/// inviting; [onInvite] fires before the sheet is popped.
Future<void> showSDeckFriendSheet({
  required BuildContext context,
  required String gameCode,
  required List<SDeckFriendSheetEntry> friends,
  required ValueChanged<List<String>> onInvite,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color.fromRGBO(31, 31, 31, 0.25),
    useRootNavigator: true,
    isScrollControlled: true,
    clipBehavior: Clip.none,
    builder: (BuildContext sheetContext) => SDeckFriendSheet(
      gameCode: gameCode,
      friends: friends,
      onInvite: (List<String> usernames) {
        Navigator.of(sheetContext).pop();
        onInvite(usernames);
      },
    ),
  );
}
