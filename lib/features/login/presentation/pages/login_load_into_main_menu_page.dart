/*------------------ login_load_into_main_menu_page.dart --------------------*/
// Post-login hold: keeps the profile-card [Hero] slot visible while navigating
// home. Uses the same square card and horizontal inset as [LoginPasswordPage].
//
// The slot always shows [SDeckVisualPlaceholder] (checkered) so the area is
// never empty; an optional network photo stacks on top when available.
// Phase 2: replace the placeholder with Rive and animate to the top bar.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';

const double _topBarReservedHeight = 76;

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

  /// Same layering as [LoginConfirmProfilePage]: checkered base always visible;
  /// profile photo paints on top when a URL exists (Phase 2 may drop photo here).
  Widget _buildCardVisual(double size, String? photoUrl) {
    final trimmed = photoUrl?.trim();
    final hasUrl = trimmed != null && trimmed.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        SDeckVisualPlaceholder(
          width: size,
          height: size,
          borderRadius: BorderRadius.circular(SDeckRadius.borderRadius16),
        ),
        if (hasUrl)
          Image.network(
            trimmed,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
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
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final validationState = ref.watch(loginValidationProvider);
    final photoUrl = validationState.userProfileData?['photoUrl'] as String?;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SDeckSpace.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: _topBarReservedHeight),
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
                        child: _buildCardVisual(size, photoUrl),
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
