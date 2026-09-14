/*-------------------- home_dev_tools_page.dart -----------------------*/
// Nested Dev Tools page for home/auth test routes.
// Opened from Dev Tools via the "Home Dev" button.
/*--------------------------------------------------------------------------*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/home/presentation/pages/home.dart';
import 'package:socialdeck/features/onboarding/shared/services/google_auth_service.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

//------------------------------- HomeDevToolsPage -----------------------------//
class HomeDevToolsPage extends ConsumerStatefulWidget {
  const HomeDevToolsPage({super.key});

  @override
  ConsumerState<HomeDevToolsPage> createState() => _HomeDevToolsPageState();
}

class _HomeDevToolsPageState extends ConsumerState<HomeDevToolsPage> {
  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      context.go('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.none,
              title: 'Home Dev',
            ),
            Container(
              padding: const EdgeInsets.all(SDeckSpace.padding16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLoggedIn ? Icons.check_circle : Icons.cancel,
                        color: isLoggedIn ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: SDeckSpace.gap8),
                      Text(
                        isLoggedIn ? 'Logged In' : 'Not Logged In',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: context.component.textPrimary,
                        ),
                      ),
                    ],
                  ),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SDeckSolidButton(
                      text: 'Home Return',
                      size: SDeckButtonSize.medium,
                      onPressed: () => context.go(
                        AppPaths.home,
                        extra: const HomeRouteArgs(showReturnToGame: true),
                      ),
                    ),
                   
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Logout',
                      size: SDeckButtonSize.medium,
                      onPressed: _handleLogout,
                    ),
                    const SizedBox(height: 16),
                    SDeckSolidButton(
                      text: 'Clear Google Cache',
                      size: SDeckButtonSize.medium,
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
