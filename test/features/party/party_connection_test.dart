// ignore_for_file: subtype_of_sealed_class
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/data/party_server_snapshots.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'party_host_transfer_test.dart' as harness;
import 'party_wiring_test.dart' as fixtures;

class Metadata implements SnapshotMetadata {
  Metadata(this.isFromCache);
  @override final bool isFromCache;
  @override bool get hasPendingWrites => false;
  @override dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}
class Snapshot implements DocumentSnapshot<Map<String, dynamic>> {
  Snapshot(bool cached) : metadata = Metadata(cached);
  @override final SnapshotMetadata metadata;
  @override dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}
void main() {
  test('cache events do not terminate the listener and identical server snapshots recover', () async {
    final confirmed = Snapshot(false);
    await expectLater(serverConfirmedSnapshots(Stream.fromIterable([
      Snapshot(true), confirmed, Snapshot(true), confirmed,
    ])), emitsInOrder([
      emitsError(isA<PartyFailure>().having((e) => e.code, 'code', PartyError.connectionUnconfirmed)),
      same(confirmed),
      emitsError(isA<PartyFailure>().having((e) => e.code, 'code', PartyError.connectionUnconfirmed)),
      same(confirmed), emitsDone,
    ]));
  });
  testWidgets('unconfirmed lobby hides actions and recovers automatically', (tester) async {
    final updates = StreamController<Party?>();
    await harness.mountLive(tester, harness.RoleRepository(), updates);
    expect(find.byType(InviteSheetPage), findsOneWidget);
    updates.addError(const PartyFailure(PartyError.connectionUnconfirmed));
    await tester.pumpAndSettle();
    expect(find.byType(InviteSheetPage), findsNothing);
    expect(find.textContaining('Waiting for server confirmation'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    updates.add(fixtures.lobby());
    await tester.pumpAndSettle();
    expect(find.byType(InviteSheetPage), findsOneWidget);
    expect(find.textContaining('Waiting for server confirmation'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    unawaited(updates.close());
    await tester.pump();
  });
}
