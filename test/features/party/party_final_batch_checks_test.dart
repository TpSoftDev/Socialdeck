import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/features/games/presentation/pages/party_lobby_binding.dart';
import 'party_wiring_test.dart' as fixtures;

class BatchRepository extends fixtures.UiRepository {
  final first = Completer<void>();
  final calls = <String>[];
  PartyError? secondFailure;
  @override Future<void> invitePlayer(String party, String uid) async {
    calls.add(uid);
    if(uid == 'a') await first.future;
    if(uid == 'b' && secondFailure != null) throw PartyFailure(secondFailure!);
  }
}
void main() {
  for(final scenario in ['removed', 'closed', 'friend removed', 'double tap']) {
    testWidgets('final batch check: $scenario', (tester) async {
      final repo = BatchRepository();
      final friends = StreamController<List<PartyFriend>>();
      const all = [PartyFriend(uid:'a',name:'Alex'), PartyFriend(uid:'b',name:'Sam'), PartyFriend(uid:'c',name:'Chris')];
      final batches = <List<PartyInviteNotice>>[];
      await tester.pumpWidget(ProviderScope(overrides: [
        partyRepositoryProvider.overrideWithValue(repo),
        partyFriendsProvider.overrideWith((ref) => friends.stream),
      ],child:MaterialApp(theme:SDeckAppTheme.light, home:Scaffold(body:PartyInviteSheet(partyId:'123456',onComplete:batches.add)))));
      friends.add(all); await tester.pumpAndSettle();
      for(final friend in all) { await tester.tap(find.text(friend.name)); await tester.pump(); }
      final send = tester.widget<SDeckSolidButton>(find.widgetWithText(SDeckSolidButton,'Invite 3 Friends')).onPressed!;
      send(); await tester.pump();
      expect(repo.calls,['a']);
      if(scenario == 'double tap') { send(); await tester.pump(); expect(repo.calls,['a']); }
      if(scenario == 'friend removed') { friends.add([all[0],all[2]]); await tester.pump(); }
      if(scenario == 'removed') repo.secondFailure=PartyError.forbidden;
      if(scenario == 'closed') repo.secondFailure=PartyError.closed;
      repo.first.complete(); await tester.pumpAndSettle();
      if(scenario == 'removed' || scenario == 'closed') {
        expect(repo.calls,['a','b']);
        expect(batches.single.first.description,contains('Remaining invitations were not sent.'));
        expect(batches.single.last.description,contains('Sent to Alex.'));
      } else if(scenario == 'friend removed') {
        expect(repo.calls,['a','c']);
        expect(batches.single.first.success,isFalse);
        expect(batches.single.last.description,contains('Sent to Alex, Chris.'));
      } else {
        expect(repo.calls,['a','b','c']);
        expect(batches.length,1);
        expect(batches.single.single.success,isTrue);
      }
      expect(tester.takeException(),isNull);
      await tester.pumpWidget(const SizedBox());
      unawaited(friends.close()); await tester.pump();
    });
  }
}
