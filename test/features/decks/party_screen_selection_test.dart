import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/decks/decks_home/decks_page.dart';
import 'package:socialdeck/features/decks/decks_home/deck_cards_page.dart';
import 'package:socialdeck/features/decks/decks_home/saved_deck.dart';
import 'package:socialdeck/features/decks/shared/saved_card.dart';
import 'package:socialdeck/features/decks/shared/deck_party_selection.dart';
import 'package:socialdeck/features/games/presentation/pages/invite_sheet_page.dart';
import 'package:socialdeck/features/party/party.dart';
import '../party/party_late_state_test.dart' as harness;

SavedDeck deck(String name, int count) {
  final d = SavedDeck(name: name, color: SDeckColorPickerColor.brightCoral);
  d.photoPaths.addAll(
    List.generate(count, (i) => SavedCard('assets/Photos/$name-$i.jpg')),
  );
  return d;
}

void main() {
  test(
    'draft spans decks, ignores duplicate photos and does not reorder library',
    () {
      final a = deck('A', 4), b = deck('B', 4);
      b.photoPaths.add(a.photoPaths.first);
      final s = DeckPartySelection(
        mode: DeckPartySelectionMode.handpicked,
        decks: [a, b],
      );
      for (final c in [...a.photoPaths, ...b.photoPaths.take(4)]) {
        s.toggle(c);
      }
      expect(s.pool, hasLength(8));
      expect(s.finish(random: Random(1)), hasLength(7));
      expect(s.finish()!.map((c) => c.photoPath).toSet(), hasLength(7));
      expect(a.photoPaths.first.photoPath, 'assets/Photos/A-0.jpg');
      s.enabled = false;
      expect(s.finish(), isNull);
      s.dispose();
    },
  );
  test(
    'single deck requires seven unique cards; removed deck cannot confirm',
    () {
      final small = deck('Small', 6), big = deck('Big', 7);
      final decks = [small, big];
      final s = DeckPartySelection(
        mode: DeckPartySelectionMode.singleDeck,
        decks: decks,
      );
      s.selectDeck(small);
      expect(s.canConfirm, isFalse);
      s.selectDeck(big);
      expect(s.canConfirm, isTrue);
      decks.remove(big);
      expect(s.finish(), isNull);
      s.dispose();
    },
  );
  test(
    'random draws from saved decks only and never changes their contents',
    () {
      final d = deck('A', 8);
      final s = DeckPartySelection(
        mode: DeckPartySelectionMode.random,
        decks: [d],
      );
      expect(s.finish(), hasLength(7));
      expect(d.photoPaths, hasLength(8));
      s.dispose();
    },
  );
  testWidgets(
    'existing deck pages share selection, Back preserves tray, confirm returns seven',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final a = deck('A', 4), b = deck('B', 4);
      final s = DeckPartySelection(
        mode: DeckPartySelectionMode.handpicked,
        decks: [a, b],
      );
      List<SavedCard>? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: SDeckAppTheme.light,
          home: Builder(
            builder:
                (context) => TextButton(
                  onPressed: () async {
                    result = await Navigator.push<List<SavedCard>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DecksPage(selection: s),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(DecksPage), findsOneWidget);
      for (final d in [a, b]) {
        await tester.tap(find.text(d.name));
        await tester.pumpAndSettle();
        expect(find.byType(DeckCardsPage), findsOneWidget);
        for (final c in d.photoPaths) {
          await tester.ensureVisible(
            find.byKey(ValueKey('party-photo-${c.photoPath}')),
          );
          await tester.tap(find.byKey(ValueKey('party-photo-${c.photoPath}')));
          await tester.pumpAndSettle();
        }
        if (d == a) {
          tester
              .widget<SDeckTopNavigationBar>(
                find.byType(SDeckTopNavigationBar).last,
              )
              .onLeftPressed!();
          await tester.pumpAndSettle();
          expect(s.selectedCards, hasLength(4));
        }
      }
      await tester.tap(find.text('Use Any of 8 Cards'));
      await tester.pumpAndSettle();
      expect(result, hasLength(7));
      expect(find.text('Open'), findsOneWidget);
      expect(a.photoPaths, hasLength(4));
      s.dispose();
    },
  );
  testWidgets('normal Decks screen keeps creation and Quick Pics controls', (
    tester,
  ) async {
    DecksLibrary.instance.decks.clear();
    await tester.pumpWidget(
      MaterialApp(theme: SDeckAppTheme.light, home: const DecksPage()),
    );
    expect(find.text('Quick Pics'), findsOneWidget);
    expect(find.byType(SDeckAddTarget), findsOneWidget);
    expect(find.byType(DeckPartySelectionFooter), findsNothing);
  });
  testWidgets(
    'normal lobby opens teammate screens and cancel performs no hand write',
    (tester) async {
      final updates = StreamController<Party?>();
      addTearDown(updates.close);
      final repo = harness.LateStateRepository();
      await harness.mount(tester, repo, updates);
      tester
          .widget<InviteSheetPage>(find.byType(InviteSheetPage))
          .live!
          .onCards!();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Free-to-Choose'));
      await tester.pumpAndSettle();
      expect(find.byType(DecksPage), findsOneWidget);
      expect(repo.hands, isEmpty);
      updates.add(null);
      await tester.pumpAndSettle();
      expect(
        find.text('The party changed. Go back to the lobby.'),
        findsOneWidget,
      );
      expect(
        tester
            .widget<DeckPartySelectionFooter>(
              find.byType(DeckPartySelectionFooter),
            )
            .selection
            .enabled,
        isFalse,
      );
      tester
          .widget<SDeckTopNavigationBar>(
            find.byType(SDeckTopNavigationBar).last,
          )
          .onLeftPressed!();
      await tester.pumpAndSettle();
      expect(repo.hands, isEmpty);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
