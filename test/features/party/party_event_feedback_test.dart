import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

void main() {
  for (final type in ['promoted', 'kicked']) {
    testWidgets('live $type events use Dev toast and do not replay history', (tester) async {
      final events = StreamController<List<PartyEvent>>();
      addTearDown(events.close);
      await tester.pumpWidget(ProviderScope(overrides: [
        currentUserProvider.overrideWithValue(TestUser('host')),
        partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
        partyByIdProvider('123456').overrideWith((ref) => Stream.value(fixtures.lobby())),
        partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
        partyEventsProvider('123456').overrideWith((ref) => events.stream),
      ], child: MaterialApp(theme: SDeckAppTheme.light, home: const PartyLobbyPage(partyId: '123456'))));
      events.add([PartyEvent(id: 'old', type: type, name: 'Old')]);
      await tester.pumpAndSettle();
      expect(find.text(type == 'promoted' ? 'New Host' : 'Player Kicked'), findsNothing);
      events.add([PartyEvent(id: 'new', type: type, name: 'Alex'), PartyEvent(id: 'old', type: type, name: 'Old')]);
      await tester.pumpAndSettle();
      expect(find.text(type == 'promoted' ? 'New Host' : 'Player Kicked'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
