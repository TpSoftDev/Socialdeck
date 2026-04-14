// -----------------------------------------------------------------------------
// firebase_password_reset_uri_parser.dart
// -----------------------------------------------------------------------------
// Extracts [oobCode] from Firebase Auth email action URLs (password reset).
// Links may be flat query params or wrapped in a `link=` query (nested URI).
// -----------------------------------------------------------------------------

String? _readQuery(Uri uri, String key) {
  final direct = uri.queryParameters[key];
  if (direct != null && direct.isNotEmpty) return direct;

  final wrapped = uri.queryParameters['link'];
  if (wrapped == null || wrapped.isEmpty) return null;

  Uri? inner = Uri.tryParse(wrapped);
  inner ??= Uri.tryParse(Uri.decodeFull(wrapped));
  if (inner == null) return null;

  final nested = inner.queryParameters[key];
  if (nested != null && nested.isNotEmpty) return nested;

  if (inner.fragment.isNotEmpty) {
    final fromFragment = Uri.splitQueryString(inner.fragment)[key];
    if (fromFragment != null && fromFragment.isNotEmpty) return fromFragment;
  }
  return null;
}

/// Returns the out-of-band code if [uri] looks like a password reset action.
///
/// When [mode] is present it must be `resetPassword`. When absent, a non-empty
/// [oobCode] alone is accepted (some redirects omit [mode] in the outer URL).
String? parseFirebasePasswordResetOobCode(Uri uri) {
  final code = _readQuery(uri, 'oobCode');
  if (code == null || code.isEmpty) return null;

  final mode = _readQuery(uri, 'mode');
  if (mode != null && mode != 'resetPassword') return null;

  return code;
}
