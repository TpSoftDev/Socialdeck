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
import '../../tokens/icons/index.dart';

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
            SDeckRadius.borderRadius16,
          ), // 16px
        ),
        child: DottedBorder(
          color: context.semantic.outline,
          strokeWidth: 3,
          dashPattern: [16, 7],
          borderType: BorderType.RRect,
          radius: Radius.circular(SDeckRadius.borderRadius8), // 8px
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SDeckRadius.borderRadius8,
              ), // 8px
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add Profile Card Icon
                  SDeckIcons(
                    SDeckIcon
                        .placeholder, // TODO: addProfileCard missing - using placeholder
                    size: SDeckSize.size48, // Figma size 42px (using closest token size48)
                    color: context.component.iconPrimary,
                  ),

                  // Spacing between icon and text
                  SizedBox(height: SDeckSpace.gap8), // 8px gap
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
