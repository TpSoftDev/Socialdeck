/*--------------------- sdeck_party_code_input_dialog.dart -------------------*/
// Preset [SDeckInputDialog] for joining a party with a 6-digit code.
// Figma: Socialdeck — Home → inputDialog (node 230:3913).
//
// Stateless: parent owns [TextEditingController], derives [inputState] and
// [primaryButtonEnabled], and wires [onClose] / [onNext].
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../tokens/index.dart';
import '../inputs/input_enums.dart';
import 'sdeck_input_dialog.dart';

//=========================== SDeckPartyCodeInputDialog =======================//
/// “Enter Code” card: title + close, visual placeholder, party code field,
/// supporting line, and **Next** (enabled only when six digits are entered).
class SDeckPartyCodeInputDialog extends StatelessWidget {
  const SDeckPartyCodeInputDialog({
    super.key,
    required this.controller,
    required this.inputState,
    required this.primaryButtonEnabled,
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
  final VoidCallback? onClose;
  final VoidCallback? onNext;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double? dialogWidth;
  final double contentHeight;

  static final List<TextInputFormatter> _formatters = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(6),
  ];

  @override
  Widget build(BuildContext context) {
    final double width =
        dialogWidth ??
        (MediaQuery.sizeOf(context).width - 2 * SDeckSpace.padding24);

    return SDeckInputDialog(
      title: 'Enter Code',
      showDescription: false,
      showVisualPlaceholder: true,
      showClose: true,
      showInputSideIcons: false,
      contentHeight: contentHeight,
      dialogWidth: width,
      onClose: onClose,
      inputLabel: 'Party Code',
      placeholder: 'Enter 6-digit code',
      supportingText: 'Ask the party leader for the code.',
      primaryButtonText: 'Next',
      primaryButtonEnabled: primaryButtonEnabled,
      onPrimaryPressed: onNext,
      inputState: inputState,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      inputFormatters: _formatters,
    );
  }
}
