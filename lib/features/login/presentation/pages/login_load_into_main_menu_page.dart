import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';

const double _TopBarReservedHeight = 76;

class LoginLoadIntoMainMenuPage extends ConsumerStatefulWidget {
  const LoginLoadIntoMainMenuPage({super.key});

  @override
  ConsumerState<LoginLoadIntoMainMenuPage> createState() =>
      _LoginLoadIntoMainMenuPageState();
}

class _LoginLoadIntoMainMenuPageState
    extends ConsumerState<LoginLoadIntoMainMenuPage> {
  static const String _profileCardHeroTag = 'login_profile_card_hero';
  static const Duration _loadHoldDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    Future.delayed(_loadHoldDuration, () {
      if (!mounted) return;
      context.go(AppPaths.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final validationState = ref.watch(loginValidationProvider);
    final photoUrl = validationState.userProfileData?['photoUrl'] as String?;
    final hasPhotoUrl = photoUrl != null && photoUrl.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: Column(
            children: [
              const SizedBox(height: _TopBarReservedHeight),
              SizedBox(height: SDeckSpace.gap16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.maxWidth;
                  return Hero(
                    tag: _profileCardHeroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        SDeckRadius.borderRadius16,
                      ),
                      child: SizedBox(
                        width: size,
                        height: size,
                        child: hasPhotoUrl
                            ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                                frameBuilder: (
                                  context,
                                  child,
                                  frame,
                                  wasSynchronouslyLoaded,
                                ) {
                                  if (wasSynchronouslyLoaded) return child;
                                  return AnimatedOpacity(
                                    opacity: frame == null ? 0 : 1,
                                    duration: SDeckMotion.fade,
                                    curve: Curves.easeIn,
                                    child: child,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
