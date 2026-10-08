import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
void main() {
  for (final scale in [1.0, 1.5]) {
    testWidgets('Social labels fit at text scale $scale', (tester) async {
      await tester.pumpWidget(MaterialApp(theme: SDeckAppTheme.light, home: Scaffold(body: MediaQuery(data: MediaQueryData(textScaler: TextScaler.linear(scale)), child: Center(child: SizedBox(width: 288, child: Column(mainAxisSize: MainAxisSize.min, children: [for (final provider in ['Google','Apple']) SDeckOutlineButton(text: 'Continue with $provider', size: SDeckButtonSize.large, fullWidth: true, icon: const Icon(Icons.login), iconLocation: SDeckButtonIconLocation.left)])))))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Continue with Google').hitTestable(), findsOneWidget);
      expect(find.text('Continue with Apple').hitTestable(), findsOneWidget);
    });
  }
}