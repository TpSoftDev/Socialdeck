import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../domain/prompt_ai.dart';

// IA: Callable REST adapter for the existing prototype, not a second model implementation.
// Local AI auth is isolated: the app stays signed into the team's Party Firebase project.
class FirebasePromptAiRepository implements PromptAiRepository {
  final http.Client client;
  final String emulatorHost, projectId;
  final FirebaseAuth Function() auth;
  String? _token, _refreshToken, _owner;
  DateTime _expires = DateTime.fromMillisecondsSinceEpoch(0);
  FirebasePromptAiRepository({
    http.Client? client,
    FirebaseAuth Function()? auth,
    this.emulatorHost = const String.fromEnvironment('PROMPTD_EMULATOR_HOST'),
    this.projectId = const String.fromEnvironment('PROMPTD_PROJECT_ID'),
  }) : client = client ?? http.Client(),
       auth = auth ?? (() => FirebaseAuth.instance);

  Future<Map<String, dynamic>> _post(
    Uri url,
    Map<String, Object?> body, {
    String? token,
  }) async {
    try {
      final response = await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 100));
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400 || json['error'] != null) {
        final code =
            (json['error'] is Map ? json['error']['status'] : null)?.toString();
        throw PromptAiException(switch (code) {
          'RESOURCE_EXHAUSTED' =>
            'AI request limit reached. Wait before retrying; your reviews are kept.',
          'UNAUTHENTICATED' => 'Sign in again before using AI setup.',
          'PERMISSION_DENIED' =>
            'This account is not enabled for the AI service yet.',
          'INVALID_ARGUMENT' =>
            'The AI service could not accept this setup or feedback. Check your entries.',
          'FAILED_PRECONDITION' =>
            'The AI session is no longer ready for this action. Return to setup and generate again.',
          _ =>
            'AI service is unavailable. Retry shortly; your reviews are kept.',
        });
      }
      return json;
    } on PromptAiException {
      rethrow;
    } on TimeoutException {
      throw const PromptAiException(
        'AI generation timed out. Retry to recover the same request.',
      );
    } catch (_) {
      throw const PromptAiException(
        'Cannot reach the AI service. Check the connection and retry.',
      );
    }
  }

  Future<PromptAiSession> _call(
    String function,
    Map<String, Object?> data,
  ) async {
    if (projectId.isEmpty)
      throw const PromptAiException(
        'AI service is not configured in this build. Use the AI test build.',
      );
    final user = auth().currentUser;
    if (user == null)
      throw const PromptAiException('Sign in before generating prompts.');
    final owner = user.uid;
    String? token;
    late Uri endpoint;
    if (emulatorHost.isNotEmpty) {
      // IA: Never allow an insecure emulator endpoint in release or a real project.
      if (!kDebugMode ||
          !projectId.startsWith('demo-') ||
          !const [
            '10.0.2.2',
            '127.0.0.1',
            'localhost',
          ].contains(emulatorHost)) {
        throw const PromptAiException(
          'Invalid local AI testing configuration.',
        );
      }
      if (_owner != owner) {
        _token = null;
        _refreshToken = null;
        _owner = owner;
      }
      if (_token == null || DateTime.now().isAfter(_expires)) {
        if (_refreshToken == null) {
          final result = await _post(
            Uri.parse(
              'http://$emulatorHost:9099/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key',
            ),
            {'returnSecureToken': true},
          );
          _token = result['idToken'] as String;
          _refreshToken = result['refreshToken'] as String;
        } else {
          final result = await _post(
            Uri.parse(
              'http://$emulatorHost:9099/securetoken.googleapis.com/v1/token?key=demo-key',
            ),
            {'grant_type': 'refresh_token', 'refresh_token': _refreshToken},
          );
          _token = result['id_token'] as String;
          _refreshToken = result['refresh_token'] as String;
        }
        _expires = DateTime.now().add(const Duration(minutes: 50));
      }
      token = _token;
      endpoint = Uri.parse(
        'http://$emulatorHost:5001/$projectId/us-central1/$function',
      );
    } else {
      if (projectId != auth().app.options.projectId) {
        throw const PromptAiException(
          'AI service and signed-in Firebase project must match.',
        );
      }
      token = await user.getIdToken();
      endpoint = Uri.https(
        'us-central1-$projectId.cloudfunctions.net',
        '/$function',
      );
    }
    final result = await _post(endpoint, {'data': data}, token: token);
    if (auth().currentUser?.uid != owner)
      throw const PromptAiException('Account changed. Start a new AI setup.');
    return PromptAiSession.fromJson(
      Map<String, dynamic>.from(result['result'] as Map),
    );
  }

  @override
  Future<PromptAiSession> generate(
    Map<String, Object?> profile,
    String requestId,
  ) => _call('generatePromptExamples', {
    'contractVersion': 1,
    'requestId': requestId,
    'mode': 'examples',
    'count': 5,
    'profile': profile,
  });
  @override
  Future<PromptAiSession> vote(
    String sessionId,
    String promptId,
    bool accepted,
    List<String> reasons,
    String explanation,
    String requestId,
  ) => _call('submitPromptFeedback', {
    'contractVersion': 1,
    'requestId': requestId,
    'sessionId': sessionId,
    'promptId': promptId,
    'accepted': accepted,
    'reasons': reasons,
    'explanation': explanation,
  });
  @override
  Future<PromptAiSession> replaceRejected(String sessionId, String requestId) =>
      _call('generateNextPrompts', {
        'contractVersion': 1,
        'requestId': requestId,
        'sessionId': sessionId,
        'count': 5,
        'replaceRejected': true,
      });
  void dispose() => client.close();
}
