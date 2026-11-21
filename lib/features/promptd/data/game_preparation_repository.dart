import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:socialdeck/config/local_gameplay.dart';

// IA: Local callable adapter: authenticated requests, no client profiles or prompt text.
class GamePreparationRepository {
  GamePreparationRepository({http.Client? client})
    : _client = client ?? http.Client();
  final http.Client _client;
  Future<Map<String, dynamic>> call(String function, String partyId) async {
    if (!LocalGameplay.enabled) {
      throw StateError('Local gameplay mode is not enabled.');
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Sign in to start the game.');
    final token = await user.getIdToken();
    final response = await _client
        .post(
          LocalGameplay.endpoint(function),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'data': {'partyId': partyId},
          }),
        )
        .timeout(const Duration(seconds: 15));
    if (FirebaseAuth.instance.currentUser?.uid != user.uid) {
      throw StateError('Account changed.');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['error'] != null) {
      throw StateError(
        (json['error'] as Map)['message'] as String? ??
            'Game preparation failed.',
      );
    }
    return Map<String, dynamic>.from(json['result'] as Map);
  }

  void close() => _client.close();
}
