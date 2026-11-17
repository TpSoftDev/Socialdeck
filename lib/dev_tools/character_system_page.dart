/*----------------------- character_system_page.dart ------------------------*/
// Dev gallery for character poses. Wave Pose is the first one.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/profile/domain/profile_data_state.dart';
import 'package:socialdeck/features/profile/providers/profile_data_provider.dart';

//------------------------------- CharacterSystemPage ----------------------//
class CharacterSystemPage extends StatelessWidget {
  const CharacterSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SDeckTopNavigationBar(
              left: SDeckTopBarLeft.back,
              type: SDeckTopBarType.page,
              right: SDeckTopBarRight.none,
              title: 'Character System',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wave Pose',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    const _PosePlate(child: SDeckWavePose()),
                    const SizedBox(height: 32),
                    const _SignedInWavePose(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------- Signed-in photo --------------------------//
class _SignedInWavePose extends ConsumerWidget {
  const _SignedInWavePose();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileDataProvider);

    return profile.when(
      loading: () => const _PosePlate(child: SDeckWavePose()),
      error: (_, _) => const _PosePlate(child: SDeckWavePose()),
      data: (data) {
        final url = data.photoUrl?.trim();
        final hasPhoto = url != null && url.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasPhoto ? 'Wave Pose — ${data.username}' : 'Wave Pose with an image',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _PosePlate(
              child: SDeckWavePose(
                image: hasPhoto ? _ProfileFace(profile: data, url: url) : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

//------------------------------- Profile face -----------------------------//
class _ProfileFace extends StatelessWidget {
  final ProfileDataState profile;
  final String url;

  const _ProfileFace({required this.profile, required this.url});

  // Saved pan is in the adjustment-card image area (160 x 256).
  // The pose face is 46.154 x 64.616, so the pan is scaled down with it.
  static const double _widthRatio = 46.154 / 160;
  static const double _heightRatio = 64.616 / 256;

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix4.identity()..scale(profile.scale);
    matrix.setTranslationRaw(
      profile.panX * _widthRatio,
      profile.panY * _heightRatio,
      0,
    );

    return SizedBox.expand(
      child: Transform(
        alignment: Alignment.center,
        transform: matrix,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

//------------------------------- Preview plate ----------------------------//
class _PosePlate extends StatelessWidget {
  final Widget child;

  const _PosePlate({required this.child});

  // Figma's frame is about 100px. Three times that is large enough to judge.
  static const double _scale = 3;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: SDeckBrandColors.warmOffWhite(Brightness.light),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SizedBox(
            width: SDeckWavePose.width * _scale,
            height: SDeckWavePose.height * _scale,
            child: FittedBox(child: child),
          ),
        ),
      ),
    );
  }
}
