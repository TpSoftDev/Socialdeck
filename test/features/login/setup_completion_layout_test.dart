import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/onboarding/profile/presentation/pages/invite_friends_page.dart';
void main() {
  for (final height in [560.0, 900.0]) {
    testWidgets('Final setup fits or scrolls at height $height', (tester) async {
      tester.view.physicalSize = Size(320, height);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ProviderScope(child: MaterialApp(theme: SDeckAppTheme.light, home: const InviteFriendsPage())));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Get Started'));
      await tester.pumpAndSettle();
      expect(find.text('Get Started').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}