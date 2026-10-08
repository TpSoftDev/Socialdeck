import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/presentation/pages/default_party_page.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';

void main() {
  testWidgets('normal mode keeps options and omits custom style chips', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: SDeckAppTheme.light, home: const DefaultPartyPage()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Coworkers'), findsNothing);
    expect(find.text('Select Game'), findsNothing);
    expect(
      tester
          .widget<SDeckSolidButton>(
            find.widgetWithText(SDeckSolidButton, 'Ready'),
          )
          .enabled,
      isFalse,
    );
    final nav = tester.widget<SDeckTopNavigationBar>(
      find.byType(SDeckTopNavigationBar),
    );
    nav.onRightPressed!();
    await tester.pumpAndSettle();
    expect(find.text('Your Options'), findsOneWidget);
    expect(find.text('Change Name'), findsOneWidget);
    await tester.tap(find.text('Change Name'));
    await tester.pumpAndSettle();
    expect(find.byType(SDeckInputDialog), findsOneWidget);
  });
  testWidgets('default host and waiting player states survive merge', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: SDeckAppTheme.light, home: const InviteSheetPage()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Select Game'), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        theme: SDeckAppTheme.light,
        home: const InviteSheetPage(
          key: ValueKey('player'),
          role: PartyLobbyRole.player,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Select Game'), findsNothing);
    expect(find.textContaining('ethan', findRichText: true), findsWidgets);
  });
}
