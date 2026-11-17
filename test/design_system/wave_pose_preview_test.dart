import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/components/characters/sdeck_wave_pose.dart';
import 'package:socialdeck/design_system/themes/sdeck_app_theme.dart';

void main() {
  testWidgets('Wave Pose paints', (tester) async {
    tester.view.physicalSize = const Size(900, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: SDeckAppTheme.light,
        home: const Scaffold(
          backgroundColor: Color(0xFFFDFBF5),
          body: Center(
            child: SizedBox(
              width: SDeckWavePose.width * 4,
              height: SDeckWavePose.height * 4,
              child: FittedBox(child: SDeckWavePose()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/wave_pose.png'),
    );
  });

  testWidgets('arm svg paints', (tester) async {
    tester.view.physicalSize = const Size(400, 440);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Color(0xFFFDFBF5),
          body: Center(
            child: SvgPicture.asset(
              'assets/characters/wave_pose/arm_pose_2.svg',
              width: 246,
              height: 252,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/arm_pose_2.png'),
    );
  });
}
