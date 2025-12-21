/*-------------------- invite_friends_page.dart -----------------------*/
// Invite Friends Onboarding Page
// Screen 7: Final onboarding step - invite friends and earn points
// Custom implementation that matches Figma design exactly with centered icon
//
// User Journey: Profile complete → Invite friends → Home screen (onboarding complete)
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class InviteFriendsPage extends ConsumerStatefulWidget {
  const InviteFriendsPage({super.key});

  @override
  ConsumerState<InviteFriendsPage> createState() => _InviteFriendsPageState();
}

class _InviteFriendsPageState extends ConsumerState<InviteFriendsPage> {
  //*************************** Build Method *******************************//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.logoWithSkip(onActionPressed: _handleSkip),

            //------------------------ Main Content --------------------------//
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SDeckSpace.paddingM),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Left align everything
                  children: [
                    //------------------------ Title -------------------------//
                    Text(
                      "Invite Friends",
                      style: Theme.of(context).textTheme.h4,
                    ),

                    SizedBox(height: SDeckSpace.gapXL),

                    //------------------------ Friends Icon ------------------//
                    Center(
                      child: SDeckIcon(
                        context.icons.friends,
                        width: 64,
                        height: 64,
                      ),
                    ),

                    SizedBox(height: SDeckSpace.gapXL),

                    //------------------------ Body Text ---------------------//
                    Center(
                      child: Text(
                        "Refer a friend and get points to play paid games for free.",
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    //------------------------ Spacer for Button Positioning --//
                    const Spacer(), // Push button to bottom
                    //------------------------ Invite Button -----------------//
                    SDeckSolidButton.large(
                      text: "Invite Friends",
                      fullWidth: true,
                      onPressed: _handleInviteFriends,
                    ),

                    SizedBox(height: SDeckSpace.gapM),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //*************************** Implementation Details *********************//

  /// Handle "Invite Friends" button press
  /// TODO: Implement actual invite functionality (contacts, sharing, etc.)
  void _handleInviteFriends() {
    print('🎉 User wants to invite friends');

    // TODO: Implement invite friends functionality
    // - Access contacts
    // - Share invite links
    // - Social media sharing
    // For now, just complete onboarding

    _completeOnboarding();
  }

  /// Handle "Skip" button press
  /// User chooses to skip inviting friends and complete onboarding
  void _handleSkip() {
    print('⏭️ User skipped inviting friends');
    _completeOnboarding();
  }

  /// Complete onboarding and navigate to main app
  /// This is the final step - user goes to home screen
  void _completeOnboarding() {
    print('✅ Onboarding complete! Navigating to home screen');

    if (mounted) {
      // Navigate to home screen - onboarding is complete
      context.pushReplacement('/home');
    }
  }
}
