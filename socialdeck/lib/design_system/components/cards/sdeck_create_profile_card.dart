/*------------------------- sdeck_create_profile_card.dart ----------------------*/
// Create Profile Card component for the SocialDeck design system
// Theme-aware card container for photo upload functionality
// Simple tappable container that triggers photo upload
//
// Usage: SDeckCreateProfileCard(onTap: () => uploadPhoto())
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../tokens/colors/index.dart';
import '../../tokens/index.dart';
import '../../tokens/icons/icons.dart';
import '../icons/sdeck_icon.dart';

class SDeckCreateProfileCard extends StatelessWidget {
  //------------------------------- Properties -----------------------------//
  final VoidCallback? onTap;

  //------------------------------- Constructor ----------------------------//
  const SDeckCreateProfileCard({super.key, this.onTap});

  //*************************** Build Method ********************************//
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 192,
        height: 288,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.semantic.surfaceVariant,
          borderRadius: BorderRadius.circular(
            SDeckRadius.borderRadiusL,
          ), // 16px
        ),
        child: DottedBorder(
          color: context.semantic.outline,
          strokeWidth: 3,
          dashPattern: [16, 7],
          borderType: BorderType.RRect,
          radius: Radius.circular(SDeckRadius.borderRadiusS), // 8px
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SDeckRadius.borderRadiusS,
              ), // 8px
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add Profile Card Icon
                  SDeckIcon(
                    SDeckIcons
                        .placeholder, // TODO: addProfileCard missing - using placeholder
                    width: 42, // Figma width 42px
                    height: 36, // Figma height 36px
                    color: context.component.iconPrimary,
                  ),

                  // Spacing between icon and text
                  SizedBox(height: SDeckSpace.gapXS), // 8px gap
                  // "Upload Photo" Text
                  Text(
                    'Add Card',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: context.component.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
