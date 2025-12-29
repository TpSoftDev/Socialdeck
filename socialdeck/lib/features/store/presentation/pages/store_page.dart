/*-------------------- store_page.dart -----------------------*/
// Store Page for the main app
// Displays a placeholder "Coming Soon!" message
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- StorePage -----------------------------//
class StorePage extends ConsumerStatefulWidget {
  const StorePage({super.key});

  @override
  ConsumerState<StorePage> createState() => _StorePageState();
}

class _StorePageState extends ConsumerState<StorePage> {
  //*************************** State Variables ******************************//
  int _currentIndex = 3; // Store tab is index 3

  //*************************** Build Method **********************************//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //------------------------ Top Navigation ------------------------//
            SDeckTopNavigationBar.logoWithTitle(title: "Store"),

            //------------------------ Main Content Area ---------------------//
            Expanded(
              child: Center(
                child: Text(
                  "Coming Soon!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
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
