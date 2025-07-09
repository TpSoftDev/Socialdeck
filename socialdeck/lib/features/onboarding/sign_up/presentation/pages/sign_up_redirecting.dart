import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_info_template.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/components/navigation/sdeck_top_navigation_bar.dart';

class SignUpRedirectingPage extends ConsumerStatefulWidget {
  const SignUpRedirectingPage({super.key});

  @override
  ConsumerState<SignUpRedirectingPage> createState() =>
      _SignUpRedirectingPageState();
}

class _SignUpRedirectingPageState extends ConsumerState<SignUpRedirectingPage> {
  //*************************** Timer for Polling ***************************//
  Timer? _pollingTimer;
  bool _isChecking = false;
  String? _errorMessage;

  // Add a new state variable to track if we're resending
  bool _isResending = false;

  //------------------------------- initState ------------------------------//
  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  //------------------------------- _startPolling ----------------------------//
  void _startPolling() {
    // Start polling every 3 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkVerificationStatus();
    });
    // Also check immediately on load
    _checkVerificationStatus();
  }

  //------------------------------- _checkVerificationStatus ----------------//
  Future<void> _checkVerificationStatus() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });
    try {
      // Reload the Firebase user to get the latest info
      final user = FirebaseAuth.instance.currentUser;
      print('Checking verification for user: ${user?.email}');
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      print('Reloaded user. Email verified: ${refreshedUser?.emailVerified}');
      if (refreshedUser != null && refreshedUser.emailVerified) {
        print('User is verified! Navigating to next step.');
        _pollingTimer?.cancel();
        if (mounted) {
          context.go('/profile/username');
        }
      } else {
        print('User is NOT verified yet.');
      }
    } catch (e, stack) {
      print('Error during verification check: $e\n$stack');
      setState(() {
        _errorMessage =
            "Could not check verification status. Please try again.";
      });
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  //------------------------------- _resendVerificationEmail ----------------//
  // This function will be called when the user presses "Resend Email"
  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Attempting to resend verification email to: ${user?.email}');
      await user?.sendEmailVerification();
      print('Verification email sent!');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Verification email sent!')));
      }
    } catch (e, stack) {
      print('Error resending verification email: $e\n$stack');
      setState(() {
        _errorMessage =
            "Could not resend verification email. Please try again.";
      });
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  //------------------------------- dispose ------------------------------//
  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  //------------------------------- build ------------------------------//
  @override
  Widget build(BuildContext context) {
    return OnboardingInfoTemplate(
      navigationBar: SDeckTopNavigationBar.logoWithoutBack(),
      title: "Redirecting...",
      bodyText:
          "We're waiting for you to verify your email. Please check your inbox and click the link.",
      showLoadingIndicator: _isChecking || _isResending,
      primaryButtonText: "Check Again",
      onPrimaryPressed: _checkVerificationStatus,
      secondaryActionText: "Resend Email",
      onSecondaryPressed:
          _isResending
              ? null
              : _resendVerificationEmail, // Disable while resending
      // Optionally, show error messages (could use a SnackBar or add to bodyText)
    );
  }
}
