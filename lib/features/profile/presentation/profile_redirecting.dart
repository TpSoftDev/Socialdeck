/*-------------------- profile_redirecting.dart -----------------------*/
// Redirecting screen for the profile / sign-up flow
// Minimal UI that shows logo, "Redirecting..." title, and loading spinner
// Matches onboarding layout with surface background
/*---------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                child: SvgPicture.asset(
                  'assets/icons/stroke/Cards.svg',
                  height: 64,
                  width: 64,
                  colorFilter: ColorFilter.mode(
                    context.semantic.tertiary,
                    BlendMode.srcIn,
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