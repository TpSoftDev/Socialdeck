import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'party_wiring_test.dart' as fixtures;

class DelayedRepository extends fixtures.UiRepository {
  final pending = Completer<void>();
  final calls = <String>[];
  @override Future<void> invitePlayer(String party, String uid) async {
    calls.add(uid);
    if (uid == 'one') await pending.future;
  }
}
void main() {
  for (final fails in [false, true]) {
    testWidgets('closing invite sheet stops remaining sends during exit animation, failure=$fails', (tester) async {
      final repo = DelayedRepository();
      var completed = 0;
      final nav = GlobalKey<NavigatorState>();
      await tester.pumpWidget(ProviderScope(overrides: [
        partyRepositoryProvider.overrideWithValue(repo),
        partyFriendsProvider.overrideWith((ref) => Stream.value(const [
          PartyFriend(uid: 'one', name: 'One'), PartyFriend(uid: 'two', name: 'Two'),
        ])),
      ], child: MaterialApp(navigatorKey: nav, theme: SDeckAppTheme.light,
        home: Scaffold(body: Builder(builder: (context) => TextButton(
          onPressed: () => showModalBottomSheet<void>(context: context, isScrollControlled: true,
            builder: (_) => PartyInviteSheet(partyId: '123456', onComplete: (_) => completed++)),
          child: const Text('Open'),
        ))))));
      await tester.tap(find.text('Open')); await tester.pumpAndSettle();
      await tester.tap(find.text('One')); await tester.pump();
      await tester.tap(find.text('Two')); await tester.pump();
      final staleSend = tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton, 'Invite 2 Friends')).onPressed!;
      await tester.tap(find.text('Invite 2 Friends')); await tester.pump();
      expect(repo.calls, ['one']);
      nav.currentState!.pop();
      await tester.pump(); // Sheet is still mounted during its exit animation.
      if (fails) { repo.pending.completeError(const PartyFailure(PartyError.network)); }
      else { repo.pending.complete(); }
      await tester.pumpAndSettle();
      expect(repo.calls, ['one']);
      expect(completed, 0);
      expect(find.byType(PartyInviteSheet), findsNothing);
      staleSend(); // No context/provider access is allowed after disposal.
      await tester.pump();
      expect(repo.calls, ['one']);
      expect(tester.takeException(), isNull);
    });
  }
}
