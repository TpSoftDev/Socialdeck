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

class SlowInvites extends fixtures.UiRepository {
  final completion = Completer<void>();
  @override
  Future<void> invitePlayer(String id, String uid) async {
    invitations.add(uid);
    await completion.future;
  }
}

void main() {
  testWidgets('repeated invite callbacks send each recipient once', (
    tester,
  ) async {
    final repo = SlowInvites();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          partyRepositoryProvider.overrideWithValue(repo),
          partyFriendsProvider.overrideWith(
            (ref) => Stream.value([
              const PartyFriend(uid: 'friend', name: 'Friend'),
            ]),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: PartyInviteSheet(partyId: '123456')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    final submit =
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed!;
    submit();
    submit();
    await tester.pump();
    expect(repo.invitations, ['friend']);
    repo.completion.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('ready roster fits narrow screen with larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final party = fixtures.lobby(selected: true);
    final readyParty = party.copyWith(
      members: {
        ...party.members,
        'host': party.members['host']!.withSelection(
          7,
          party.revision,
          ready: true,
        ),
      },
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWithValue(TestUser('host')),
          partyRepositoryProvider.overrideWithValue(fixtures.UiRepository()),
          partyByIdProvider(
            '123456',
          ).overrideWith((ref) => Stream.value(readyParty)),
          partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
          partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: SDeckAppTheme.light,
          builder:
              (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.3)),
                child: child!,
              ),
          home: const PartyLobbyPage(partyId: '123456'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Framework checks layout errors.
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();
    expect(find.byType(SDeckPartyLeavingBottomSheet), findsOneWidget);
    await tester.tap(find.text('Leave Party'));
    await tester.pumpAndSettle();
    expect(find.text('Wait!'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(PartyLobbyPage), findsOneWidget);
    // Framework checks layout errors.
  });
  testWidgets('closing invite sheet stops unsent recipients', (tester) async {
    final repo = SlowInvites();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          partyRepositoryProvider.overrideWithValue(repo),
          partyFriendsProvider.overrideWith(
            (ref) => Stream.value([
              const PartyFriend(uid: 'one', name: 'One'),
              const PartyFriend(uid: 'two', name: 'Two'),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: PartyInviteSheet(partyId: '123456')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('One'));
    await tester.tap(find.text('Two'));
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(repo.invitations, ['one']);
    await tester.pumpWidget(const SizedBox.shrink());
    repo.completion.complete();
    await tester.pumpAndSettle();
    expect(repo.invitations, ['one']);
    // Framework checks layout errors.
  });
}
