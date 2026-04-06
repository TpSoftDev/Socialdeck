/*-------------------- profile_redirecting.dart -----------------------*/
// Redirecting screen for the profile / sign-up flow
// Minimal UI that shows logo, "Redirecting..." title, and loading spinner
// Matches onboarding layout with surface background
/*---------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------ Top Navigation ------------------------//
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
      ),
    );
  }

  // Title/loading helpers removed – visual is now a centered deck icon.
}