/*---------------- account_description_widget.dart -----------------------*/
// Account Description Widget for Login Flow
// Shows a tilted playing card next to username text
// Used specifically in login screens for "Is this your card?" confirmation
//
// Usage: AccountDescriptionWidget(username: 'john', imagePath: '/path/to/image.jpg')
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//----------------------- AccountDescriptionWidget ---------------------------//
/// Login-specific widget that displays a tilted playing card with username
/// Used for the "Is this your card?" confirmation screen in login flow
/// Features a -5 degree rotated card matching Figma design exactly
class AccountDescriptionWidget extends StatelessWidget {
  //*************************** Properties ******************************//
  /// Username text to display next to the card
  final String username;

  /// Optional image path for the playing card
  /// If null, shows checkered background placeholder
  final String? imagePath;

  /// Optional transformation values for the card image
  final double scale;
  final double panX;
  final double panY;

  //*************************** Constructor *****************************//
  const AccountDescriptionWidget({
    super.key,
    required this.username,
    this.imagePath,
    this.scale = 1.0,
    this.panX = 0.0,
    this.panY = 0.0,
  });

  //*************************** Build Method ****************************//
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SDeckSpacing.x16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SDeckRadius.s),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the card+username group
        mainAxisSize: MainAxisSize.min, // Only take needed space
        children: [
          //------------------------ Tilted Playing Card -------------------//
          Transform.rotate(
            angle: -0.087, // -5 degrees in radians (355 deg = -5 deg)
            child: SDeckPlayingCard.smallest(
              imagePath: imagePath,
              scale: scale,
              panX: panX,
              panY: panY,
            ),
          ),

          SizedBox(width: SDeckSpacing.x16), // 16px gap between card and text
          //------------------------ Username Text -------------------------//
          Text(username, style: Theme.of(context).textTheme.h6),
        ],
      ),
    );
  }
}
