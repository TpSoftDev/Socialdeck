// -----------------------------------------------------------------------------
// decks_subroutes.dart
// -----------------------------------------------------------------------------
// Contains sub-route definitions for the Decks feature (used within ShellRoute)
// Modularizes deck sub-pages for scalability and organization
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/decks/presentation/pages/create_deck_page.dart';
import 'package:socialdeck/features/decks/presentation/pages/deck_details_page.dart';

final List<GoRoute> decksSubRoutes = [
  // Create Deck page route
  GoRoute(path: 'create', builder: (context, state) => const CreateDeckPage()),
  // Deck Details page route
  GoRoute(
    path: ':deckId',
    builder: (context, state) {
      final deckId = state.pathParameters['deckId']!;
      return DeckDetailsPage(deckId: deckId);
    },
  ),
];
