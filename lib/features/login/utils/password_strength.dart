// -----------------------------------------------------------------------------
// password_strength.dart
// -----------------------------------------------------------------------------
// Shared rule: 8+ chars, letter, digit, symbol 
// -----------------------------------------------------------------------------

bool isStrongPassword(String value) {
  if (value.length < 8) return false;
  if (!RegExp(r'[A-Za-z]').hasMatch(value)) return false;
  if (!RegExp(r'\d').hasMatch(value)) return false;
  if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) return false;
  return true;
}
