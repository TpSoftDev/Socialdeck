/*-------------------- social_page.dart -----------------------*/
// Social Page for the main app
// Displays a placeholder "Coming Soon!" message
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/design_system/tokens/colors/index.dart';

//------------------------------- SocialPage -----------------------------//
/// SocialPage: Main page for the Social tab
/// Shows a top navigation bar and a placeholder message
class SocialPage extends ConsumerStatefulWidget {
  const SocialPage({super.key});

  @override
  ConsumerState<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends ConsumerState<SocialPage> {
  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.logoWithTitle(title: "Social"),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: Center(
                child: Text(
                  "Coming Soon!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: context.component.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
