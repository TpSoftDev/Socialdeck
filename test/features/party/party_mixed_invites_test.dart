import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/features/games/presentation/pages/party_lobby_binding.dart';
import 'party_wiring_test.dart' as fixtures;

class MixedRepository extends fixtures.UiRepository {
  MixedRepository(this.failure);
  final PartyError failure;
  bool fail = true;
  final calls = <String>[];
  @override Future<void> invitePlayer(String party, String uid) async {
    calls.add(uid);
    if (uid == 'sam' && fail) throw PartyFailure(failure);
  }
}
void main() {
  for (final failure in [PartyError.network, PartyError.alreadyInParty, PartyError.inviteAlreadySent]) {
    testWidgets('mixed invites identify success and $failure; retry excludes success', (tester) async {
      final repo = MixedRepository(failure);
      final batches = <List<PartyInviteNotice>>[];
      await tester.pumpWidget(ProviderScope(overrides: [
        partyRepositoryProvider.overrideWithValue(repo),
        partyFriendsProvider.overrideWith((ref) => Stream.value(const [
          PartyFriend(uid: 'alex', name: 'Alex'), PartyFriend(uid: 'sam', name: 'Sam'),
        ])),
      ], child: MaterialApp(theme: SDeckAppTheme.light, home: Scaffold(body: PartyInviteSheet(partyId: '123456', onComplete: batches.add)))));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alex')); await tester.pump();
      await tester.tap(find.text('Sam')); await tester.pump();
      await tester.tap(find.text('Invite 2 Friends'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['alex', 'sam']);
      expect(batches.single.map((n) => n.success), [false, true]);
      expect(batches.single.first.description, contains('Sam'));
      expect(batches.single.last.description, 'Sent to Alex. It will be in their Social inbox.');
      // Keeping the sheet mounted exercises selection cleanup before production
      // closes it. Only the failed recipient remains selected for a retry.
      expect(find.text('Invite Sam'), findsOneWidget);
      repo.fail = false;
      await tester.tap(find.text('Invite Sam'));
      await tester.pumpAndSettle();
      expect(repo.calls, ['alex', 'sam', 'sam']);
      expect(batches.last.single.success, isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
