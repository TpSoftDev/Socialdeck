// -----------------------------------------------------------------------------
// test_users.dart
// -----------------------------------------------------------------------------
// Test user data for login validation in the onboarding flow.
// This file contains a simple Map of username/password pairs that we use
// to simulate a real user database during development and testing.
//
// Later, when you add Firebase, this will be replaced with real user data
// from your Firebase Authentication or Firestore database.
// -----------------------------------------------------------------------------

/// Test user database for login validation.
final Map<String, String> testUsers = {
  'john': 'password123',
  'sarah': 'secure456',
  'admin': 'admin123',
};
