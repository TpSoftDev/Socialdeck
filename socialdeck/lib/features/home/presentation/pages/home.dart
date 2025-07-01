import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/providers/auth_state_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  /// Called when user wants to log out
  void _handleLogout() {
    // Set auth state to logged out
    ref.read(authStateProvider.notifier).logout();

    // Navigate to welcome page (route guard will handle protection)
    context.go('/welcome');

    print('👋 User logged out successfully');
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state to show current login status
    final isLoggedIn = ref.watch(authStateProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Home"),
            // Login status indicator
            Container(
              padding: const EdgeInsets.all(SDeckSpacing.x16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLoggedIn ? Icons.check_circle : Icons.cancel,
                    color: isLoggedIn ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: SDeckSpacing.x8),
                  Text(
                    isLoggedIn ? 'Logged In' : 'Not Logged In',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
                    SizedBox(height: SDeckSpacing.x16),
                    SDeckSolidButton.large(
                      text: 'Logout',
                      onPressed: _handleLogout,
                    ),
                    SizedBox(height: SDeckSpacing.x16),
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

      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: SDeckBottomNavBar.defaultItems,
      ),
    );
  }
}
