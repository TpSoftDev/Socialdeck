/*------------------------- sdeck_create_profile_card.dart ----------------------*/
// Create Profile Card component for the SocialDeck design system
// Theme-aware card container for photo upload functionality
// Simple tappable container that triggers photo upload
//
// Usage: SDeckCreateProfileCard(onTap: () => uploadPhoto())
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../foundations/index.dart';
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
          color: Theme.of(context).colorScheme.createProfileCardBackground,
          borderRadius: BorderRadius.circular(SDeckRadius.xs), // 16px
        ),
        child: DottedBorder(
          color: Theme.of(context).colorScheme.createProfileCardBorder,
          strokeWidth: 3,
          dashPattern: [16, 7],
          borderType: BorderType.RRect,
          radius: Radius.circular(SDeckRadius.xxs), // 8px
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SDeckRadius.xxs), // 8px
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add Profile Card Icon
                  SDeckIcon(
                    context.icons.addProfileCard,
                    width: 42, // Figma width 42px
                    height: 36, // Figma height 36px
                  ),

                  // Spacing between icon and text
                  SizedBox(height: SDeckSpacing.x8), // 8px gap
                  // "Upload Photo" Text
                  Text(
                    'Add Card',
                    style: Theme.of(context).textTheme.bodyLarge,
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
