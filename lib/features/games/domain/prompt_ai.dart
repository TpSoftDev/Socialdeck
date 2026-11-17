import 'dart:convert';
import 'dart:math';
import 'game_setup_state.dart';

// IA: Flutter speaks the web prototype's v1 contract. Model logic stays server-side.
class PromptAiException implements Exception {
  final String message;
  const PromptAiException(this.message);
  @override
  String toString() => message;
}

Map<String, Object?> promptProfile(GameSetupState draft) {
  const groups = {
    'Friends': 'close_friends',
    'Family': 'family',
    'Coworkers': 'coworkers',
    'Classmates': 'classmates',
  };
  final custom = [
    ...draft.groupCategories.where(
      (g) => g != 'Other' && !groups.containsKey(g),
    ),
    if (draft.groupCategories.contains('Other')) ...draft.customGroups,
  ].join(', ');
  final topics = [
    ...draft.selectedTopics.where((t) => t != 'Other'),
    if (draft.selectedTopics.contains('Other')) ...draft.customTopics,
  ].join(', ');
  final groupIds =
      draft.groupCategories
          .where(groups.containsKey)
          .map((g) => groups[g]!)
          .toList();
  // IA: Preserve the app's exact topic labels in notes instead of inventing enum matches.
  // There is deliberately no Less Topics UI; those contract fields remain empty.
  final note =
      custom.isEmpty && groupIds.isEmpty
          ? draft.groupDescription.trim()
          : custom;
  if (!draft.canContinueGroup ||
      !draft.canContinueTopics ||
      !draft.canContinueStyle ||
      draft.selectedTopics.length + draft.customTopics.length > 30 ||
      note.length > 500 ||
      topics.length > 500 ||
      draft.groupDescription.length > 1500) {
    throw const PromptAiException(
      'Check your setup. Custom groups/topics allow 500 characters; group description allows 1500.',
    );
  }
  return {
    'contractVersion': 1,
    'groupTypes': groupIds,
    'groupNote': note,
    'groupDescription': draft.groupDescription.trim(),
    'styleLevel': draft.styleLevel,
    'topicLabels':
        [
          ...draft.selectedTopics.where((t) => t != 'Other'),
          if (draft.selectedTopics.contains('Other')) ...draft.customTopics,
        ].toSet().toList(),
    'moreOf': <String>[],
    'moreOfNote': topics,
    'lessOf': <String>[],
    'lessOfNote': '',
    'safeMode': draft.safeMode,
    'averageAge': draft.averageAge,
  };
}

class AiPrompt {
  final String id, text;
  final List<String> topics;
  const AiPrompt(this.id, this.text, [this.topics = const []]);
}

class PromptAiSession {
  final String id;
  final List<AiPrompt> prompts;
  final Map<String, bool> feedback;
  const PromptAiSession(this.id, this.prompts, this.feedback);
  factory PromptAiSession.fromJson(Map<String, dynamic> json) {
    try {
      final prompts =
          (json['prompts'] as List)
              .map(
                (p) => AiPrompt(
                  p['id'] as String,
                  p['text'] as String,
                  List<String>.from(p['topics'] ?? const []),
                ),
              )
              .toList();
      final id = json['id'] as String;
      if (json['contractVersion'] != 1 ||
          id.isEmpty ||
          prompts.length != 5 ||
          prompts.map((p) => p.id).toSet().length != 5 ||
          prompts.any((p) => p.id.isEmpty || p.text.trim().isEmpty)) {
        throw const FormatException();
      }
      final votes = <String, bool>{};
      for (final vote in json['feedback'] as List) {
        votes[vote['promptId'] as String] = vote['accepted'] as bool;
      }
      return PromptAiSession(
        id,
        List.unmodifiable(prompts),
        Map.unmodifiable(votes),
      );
    } catch (_) {
      throw const PromptAiException(
        'The AI service returned an invalid session. Please retry.',
      );
    }
  }
  int get nextUnreviewed =>
      prompts.indexWhere((p) => !feedback.containsKey(p.id));
  bool get complete => prompts.every((p) => feedback[p.id] == true);
  List<String> get approved =>
      prompts.where((p) => feedback[p.id] == true).map((p) => p.text).toList();
}

abstract class PromptAiRepository {
  Future<PromptAiSession> generate(
    Map<String, Object?> profile,
    String requestId,
  );
  Future<PromptAiSession> vote(
    String sessionId,
    String promptId,
    bool accepted,
    List<String> reasons,
    String explanation,
    String requestId,
  );
  Future<PromptAiSession> replaceRejected(String sessionId, String requestId);
}

// IA: These IDs match shared/prompt_system/schemas/contracts.schema.json in the web project.
const aiReasonIds = {
  'Too boring': 'too_boring',
  'Too personal': 'too_personal',
  'Not personal enough': 'not_personal_enough',
  'Too safe': 'too_safe',
  'Too intense': 'too_intense',
  'Too generic': 'too_generic',
  'Too weird': 'too_weird',
  'Too serious': 'too_serious',
  'Wrong kind of humor': 'wrong_humor',
  'Not relevant': 'not_relevant',
  'Touches something to avoid': 'avoid_topic',
  'Other': 'other',
};

// IA: Retry the identical operation with the SAME request ID after network failure.
// This prevents a timeout from charging/generating or recording the vote twice.
class PromptAiFlow {
  final PromptAiRepository repository;
  PromptAiFlow(this.repository);
  PromptAiSession? session;
  String? profileKey;
  final _pending = <String, String>{};
  bool _busy = false;
  int _epoch = 0;
  void reset() {
    _epoch++;
    session = null;
    profileKey = null;
    _pending.clear();
  }

  String _id(String key) => _pending.putIfAbsent(key, () {
    final random = Random.secure();
    return List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  });
  Future<PromptAiSession> _run(
    String key,
    Future<PromptAiSession> Function(String) action,
  ) async {
    if (_busy)
      throw const PromptAiException('Please wait for the current request.');
    _busy = true;
    final epoch = _epoch;
    try {
      final result = await action(_id(key));
      if (epoch != _epoch)
        throw const PromptAiException('This setup was closed. Start again.');
      _pending.remove(key);
      session = result;
      return result;
    } finally {
      _busy = false;
    }
  }

  Future<PromptAiSession> generate(Map<String, Object?> profile) async {
    final fingerprint = jsonEncode(profile);
    final result = await _run(
      'generate:$fingerprint',
      (id) => repository.generate(profile, id),
    );
    profileKey = fingerprint;
    return result;
  }

  bool matches(Map<String, Object?> profile) =>
      profileKey == jsonEncode(profile);
  Future<PromptAiSession> vote(
    int index,
    bool accepted,
    List<String> reasons,
    String explanation,
  ) {
    final current = session;
    if (current == null || index < 0 || index >= current.prompts.length) {
      throw const PromptAiException('Generate examples first.');
    }
    if (explanation.length > 500)
      throw const PromptAiException(
        'Keep custom feedback within 500 characters.',
      );
    final prompt = current.prompts[index];
    final key = jsonEncode([
      'vote',
      current.id,
      prompt.id,
      accepted,
      reasons,
      explanation,
    ]);
    return _run(
      key,
      (id) => repository.vote(
        current.id,
        prompt.id,
        accepted,
        reasons,
        explanation,
        id,
      ),
    );
  }

  Future<PromptAiSession> finish() async {
    final current = session;
    if (current == null || current.nextUnreviewed >= 0) {
      throw const PromptAiException('Review every example first.');
    }
    if (current.complete) return current;
    // IA: Accepted IDs/text stay intact; only rejected prompts are replaced.
    return _run(
      'replace:${current.id}:${current.prompts.map((p) => p.id).join(',')}',
      (id) => repository.replaceRejected(current.id, id),
    );
  }
}
