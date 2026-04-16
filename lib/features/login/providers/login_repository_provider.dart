// -----------------------------------------------------------------------------
// login_repository_provider.dart
// -----------------------------------------------------------------------------
// Single [LoginRepository] instance for Riverpod (swap impl for tests).
// -----------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firebase_login_repository.dart';
import '../data/login_repository.dart';

final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) => FirebaseLoginRepository(),
);
