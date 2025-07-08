// -----------------------------------------------------------------------------
// test_sign_up_repository.dart
// -----------------------------------------------------------------------------
// Implements the SignUpRepository interface using test/mock data for development.
// Simulates backend checks for user creation, password rules, and verification.
// -----------------------------------------------------------------------------

import 'dart:async';
import 'sign_up_repository.dart';

class TestSignUpRepository implements SignUpRepository {
  // Test data: emails that are already "registered"
  static final Set<String> testRegisteredEmails = {
    'taken@email.com',
    'user@example.com',
    'test@socialdeck.com',
  };

  /// Simulates creating a new user account.
  /// Returns true if email is not taken, false if it is.
  /// Throws an exception to simulate Firebase errors.
  @override
  Future<bool> createUser(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Basic email format check
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final isValidFormat = emailRegex.hasMatch(email);

    if (!isValidFormat) {
      throw Exception('Invalid email format');
    }

    // Check if email is already taken
    final isTaken = testRegisteredEmails.contains(email);
    if (isTaken) {
      throw Exception('Email is already in use');
    }

    // Simulate successful user creation
    print('Test: User created successfully with email: $email');
    return true;
  }

  @override
  Future<bool> validatePasswordRules(String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // Check for minimum length (8 characters)
    return password.length >= 8;
  }

  @override
  Future<bool> sendVerificationEmail(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Always return true for simulation
    print('Test: Verification email sent to: $email');
    return true;
  }
}
