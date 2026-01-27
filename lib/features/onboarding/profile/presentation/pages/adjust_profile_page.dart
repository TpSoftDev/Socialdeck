/*-------------------- adjust_profile_page.dart -----------------------*/
// Adjust Profile Page for onboarding flow
// Screen 4: User adjusts their selected photo with scale/move/rotate
// Shows photo in adjustment card with "Looks Perfect!" and "Change Picture" buttons
//
// User Journey: Photo selected → User adjusts → "Looks Perfect!" or "Change Picture"
/*--------------------------------------------------------------------------*/

//
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/shared/templates/onboarding_profile_card_template.dart';
import 'package:socialdeck/features/onboarding/shared/utils/photo_picker_helper.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/services/profile_photo_picker_service.dart';
import '../../providers/profile_form_provider.dart';
import 'package:socialdeck/features/onboarding/shared/providers/onboarding_submission_provider.dart';
import 'package:socialdeck/features/onboarding/shared/providers/onboarding_status_provider.dart';

class AdjustProfilePage extends ConsumerStatefulWidget {
  const AdjustProfilePage({super.key});

  @override
  ConsumerState<AdjustProfilePage> createState() => _AdjustProfilePageState();
}

class _AdjustProfilePageState extends ConsumerState<AdjustProfilePage> {
  //*************************** State Variables ******************************//
  final _photoService = ProfilePhotoPickerService();
  bool _showOverlay = true;
  final GlobalKey _adjustCardKey = GlobalKey();

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    // Read image path from provider (not from navigation)
    final imagePath = ref.watch(profileFormProvider).imagePath;
    // Watch submission state
    final submissionState = ref.watch(onboardingSubmissionProvider);
    final isLoading =
        submissionState.status == OnboardingSubmissionStatus.loading;

    return OnboardingProfileCardTemplate(
      title: "Adjust Photo",
      profileCard: SDeckAdjustProfileCard(
        key: _adjustCardKey,
        imagePath: imagePath,
        showOverlay: _showOverlay,
        hideOverlay: _hideOverlay,
        onTransformChanged: _onTransformChanged,
      ),
      bottomActions: [
        SDeckSolidButton(
          text: "Confirm",
          size: SDeckButtonSize.large,
          fullWidth: true,
          enabled: !isLoading, // Disable while loading
          onPressed: isLoading ? null : _handleConfirm, // Prevent double submit
        ),
        SDeckOutlineButton(
          text: "Change Picture",
          size: SDeckButtonSize.large,
          fullWidth: true,
          onPressed: _handleChangePicture,
        ),
      ],
    );
  }

  //*************************** Overlay Handler *******************************//
  void _hideOverlay() {
    setState(() {
      _showOverlay = false;
    });
  }

  //*************************** Transform Change Handler **********************//
  void _onTransformChanged(double scale, double panX, double panY) {
    // Update provider with transform data
    ref.read(profileFormProvider.notifier).setTransform(scale, panX, panY);
    print(
      'Transform updated: scale= [32m$scale [0m, panX= [32m$panX [0m, panY= [32m$panY [0m',
    );
  }

  //*************************** Confirm Handler *******************************//
  /// Handles the final onboarding submission when user taps Confirm.
  Future<void> _handleConfirm() async {
    // 1. Capture the latest transform from the widget before submitting
    final adjustCardState = _adjustCardKey.currentState as dynamic;
    adjustCardState?.captureCurrentAdjustments();

    // 2. Submit onboarding data to Firestore (this already waits for completion)
    final notifier = ref.read(onboardingSubmissionProvider.notifier);
    final success = await notifier.submit();
    if (success) {
      // 3. Firestore write is already complete! Invalidate provider cache to force fresh read
      print('Onboarding submission successful, Firestore write completed');
      ref.invalidate(onboardingCompleteProvider);

      // 4. Reload user to get latest verification status
      final user = FirebaseAuth.instance.currentUser;
      print('Checking verification status for user: ${user?.email}');
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      print('Reloaded user. Email verified: ${refreshedUser?.emailVerified}');

      if (refreshedUser != null && refreshedUser.emailVerified) {
        // User is verified and onboarding is complete, go to home
        print('User verified and onboarding complete, navigating to home');
        if (mounted) {
          context.go(
            '/home',
          ); // Use go() instead of push() to clear navigation stack
        }
      } else {
        // User is not verified, send them to redirecting page to verify
        print('User not verified, navigating to redirecting page');
        if (mounted) {
          context.push('/sign-up/redirecting');
        }
      }
    } else {
      // Show error message if submission failed
      final error =
          ref.read(onboardingSubmissionProvider).errorMessage ??
          'Submission failed.';
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  //*************************** Change Picture Handler ************************//
  void _handleChangePicture() {
    PhotoPickerHelper.showPhotoPicker(
      context: context,
      title: "Change Picture",
      onCameraPressed: _handleCameraSelection,
      onGalleryPressed: _handleGallerySelection,
    );
  }

  Future<void> _handleCameraSelection() async {
    Navigator.pop(context); // Close modal first
    final photo = await _photoService.pickFromCamera();
    if (photo != null) {
      // Update provider with new image path
      ref.read(profileFormProvider.notifier).setImagePath(photo.path);
      // Optionally, reset transform data if needed
      setState(() {
        _showOverlay = true;
      });
    } else {
      print('❌ Camera photo selection failed');
    }
  }

  Future<void> _handleGallerySelection() async {
    Navigator.pop(context); // Close modal first
    final photo = await _photoService.pickFromGallery();
    if (photo != null) {
      // Update provider with new image path
      ref.read(profileFormProvider.notifier).setImagePath(photo.path);
      // Optionally, reset transform data if needed
      setState(() {
        _showOverlay = true;
      });
    } else {
      print('❌ Gallery photo selection failed');
    }
  }
}
