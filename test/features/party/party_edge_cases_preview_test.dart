import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'support/party_edge_case_fixtures.dart';

void main() {
  for (final scenario in PartyEdgeCase.values) {
    testWidgets('local regression fixture ${scenario.name} renders without Firebase', (tester) async {
      await tester.pumpWidget(ProviderScope(child: MaterialApp(theme: SDeckAppTheme.light,
        home: PartyEdgePreview(scenario: scenario))));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(scenario.title), findsOneWidget);
      if ([PartyEdgeCase.noFriends, PartyEdgeCase.friendsLoading, PartyEdgeCase.friendsError,
          PartyEdgeCase.alreadyJoined, PartyEdgeCase.partialInvite, PartyEdgeCase.inviteError].contains(scenario)) {
        await tester.tap(find.byKey(const ValueKey('party-invite')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump();
        if (scenario == PartyEdgeCase.noFriends) {
          expect(find.text('No friends available. Share your party code to invite players.'), findsOneWidget);
        }
        if (scenario == PartyEdgeCase.friendsError) expect(find.text('Retry friends'), findsOneWidget);
        if (scenario == PartyEdgeCase.alreadyJoined || scenario == PartyEdgeCase.inviteError) {
          final name = scenario == PartyEdgeCase.alreadyJoined ? 'Guest' : 'Alex';
          await tester.tap(find.text(name).last);
          await tester.pump();
          await tester.tap(find.text('Invite $name'));
          await tester.pumpAndSettle();
          expect(find.text('Invite Error'), findsOneWidget);
        }
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
