import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'support/empty_friends_fixture.dart';
import 'package:socialdeck/features/party/providers/party_social_provider.dart';

void main() {
  testWidgets(
    'empty friends preview disables inviting, copies code, isolates live friends',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = call.arguments['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          partyFriendsProvider.overrideWith(
            (ref) => Stream.value(const [
              PartyFriend(uid: 'real', name: 'Real friend'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: SDeckAppTheme.light,
            home: const Scaffold(body: EmptyFriendsDevPreview()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          'No friends available. Share your party code to invite players.',
        ),
        findsOneWidget,
      );
      expect(find.text('Real friend'), findsNothing);
      expect(
        tester
            .widget<SDeckSolidButton>(
              find.widgetWithText(SDeckSolidButton, 'Invite'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byTooltip('Copy party code'));
      await tester.pumpAndSettle();
      expect(copied, '123456');
      expect(
        (await container.read(partyFriendsProvider.future)).single.uid,
        'real',
      );
      expect(tester.takeException(), isNull);
    },
  );
}
