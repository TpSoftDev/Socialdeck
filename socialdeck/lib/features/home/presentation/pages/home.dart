import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../../../onboarding/shared/services/google_auth_service.dart';

//------------------------------- HomePage -----------------------------//
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// Called when user wants to log out
  void _handleLogout() async {
    // Sign out from Firebase (this will automatically update our auth state)
    await FirebaseAuth.instance.signOut();

    // Navigate to welcome page (route guard will handle protection)
    if (mounted) {
      context.go('/welcome');
    }

    print('👋 User logged out successfully');
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state to show current login status
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final user = ref.watch(
      currentUserProvider,
    ); // Get the current user (may be null)
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Home"),
            // Login status indicator
            Container(
              padding: const EdgeInsets.all(SDeckSpace.paddingM),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLoggedIn ? Icons.check_circle : Icons.cancel,
                        color: isLoggedIn ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: SDeckSpace.gapXS),
                      Text(
                        isLoggedIn ? 'Logged In' : 'Not Logged In',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: context.component.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  // Show the user's email if logged in
                  if (isLoggedIn && user != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? '',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: context.component.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    SDeckSolidButton.large(
                      text: 'Test ProfileCard',
                      onPressed: () => context.push('/test/profile-card'),
                    ),
                    SizedBox(height: SDeckSpace.gapM),
                    SDeckSolidButton.large(
                      text: 'Logout',
                      onPressed: _handleLogout,
                    ),
                    SizedBox(height: SDeckSpace.gapM),
                    SDeckSolidButton.large(
                      text: 'Clear Google Cache',
                      onPressed: () async {
                        final googleService = ref.read(
                          googleAuthServiceProvider,
                        );
                        await googleService.signOutFromGoogle();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Signed out from Google. You can now choose different accounts.',
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: SDeckSpace.gapM),
                    SDeckSolidButton.large(
                      text: 'Test Login Flow',
                      onPressed: () => context.push('/welcome'),
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
