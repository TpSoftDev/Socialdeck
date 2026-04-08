/*-------------------- profile_redirecting.dart -----------------------*/
// Redirecting screen for the profile / sign-up flow
//
// Purpose:
// - Shows the lightweight redirecting/loading UI
// - Hosts the project's EXISTING SDeckToast component
// - Keeps toast hidden until logic explicitly triggers it
//
// Notes:
// - Frontend prepares the toast surface here
// - Backend logic can later decide when to show it
// - This file does NOT create a new toast system
/*---------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/components/toast/sdeck_toast.dart';
import 'package:socialdeck/design_system/components/toast/toast_enums.dart';
import 'package:socialdeck/design_system/index.dart';

//---------------------- ProfileRedirectingPage ------------------//
class ProfileRedirectingPage extends ConsumerStatefulWidget {
  const ProfileRedirectingPage({super.key});

  @override
  ConsumerState<ProfileRedirectingPage> createState() =>
      _ProfileRedirectingPageState();
}

class _ProfileRedirectingPageState
    extends ConsumerState<ProfileRedirectingPage> {
  //*************************** Toast State *******************************//
  // Page-level state for the EXISTING project toast.
  //
  // The toast remains hidden until some logic calls _showPageToast(...).
  bool _showToast = false;
  SDeckToastStatus _toastStatus = SDeckToastStatus.info;
  String _toastTitle = '';
  String _toastDescription = '';

  @override
  void initState() {
    super.initState();

    // -------------------------------------------------------------------
    // FRONTEND-ONLY NOTE:
    // Keep toast hidden by default.
    //
    // For temporary manual testing, you can uncomment this:
    //
    // Future.delayed(const Duration(seconds: 1), () {
    //   if (!mounted) return;
    //   _showPageToast(
    //     status: SDeckToastStatus.info,
    //     title: 'Redirecting',
    //     description: 'Please wait while we prepare your profile.',
    //   );
    // });
    // -------------------------------------------------------------------
  }

  //*************************** Toast Helpers *****************************//
  /// Shows the project's existing SDeckToast on this page.
  ///
  /// Backend logic can eventually trigger this same method.
  void _showPageToast({
    required SDeckToastStatus status,
    required String title,
    required String description,
  }) {
    if (!mounted) return;

    setState(() {
      _toastStatus = status;
      _toastTitle = title;
      _toastDescription = description;
      _showToast = true;
    });
  }

  /// Dismisses the currently visible toast.
  void _dismissToast() {
    if (!mounted) return;

    setState(() {
      _showToast = false;
    });
  }

  //*************************** Build Method ******************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Stack(
          children: [
            //---------------------- Main Redirecting UI -------------------//
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //-------------------- Top Visual Area --------------------//
                SizedBox(
                  height: 402,
                  child: Center(
                    // Clip the image so corners match the rounded Figma spec.
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        SDeckRadius.borderRadius16,
                      ),
                      child: Image.asset(
                        SDeckIcon.checkeredBackground,
                        height: 64,
                        width: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //---------------------- Toast Overlay ------------------------//
            // Uses the EXISTING project toast.
            //
            // Positioned at the top center so it behaves like a page-level toast.
            // IgnorePointer prevents hidden toast area from blocking touches.
            IgnorePointer(
              ignoring: !_showToast,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: SDeckSpace.padding16,
                    left: SDeckSpace.padding16,
                    right: SDeckSpace.padding16,
                  ),
                  child: SDeckFadeSwap(
                    visible: _showToast,
                    child: SDeckToast(
                      status: _toastStatus,
                      title: _toastTitle,
                      description: _toastDescription,
                      onDismiss: _dismissToast,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Title/loading helpers removed – visual is now a centered deck icon.
}