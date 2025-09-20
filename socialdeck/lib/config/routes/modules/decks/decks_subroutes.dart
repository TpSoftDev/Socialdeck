// -----------------------------------------------------------------------------
// decks_subroutes.dart
// -----------------------------------------------------------------------------
// Contains sub-route definitions for the Decks feature (used within ShellRoute)
// Modularizes deck sub-pages for scalability and organization
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/decks/presentation/pages/test_deck_list_view.dart';
import 'package:socialdeck/features/decks/presentation/pages/test_empty_deck.dart';
import 'package:socialdeck/features/decks/presentation/pages/test_create_deck.dart';
import 'package:socialdeck/features/decks/presentation/pages/test_create_deck_bottom_sheet.dart';

final List<GoRoute> decksSubRoutes = [
  // Create Deck page route
  GoRoute(
    path: 'Empty',
    builder: (context, state) => const TestEmptyDeckPage(),
  ),
  // Deck Details page route
  GoRoute(
    path: 'Create',
    builder: (context, state) => const TestCreateDeckPage(),
  ),
  // Deck List page route
  GoRoute(
    path: 'List',
    builder: (context, state) => const TestDeckListViewPage(),
  ),
  // Create Deck Bottom Sheet page route
  GoRoute(
    path: 'BottomSheet',
    builder: (context, state) => const TestCreateDeckBottomSheetPage(),
  ),
];
