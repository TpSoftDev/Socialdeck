import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

class SDeckPartyLeavingBottomSheet extends StatelessWidget {
  final VoidCallback onLeaveParty;
  final VoidCallback onDisbandParty;

  const SDeckPartyLeavingBottomSheet({
    super.key,
    required this.onLeaveParty,
    required this.onDisbandParty,
  });

  @override
  Widget build(BuildContext context) {
    return SDeckBottomSheet(
      title: 'Leaving?',
      description: 'As the host, you can either:',
      showCloseButton: false,
      buttons: [
        SDeckSolidButton(
          text: 'Leave Party',
          size: SDeckButtonSize.large,
          fullWidth: true,
          color: SDeckSolidButtonColor.brightCoral,
          onPressed: onLeaveParty,
        ),
        SDeckOutlineButton(
          text: 'Disband Party',
          size: SDeckButtonSize.large,
          fullWidth: true,
          color: SDeckOutlineButtonColor.brightCoral,
          onPressed: onDisbandParty,
        ),
      ],
    );
  }
}