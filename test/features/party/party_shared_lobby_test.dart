import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/party/party.dart';
import 'party_late_state_test.dart' as harness;
import 'party_wiring_test.dart' as fixtures;

void main() {
  testWidgets('production adapter renders team UI with live identity and no sample roster', (tester) async {
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    await harness.mount(tester, harness.LateStateRepository(), updates);
    final page = tester.widget<InviteSheetPage>(find.byType(InviteSheetPage));
    expect(page.live, isNotNull);
    expect(page.live!.code, '123456');
    expect(find.text('Party code: 123456'), findsNothing); // Code lives in the invite sheet.
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('ethan'), findsNothing);
    expect(find.text('thabang'), findsNothing);
    expect(page.live!.onCards, isNotNull);
    expect(page.live!.onReady, isNull);
    updates.add(fixtures.lobby().copyWith(hostId: 'guest'));
    await tester.pumpAndSettle();
    final changed = tester.widget<InviteSheetPage>(find.byType(InviteSheetPage)).live!;
    expect(changed.isHost, isFalse);
    expect(changed.onSettings, isNull);
    expect(changed.onStart, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets('same-name seats keep distinct IDs and the selected player permissions', (tester) async {
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    final party = fixtures.lobby().copyWith(members: {
      'host': const PartyMember(uid: 'host', name: 'Same'),
      'guest': const PartyMember(uid: 'guest', name: 'Same'),
    });
    await harness.mount(tester, harness.LateStateRepository(), updates, initial: party);
    final live = tester.widget<InviteSheetPage>(find.byType(InviteSheetPage)).live!;
    expect(live.seats.map((seat) => seat.id), ['host', 'guest']);
    await tester.tap(find.text('Same').at(1));
    await tester.pumpAndSettle();
    expect(find.text('Promote to Host'), findsOneWidget);
    expect(find.text('Kick'), findsOneWidget);
    updates.add(party.copyWith(hostId: 'guest'));
    await tester.pumpAndSettle();
    expect(find.text('Promote to Host'), findsNothing);
    expect(find.text('Kick'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
