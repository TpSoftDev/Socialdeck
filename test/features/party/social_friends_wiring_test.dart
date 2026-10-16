import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/party/party.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';
import 'package:socialdeck/features/social/presentation/pages/social_page.dart';
import 'package:socialdeck/shared/providers/auth_state_provider.dart';

Future<void> mount(WidgetTester tester, Stream<List<PartyFriend>> Function() friends) async {
  await tester.pumpWidget(ProviderScope(overrides: [
    currentUserProvider.overrideWithValue(null),
    partyInvitationsProvider.overrideWith((ref) => Stream.value([])),
    partyFriendsProvider.overrideWith((ref) => friends()),
  ], child: MaterialApp(theme: SDeckAppTheme.light, home: const SocialPage())));
  await tester.pump();
}

void main() {
  testWidgets('Social renders real friends and tracks removals without sample presence', (tester) async {
    final stream = StreamController<List<PartyFriend>>();
    await mount(tester, () => stream.stream);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    stream.add(const [PartyFriend(uid: 'alex', name: 'IA Test Alex'), PartyFriend(uid: 'sam', name: 'IA Test Sam')]);
    await tester.pumpAndSettle();
    expect(find.text('IA Test Alex'), findsOneWidget);
    expect(find.text('IA Test Sam'), findsOneWidget);
    expect(find.text('tpsoftdev'), findsNothing);
    expect(find.text('In Party'), findsNothing);
    stream.add(const [PartyFriend(uid: 'sam', name: 'IA Test Sam')]);
    await tester.pumpAndSettle();
    expect(find.text('IA Test Alex'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    unawaited(stream.close());
    await tester.pump();
  });
  testWidgets('empty friends is distinct from failure and retry reloads the list', (tester) async {
    var requests = 0;
    await mount(tester, () => ++requests == 1 ? Stream.error(Exception('offline')) : Stream.value([]));
    await tester.pumpAndSettle();
    expect(find.text('Could not load friends. Retry'), findsOneWidget);
    expect(find.text('No friends yet. Use Find Friends to get started.'), findsNothing);
    await tester.tap(find.text('Could not load friends. Retry'));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(find.text('No friends yet. Use Find Friends to get started.'), findsOneWidget);
    expect(find.text('Could not load friends. Retry'), findsNothing);
  });
}
