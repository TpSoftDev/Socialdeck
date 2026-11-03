import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/party/party.dart';
import '../party/party_late_state_test.dart' as harness;

void main() {
  // IA: Our boundary is navigation only; no selection or Firebase hand writes.
  testWidgets('Pick 7 Cards hands off to Decks without saving a hand', (
    tester,
  ) async {
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    final repo = harness.LateStateRepository();
    await harness.mount(tester, repo, updates);
    tester
        .widget<InviteSheetPage>(find.byType(InviteSheetPage))
        .live!
        .onCards!();
    await tester.pumpAndSettle();
    expect(find.text('Teammate Decks route'), findsOneWidget);
    expect(find.text('Free-to-Choose'), findsNothing);
    expect(repo.hands, isEmpty);
    Navigator.of(tester.element(find.text('Teammate Decks route'))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(InviteSheetPage), findsOneWidget);
    expect(repo.hands, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
