/*-------------------- profile_page.dart -----------------------*/
// Profile Page for the main app
// Displays user's profile information including profile card and username
// Shows "Edit In-Game Name" button and "More Coming Soon!" message
//
// User Journey: User taps profile tab → Views their profile info → Future editing features
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import '../providers/profile_data_provider.dart';
import '../domain/profile_data_state.dart';

//------------------------------- ProfilePage -----------------------------//
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  //*************************** State Variables ******************************//
  int _currentIndex = 4; // Profile tab is index 4

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.logoWithTitle(title: "Profile"),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SDeckSpace.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //------------------------ Profile Card Section -------------//
                    _buildProfileCardSection(context),

                    SizedBox(height: SDeckSpace.gapM),

                    //------------------------ Edit Button Section --------------//
                    _buildEditButtonSection(context),

                    SizedBox(height: SDeckSpace.gapXS),

                    //------------------------ Username Section -----------------//
                    _buildUsernameSection(context),

                    SizedBox(height: SDeckSpace.gapM),

                    //------------------------ More Coming Soon Section ---------//
                    _buildMoreComingSoonSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------- Helper Methods -----------------------------//

  //*************************** Transform Calculation Helper *******************//
  /// Calculates proportional transform data from adjustment card to profile small card
  ///
  /// The transform data (scale, panX, panY) is saved based on the adjustment card size
  /// but needs to be scaled proportionally when displayed in different card sizes
  ///
  /// Returns a Map with scaled transform values: {scale, panX, panY}
  Map<String, double> _calculateScaledTransforms(ProfileDataState profile) {
    // Adjustment card: 192x288 with 16px padding = 160x256 image area
    // Profile small card: 112x160 with 8px padding = 96x144 image area
    final adjustmentImageWidth = 192.0 - (16.0 * 2); // 160px image area
    final adjustmentImageHeight = 288.0 - (16.0 * 2); // 256px image area
    final profileImageWidth = 112.0 - (8.0 * 2); // 96px image area
    final profileImageHeight = 160.0 - (8.0 * 2); // 144px image area

    final widthRatio = profileImageWidth / adjustmentImageWidth; // 96/160 = 0.6
    final heightRatio =
        profileImageHeight / adjustmentImageHeight; // 144/256 = 0.5625

    // Scale keeps the same (2.0x zoom should still be 2.0x zoom)
    // Pan values scale proportionally to the image area
    final imageScale = profile.scale;
    final imagePanX =
        profile.panX * widthRatio; // Scale pan based on width ratio
    final imagePanY =
        profile.panY * heightRatio; // Scale pan based on height ratio

    return {'scale': imageScale, 'panX': imagePanX, 'panY': imagePanY};
  }

  //*************************** Profile Card Section **************************//
  /// Builds the profile card display section
  /// Shows user's profile photo in playing card format with real data
  Widget _buildProfileCardSection(BuildContext context) {
    final profileData = ref.watch(profileDataProvider);

    return profileData.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => SDeckPlayingCard.small(
            imagePath: null, // Show checkered pattern on error
            scale: 1.0,
            panX: 0.0,
            panY: 0.0,
          ),
      data: (profile) {
        final transforms = _calculateScaledTransforms(profile);

        return SDeckPlayingCard.small(
          imagePath:
              profile
                  .photoUrl, // Real photo URL from Firebase (null = checkered)
          scale: transforms['scale']!, // Proportionally scaled zoom level
          panX:
              transforms['panX']!, // Proportionally scaled horizontal position
          panY: transforms['panY']!, // Proportionally scaled vertical position
        );
      },
    );
  }

  //*************************** Edit Button Section ***************************//
  /// Builds the "Edit In-Game Name" button
  /// Styled to match Figma design with border and hint text appearance
  Widget _buildEditButtonSection(BuildContext context) {
    return Container(
      width: 216, // Matches Figma width
      padding: const EdgeInsets.symmetric(
        horizontal: SDeckSpace.paddingS,
        vertical: SDeckSpace.paddingXS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(SDeckRadius.borderRadiusS),
      ),
      child: Text(
        "Edit In-Game Name",
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.hintText,
        ),
      ),
    );
  }

  //*************************** Username Section *******************************//
  /// Builds the username display section
  /// Shows username in H6 style with async state handling
  Widget _buildUsernameSection(BuildContext context) {
    final profileData = ref.watch(profileDataProvider);
    return profileData.when(
      loading: () => const CircularProgressIndicator(),
      error:
          (error, stack) => Text(
            "Failed to load username",
            style: Theme.of(
              context,
            ).textTheme.h6.copyWith(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
      data:
          (profile) => Text(
            profile.username, // Real username from Firebase (no @ symbol)
            style: Theme.of(context).textTheme.h6,
            textAlign: TextAlign.center,
          ),
    );
  }

  //*************************** More Coming Soon Section *******************//
  /// Builds the "More Coming Soon!" message section
  /// Shows main message and subtitle as per Figma design
  Widget _buildMoreComingSoonSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SDeckSpace.paddingM),
      child: Column(
        children: [
          // Main message
          Text(
            "More Coming Soon!",
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          // Subtitle message
          Text(
            "Let us know how you want to personalize your account.",
            style: Theme.of(context).textTheme.caption.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
