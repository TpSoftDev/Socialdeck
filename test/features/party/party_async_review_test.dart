import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

void main() {
  testWidgets('removed friends cannot remain hidden invite targets', (
    tester,
  ) async {
    final friends = StreamController<List<PartyFriend>>();
    addTearDown(friends.close);
    final repo = fixtures.UiRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          partyRepositoryProvider.overrideWithValue(repo),
          partyFriendsProvider.overrideWith((ref) => friends.stream),
        ],
        child: const MaterialApp(
          home: Scaffold(body: PartyInviteSheet(partyId: '123456')),
        ),
      ),
    );
    friends.add([const PartyFriend(uid: 'one', name: 'One')]);
    await tester.pumpAndSettle();
    await tester.tap(find.text('One'));
    await tester.pump();
    final oldCallback =
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed!;
    friends.add([]);
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    oldCallback();
    await tester.pumpAndSettle();
    expect(repo.invitations, isEmpty);
  });

  testWidgets('hand loading failure offers retry and keeps Ready disabled', (
    tester,
  ) async {
    var attempts = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(TestUser('host')),
          partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
          partyByIdProvider(
            '123456',
          ).overrideWith((ref) => Stream.value(fixtures.lobby(selected: true))),
          partyHandProvider('123456').overrideWith((ref) {
            attempts++;
            return attempts == 1
                ? Stream.error(const PartyFailure(PartyError.network))
                : Stream.value(
                  PartyHand(cards: fixtures.cards(7), revision: 0),
                );
          }),
          partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          home: const PartyLobbyPage(partyId: '123456'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Retry cards'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Ready'))
          .onPressed,
      isNull,
    );
    await tester.ensureVisible(find.text('Retry cards'));
    await tester.tap(find.text('Retry cards'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.text('Retry cards'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Ready'))
          .onPressed,
      isNotNull,
    );
  });
}
