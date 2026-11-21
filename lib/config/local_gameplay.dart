// IA: Explicit debug-only demo backend. Normal builds keep the team's Firebase project.
import 'package:flutter/foundation.dart';

class LocalGameplay {
  static const requested = bool.fromEnvironment('SOCIALDECK_LOCAL_GAMEPLAY');
  static bool get enabled => kDebugMode && requested;
  static const project = 'demo-socialdeck-gameplay';
  static const host = String.fromEnvironment(
    'SOCIALDECK_LOCAL_HOST',
    defaultValue: '10.0.2.2',
  );
  static bool get testLogin =>
      enabled && const bool.fromEnvironment('SOCIALDECK_LOCAL_TEST_LOGIN');
  static Uri endpoint(String function) =>
      Uri.parse('http://$host:5201/$project/us-central1/$function');
}
