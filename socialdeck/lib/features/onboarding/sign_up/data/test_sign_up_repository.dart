// -----------------------------------------------------------------------------
// test_sign_up_repository.dart
// -----------------------------------------------------------------------------
// Implements the SignUpRepository interface using test/mock data for development.
// Simulates backend checks for email availability, password rules, and verification.
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

  @override
  Future<bool> checkEmailAvailable(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Basic email format check
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final isValidFormat = emailRegex.hasMatch(email);
    final isTaken = testRegisteredEmails.contains(email);
    return isValidFormat && !isTaken;
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
    return true;
  }
}
