// -----------------------------------------------------------------------------
// decks_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the Decks feature of the main app.
// Follows the same modularization, documentation, and spacing pattern as other
// route modules (e.g., profile_routes.dart, login_routes.dart).
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/decks/presentation/pages/decks_page.dart';

final List<GoRoute> decksRoutes = [
  // Decks main page route - shows all decks (placeholder for now)
  GoRoute(
    path: '/decks',
    name: 'decks',
    builder: (context, state) => const DecksPage(),
  ),
];
