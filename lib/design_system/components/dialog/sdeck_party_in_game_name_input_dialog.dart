/*---------------- sdeck_party_in_game_name_input_dialog.dart ---------------*/
// Preset [SDeckInputDialog] for the first join-party step: in-game display name.
// Figma: Socialdeck — Home → inputDialog (node 230:3901).
//
// Stateless: parent owns [TextEditingController] and [primaryButtonEnabled];
// pass [inputState] as [SDeckInputState.hint] or [SDeckInputState.error] only —
// [SDeckInput] derives hint vs focused border from trimmed text.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../tokens/index.dart';
import '../inputs/input_enums.dart';
import 'sdeck_input_dialog.dart';

//======================= SDeckPartyInGameNameInputDialog =====================//
/// **Let's Begin!** card: title + close, visual placeholder, in-game name field,
/// supporting line, and **Next** (enabled once the trimmed name is non-empty).
class SDeckPartyInGameNameInputDialog extends StatelessWidget {
  const SDeckPartyInGameNameInputDialog({
    super.key,
    required this.controller,
    required this.inputState,
    required this.primaryButtonEnabled,
    this.focusNode,
    this.autofocus = false,
    this.onClose,
    this.onNext,
    this.onChanged,
    this.onSubmitted,
    this.dialogWidth,
    this.contentHeight = 92.5,
  });

  final TextEditingController controller;
  final SDeckInputState inputState;
  final bool primaryButtonEnabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final VoidCallback? onClose;
  final VoidCallback? onNext;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double? dialogWidth;
  final double contentHeight;

  static final List<TextInputFormatter> _formatters = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(32),
    FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
  ];

  @override
  Widget build(BuildContext context) {
    final double width =
        dialogWidth ??
        (MediaQuery.sizeOf(context).width - 2 * SDeckSpace.padding24);

    return SDeckInputDialog(
      title: "Let's Begin!",
      showDescription: false,
      showVisualPlaceholder: true,
      showClose: true,
      showInputSideIcons: false,
      contentHeight: contentHeight,
      dialogWidth: width,
      onClose: onClose,
      inputLabel: 'In-Game Name',
      placeholder: 'Enter a name',
      supportingText: 'This is only visible in this party.',
      primaryButtonText: 'Next',
      primaryButtonEnabled: primaryButtonEnabled,
      onPrimaryPressed: onNext,
      inputState: inputState,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      maxLength: 32,
      inputFormatters: _formatters,
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}
