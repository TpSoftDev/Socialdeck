/*---------------- account_description_widget.dart -----------------------*/
// Account Description Widget for Login Flow
// Shows a tilted playing card next to username text
// Used specifically in login screens for "Is this your card?" confirmation
//
// Usage: AccountDescriptionWidget(username: 'john', imagePath: '/path/to/image.jpg')
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';
import '../../../profile/presentation/services/test_profile_storage.dart';
import 'dart:io';

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
    return FutureBuilder<Map<String, dynamic>?>(
      // Load saved profile data when widget builds
      future: TestProfileStorage.loadProfile(),
      builder: (context, snapshot) {
        // Use saved data if available AND valid, otherwise fall back to passed parameters
        String? finalImagePath = imagePath;
        double finalScale = scale;
        double finalPanX = panX;
        double finalPanY = panY;

        if (snapshot.hasData && snapshot.data != null) {
          // We have saved profile data - but validate it first!
          final profileData = snapshot.data!;
          final savedImagePath = profileData['imagePath'] as String?;

          // Only use saved data if the image file actually exists
          if (savedImagePath != null && File(savedImagePath).existsSync()) {
            finalImagePath = savedImagePath;
            finalScale = profileData['scale'] ?? 1.0;

            // Scale pan values proportionally for smallest card
            // Adjustment card: 192px × 288px, Smallest card: 68px × 96px
            finalPanX =
                (profileData['panX'] ?? 0.0) * (68.0 / 192.0); // Scale width
            finalPanY =
                (profileData['panY'] ?? 0.0) * (96.0 / 288.0); // Scale height
          }
          // If file doesn't exist, fall back to passed parameters (likely null = checkered)
        }

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
                  imagePath: finalImagePath,
                  scale: finalScale,
                  panX: finalPanX,
                  panY: finalPanY,
                ),
              ),

              SizedBox(
                width: SDeckSpacing.x16,
              ), // 16px gap between card and text
              //------------------------ Username Text -------------------------//
              Text(username, style: Theme.of(context).textTheme.h6),
            ],
          ),
        );
      },
    );
  }
}
