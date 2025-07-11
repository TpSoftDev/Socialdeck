import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

/// SplashPage: Checks authentication state and routes user accordingly.
/// - Shows a loading spinner while checking.
/// - Navigates to /home if logged in, /welcome if not.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth state (User? or loading/error)
    final authState = ref.watch(authStateProvider);

    // Show a loading spinner while checking auth state
    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Use addPostFrameCallback to navigate after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // If user is logged in, go to home
      if (authState.value != null) {
        context.go('/home');
      } else {
        // If not logged in, go to welcome
        context.go('/welcome');
      }
    });

    // Return an empty container while redirecting
    return const Scaffold(body: SizedBox.shrink());
  }
}
