import 'package:flutter_test/flutter_test.dart';
import 'package:socialdeck/config/routes/guards/profile_setup_redirect.dart';
void main() {
  test('missing profile resumes setup on home and nested home routes', () {
    expect(profileSetupRedirect('/home', false), '/profile/introduce-card');
    expect(profileSetupRedirect('/home/party', false), '/profile/introduce-card');
  });
  test('failed lookup never restarts onboarding', () {
    expect(profileSetupRedirect('/home', null), isNull);
  });
  test('completed profiles enter home and leave auth entry screens', () {
    expect(profileSetupRedirect('/home', true), isNull);
    expect(profileSetupRedirect('/login', true), '/home');
    expect(profileSetupRedirect('/signup', true), isNull);
  });
  test('setup navigation avoids redundant reads and redirect loops', () {
    expect(needsProfileStatus('/profile/introduce-card'), isFalse);
    expect(profileSetupRedirect('/profile/introduce-card', false), isNull);
    expect(needsProfileStatus('/login/password'), isFalse);
    expect(needsProfileStatus('/home'), isTrue);
  });
}
