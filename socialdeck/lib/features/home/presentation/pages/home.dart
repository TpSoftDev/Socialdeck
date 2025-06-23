import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.logoWithTitle(title: "Home"),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    SDeckSolidButton.large(
                      text: 'Test ProfileCard',
                      onPressed: () => context.push('/test/profile-card'),
                    ),
                    SizedBox(height: SDeckSpacing.x16),
                    SDeckSolidButton.large(
                      text: 'Test Login Flow',
                      onPressed: () => context.push('/welcome'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SDeckBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: SDeckBottomNavBar.defaultItems,
      ),
    );
  }
}
