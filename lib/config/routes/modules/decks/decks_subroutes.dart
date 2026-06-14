// -----------------------------------------------------------------------------
// decks_subroutes.dart
// -----------------------------------------------------------------------------
// Contains sub-route definitions for the Decks feature (used within ShellRoute)
// Modularizes deck sub-pages for scalability and organization
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/test_pages/test_deck_list_view.dart';
import 'package:socialdeck/test_pages/test_empty_deck.dart';
import 'package:socialdeck/test_pages/test_create_deck.dart';
import 'package:socialdeck/test_pages/test_create_deck_bottom_sheet.dart';
import 'package:socialdeck/test_pages/test_review_cards_page.dart';
import 'package:socialdeck/test_pages/test_deck_persistence.dart';
import 'package:socialdeck/test_pages/add_cards_page.dart';

final List<GoRoute> decksSubRoutes = [
  GoRoute(
    path: '/test/decks/empty',
    builder: (context, state) => const TestEmptyDeckPage(),
  ),
  GoRoute(
    path: '/test/decks/create',
    builder: (context, state) => const TestCreateDeckPage(),
  ),
  GoRoute(
    path: '/test/decks/list',
    builder: (context, state) => const TestDeckListViewPage(),
  ),
  GoRoute(
    path: '/test/decks/bottom-sheet',
    builder: (context, state) => const TestCreateDeckBottomSheetPage(),
  ),
  GoRoute(
    path: '/test/decks/add-cards',
    builder: (context, state) => const AddCardsPage(),
  ),
  GoRoute(
    path: '/test/decks/review-cards',
    builder: (context, state) => const TestReviewCardsPage(selectedPhotos: []),
  ),
  GoRoute(
    path: '/test/decks/persistence',
    builder: (context, state) => const TestDeckPersistencePage(),
  ),
];
