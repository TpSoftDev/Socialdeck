import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/presentation/party_lobby_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import 'firebase_party_repository_test.dart' show TestUser;
import 'party_wiring_test.dart' as fixtures;

class RoleRepository extends fixtures.UiRepository {
  final promotions = <String>[];
  final kicks = <String>[];
  @override
  Future<void> promoteHost(String id, String uid) async => promotions.add(uid);
  @override
  Future<void> kickPlayer(String id, String uid) async => kicks.add(uid);
}

Future<void> mountLive(
  WidgetTester tester,
  RoleRepository repo,
  StreamController<Party?> updates, {
  String uid = 'host',
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        currentUserProvider.overrideWithValue(TestUser(uid)),
        partyRepositoryProvider.overrideWithValue(repo),
        partyByIdProvider('123456').overrideWith((ref) => updates.stream),
        partyHandProvider('123456').overrideWith((ref) => Stream.value(null)),
        partyEventsProvider('123456').overrideWith((ref) => Stream.value([])),
      ],
      child: MaterialApp(
        theme: SDeckAppTheme.light,
        home: const PartyLobbyPage(partyId: '123456'),
      ),
    ),
  );
  updates.add(fixtures.lobby());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'preview promotion revokes host controls without changing identity',
    (tester) async {
      tester.view.physicalSize = const Size(600, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(theme: SDeckAppTheme.light, home: const InviteSheetPage()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('thabang'));
      await tester.pumpAndSettle();
      final stalePromote =
          tester
              .widget<SDeckSolidButton>(
                find.widgetWithText(SDeckSolidButton, 'Promote to Host'),
              )
              .onPressed;
      final staleKick =
          tester
              .widget<SDeckOutlineButton>(
                find.widgetWithText(SDeckOutlineButton, 'Kick'),
              )
              .onPressed;
      await tester.tap(find.text('Promote to Host'));
      await tester.pumpAndSettle();
      expect(find.text('New Host'), findsOneWidget);
      tester.widget<SDeckToast>(find.byType(SDeckToast)).onDismiss?.call();
      await tester.pumpAndSettle();
      await tester.tap(find.text('thabang'));
      await tester.pumpAndSettle();
      expect(find.text('Promote to Host'), findsNothing);
      expect(find.text('Kick'), findsNothing);
      // A callback captured before the transfer must also stop doing host work.
      stalePromote?.call();
      staleKick?.call();
      await tester.pumpAndSettle();
      expect(find.text('Wait!'), findsNothing);
      expect(find.byType(SDeckProfileBottomSheet), findsOneWidget);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('ethan'));
      await tester.pumpAndSettle();
      expect(find.text('Change Name'), findsOneWidget);
      expect(find.text('eth6n'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('open live player sheet reacts to losing host rights', (
    tester,
  ) async {
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    final repo = RoleRepository();
    await mountLive(tester, repo, updates);
    await tester.tap(find.text('Guest'));
    await tester.pumpAndSettle();
    final stalePromote =
        tester
            .widget<ListTile>(find.widgetWithText(ListTile, 'Promote to Host'))
            .onTap!;
    updates.add(fixtures.lobby().copyWith(hostId: 'guest'));
    await tester.pumpAndSettle();
    expect(find.text('Promote to Host'), findsNothing);
    expect(find.text('Kick'), findsNothing);
    expect(find.text('Host'), findsOneWidget);
    stalePromote();
    await tester.pumpAndSettle();
    expect(repo.promotions, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('new host can pass ownership again from an already open sheet', (
    tester,
  ) async {
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    final repo = RoleRepository();
    await mountLive(tester, repo, updates, uid: 'guest');
    await tester.tap(find.text('Alex'));
    await tester.pumpAndSettle();
    expect(find.text('Promote to Host'), findsNothing);
    updates.add(fixtures.lobby().copyWith(hostId: 'guest'));
    await tester.pumpAndSettle();
    expect(find.text('Promote to Host'), findsOneWidget);
    expect(find.text('Kick'), findsOneWidget);
    await tester.tap(find.text('Promote to Host'));
    await tester.pumpAndSettle();
    expect(repo.promotions, ['host']);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('pending kick is disabled and rechecked when host changes', (
    tester,
  ) async {
    final updates = StreamController<Party?>();
    addTearDown(updates.close);
    final repo = RoleRepository();
    await mountLive(tester, repo, updates);
    await tester.tap(find.text('Guest'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kick'));
    await tester.pumpAndSettle();
    final staleConfirm =
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Kick'))
            .onPressed!;
    updates.add(fixtures.lobby().copyWith(hostId: 'guest'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Kick'))
          .onPressed,
      isNull,
    );
    staleConfirm();
    await tester.pumpAndSettle();
    expect(repo.kicks, isEmpty);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
