import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

class LoginConfirmProfilePage extends StatelessWidget {
  const LoginConfirmProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SDeckTopNavigationBar.backWithTitleOnly(
              title: "Log In",
              onBackPressed: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
              child: Column(
                children: [
                  const SizedBox(height: SDeckSpace.gap16),
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
                          image: const DecorationImage(
                            image: AssetImage(SDeckIcon.checkeredBackground),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: SDeckSpace.gap16),
                  Text(
                    "eth6nhunt",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.h6.copyWith(
                      color: context.component.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SDeckSpace.gap8),
                  Text(
                    "Is this your profile card?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: context.component.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SDeckSpace.gap16),
                  SDeckSolidButton(
                    text: "That's me!",
                    size: SDeckButtonSize.large,
                    shape: SDeckButtonShape.default_,
                    fullWidth: true,
                    onPressed: () => context.push(AppPaths.loginPassword),
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
