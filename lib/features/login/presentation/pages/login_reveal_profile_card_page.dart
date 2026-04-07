import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
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
                      final radius = BorderRadius.circular(
                        SDeckRadius.borderRadius16,
                      );
                      return InkWell(
                        onTap: () => context.push(AppPaths.loginConfirmProfile),
                        borderRadius: radius,
                        child: Ink(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            borderRadius: radius,
                            image: const DecorationImage(
                              image: AssetImage(SDeckIcon.checkeredBackground),
                              fit: BoxFit.cover,
                            ),
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
