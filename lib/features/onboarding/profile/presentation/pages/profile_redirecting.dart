/*-------------------- profile_redirecting.dart -----------------------*/
// Redirecting screen shown between sign-up and the profile creation flow.
// Displays a loading indicator while the app prepares the profile route.
// Navigates to introduce-card exactly once when the provider signals readiness.
//
// TODO: Replace the placeholder visual with the Rive spinLoader animation
//       once the .riv asset is available.
/*---------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/providers/profile_redirecting_provider.dart';

//---------------------- ProfileRedirectingPage ------------------//
class ProfileRedirectingPage extends ConsumerStatefulWidget {
  const ProfileRedirectingPage({super.key});

  @override
  ConsumerState<ProfileRedirectingPage> createState() =>
      _ProfileRedirectingPageState();
}

class _ProfileRedirectingPageState
    extends ConsumerState<ProfileRedirectingPage> {

  @override
  void initState() {
    super.initState();
    ref.read(profileRedirectingProvider.notifier).reset();
    Timer(const Duration(seconds: 3), () {
      ref.read(profileRedirectingProvider.notifier).toNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Navigate exactly once when moveNext becomes true — not on every rebuild
    ref.listen(profileRedirectingProvider, (previous, next) {
      if (next.moveNext) {
        context.push('/profile/introduce-card');
      }
    });

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: SizedBox(
          height: 402,
          width: double.infinity,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
              child: Image.asset(
                SDeckIcon.checkeredBackground,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}