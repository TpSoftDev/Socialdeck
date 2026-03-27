import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

class LoginRevealProfileCardPage extends StatelessWidget {
  const LoginRevealProfileCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar.backWithTitleOnly(
              title: "Log In",
              onBackPressed: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Column(
                children: [
                  SizedBox(height: SDeckSpace.gap16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.maxWidth;
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SDeckRadius.borderRadius16,
                          ),
                          image: DecorationImage(
                            image: AssetImage(SDeckIcon.checkeredBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
