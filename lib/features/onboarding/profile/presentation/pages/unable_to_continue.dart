/*---------------------- unable_to_continue.dart -------------------------*/
// Unable to Continue Page
//
// Purpose:
// - This screen appears when the user denies access to Photos or Camera.
// - It explains that the user must enable permissions in Settings to continue.
// - It provides two actions:
//     1. "Go to Settings" -> opens the device app settings
//     2. "Review Privacy Policy" -> opens the app/privacy policy page
//
// Notes:
// - This screen is based on the Figma edge case flow
// - It is intended for both Android and iOS
/*-----------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:url_launcher/url_launcher.dart';

class UnableToContinuePage extends ConsumerWidget {
  const UnableToContinuePage({super.key});

  //*************************** Constants *********************************//
  // Replace this with your real privacy policy URL later.
  static final Uri _privacyPolicyUrl = Uri.parse(
    'https://socialdeck.example.com/privacy-policy',
  );

  //*************************** Button Actions *****************************//
  // Opens the native app settings page so the user can manually enable
  // Photos / Camera permissions.
  Future<void> _onGoToSettings() async {
    await openAppSettings();
  }

  // Opens the privacy policy page in the user's default browser.
  Future<void> _onReviewPrivacyPolicy(BuildContext context) async {
    final bool launched = await launchUrl(
      _privacyPolicyUrl,
      mode: LaunchMode.externalApplication,
    );

    // Optional fallback message if the link fails to open.
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the privacy policy right now.'),
        ),
      );
    }
  }

  //*************************** Build Method *******************************//
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //------------------------ Header -----------------------------//
                    // Figma shows a short title near the top.
                    Padding(
                      padding: const EdgeInsets.only(
                        top: SDeckSpace.padding16,
                        bottom: SDeckSpace.padding12,
                      ),
                      child: Text(
                        'Uh oh...',
                        style: Theme.of(context).textTheme.h4.copyWith(
                          color: context.component.navigationText,
                        ),
                      ),
                    ),

                    //------------------------ Visual Placeholder -----------------//
                    // This is the same general placeholder area shown in the design.
                    // Later, you may replace this with a Rive animation if desired.
                    buildVisualPlaceholder(context, SDeckIcon.checkeredBackground),

                    const SizedBox(height: SDeckSpace.padding16),

                    //------------------------ Main Message -----------------------//
                    Text(
                      'Unable to continue',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: context.component.textPrimary,
                          ),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    //------------------------ Supporting Message -----------------//
                    Text(
                      'Please check your settings to allow access to photos and camera.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.component.textSecondary,
                          ),
                    ),

                    const SizedBox(height: SDeckSpace.padding16),

                    //------------------------ Go to Settings Button -------------//
                    SizedBox(
                      width: double.infinity,
                      child: SDeckSolidButton(
                        text: 'Go to Settings',
                        size: SDeckButtonSize.large,
                        fullWidth: true,
                        onPressed: _onGoToSettings,
                      ),
                    ),

                    const SizedBox(height: SDeckSpace.gap8),

                    //------------------------ Review Privacy Policy -------------//
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            SDeckRadius.borderRadius16,
                          ),
                          onTap: () => _onReviewPrivacyPolicy(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SDeckSpace.padding24,
                              vertical: SDeckSpace.padding16,
                            ),
                            child: Text(
                              'Review Privacy Policy',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.component.textPrimary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//*************************** Helper Methods ********************************//
//------------------------ Visual Placeholder ----------------------------//
// Reuses the checkered background for now.
// Replace with your final image or Rive animation when ready.
Widget buildVisualPlaceholder(BuildContext context, String imagePath) {
  return Container(
    width: double.infinity,
    height: 130,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}