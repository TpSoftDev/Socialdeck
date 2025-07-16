// -----------------------------------------------------------------------------
// store_routes.dart
// -----------------------------------------------------------------------------
// Contains GoRoute definitions for the Store feature of the main app.
// Follows the same modularization, documentation, and spacing pattern as other
// route modules (e.g., profile_routes.dart, login_routes.dart).
// -----------------------------------------------------------------------------

import 'package:go_router/go_router.dart';
import 'package:socialdeck/features/store/presentation/pages/store_page.dart';

final List<GoRoute> storeRoutes = [
  // Store main page route - shows store/marketplace (placeholder for now)
  GoRoute(
    path: '/store',
    name: 'store',
    builder: (context, state) => const StorePage(),
  ),
];
