import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/features/login/data/login_repository.dart';
import 'package:socialdeck/features/login/providers/login_validation_provider.dart';

class Repository implements LoginRepository {
  Map<String, dynamic>? profile;
  bool failLookup = false;
  bool validPassword = false;
  String? lookup;
  @override
  Future<Map<String, dynamic>?> getRevealProfileByEmail(String email) async {
    lookup = email;
    if (failLookup) throw Exception('offline');
    return profile;
  }
  @override
  Future<bool> validatePassword(String email, String password) async => validPassword;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
void main() {
  for (final failedLookup in [false, true]) {
    test('missing profile allows password step; lookup failure=$failedLookup', () async {
      final repo = Repository()..failLookup = failedLookup;
      final notifier = LoginValidationProvider(repo);
      addTearDown(notifier.dispose);
      await notifier.loadRevealProfileForEmail(' User@Example.com ');
      expect(repo.lookup, 'user@example.com');
      expect(notifier.state.isValidationSuccessful, isTrue);
      expect(notifier.state.userProfileData, isNull);
      await notifier.validatePassword('user@example.com', 'incorrect');
      expect(notifier.state.isValidationSuccessful, isFalse);
      expect(notifier.state.isLoading, isFalse);
      repo.validPassword = true;
      await notifier.validatePassword('user@example.com', 'correct');
      expect(notifier.state.isValidationSuccessful, isTrue);
      expect(notifier.state.userProfileData, isNull);
    });
  }
  test('existing profile reveal remains available', () async {
    final repo = Repository()..profile = {'username': 'Tester'};
    final notifier = LoginValidationProvider(repo);
    addTearDown(notifier.dispose);
    await notifier.loadRevealProfileForEmail('user@example.com');
    expect(notifier.state.userProfileData?['username'], 'Tester');
  });
}
