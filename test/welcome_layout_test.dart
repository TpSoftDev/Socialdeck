import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/welcome/presentation/pages/welcome_page.dart';
void main() {
  for (final height in [560.0, 900.0]) {
    testWidgets('Welcome fits or scrolls at height $height', (tester) async {
      tester.view.physicalSize = Size(320, height);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ProviderScope(child: MaterialApp(theme: SDeckAppTheme.light, home: const WelcomePage())));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Log In'));
      await tester.pumpAndSettle();
      expect(find.text('Log In').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}