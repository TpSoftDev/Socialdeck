import '../domain/game_setup_state.dart';
import '../domain/party_ai_setup.dart';
import '../domain/prompt_ai.dart';

// IA: Explicit schema avoids storing widget state, credentials or pending feedback.
class PartyAiSetupMapper {
  static Map<String, dynamic> encode(PartyAiSetup setup) {
    final d = setup.draft;
    return {
      'schemaVersion': 1,
      'revision': setup.revision,
      'sessionId': setup.sessionId,
      'settings': {
        'groups': d.groupCategories,
        'customGroups': d.customGroups,
        'description': d.groupDescription,
        'topics': d.selectedTopics,
        'customTopics': d.customTopics,
        'style': d.styleLevel,
        'averageAge': d.averageAge,
        'safeMode': d.safeMode,
        'rounds': d.rounds,
        'mixCards': d.mixCards,
      },
      'prompts': [
        for (final p in setup.prompts)
          {'id': p.id, 'text': p.text, 'topics': p.topics},
      ],
    };
  }

  static PartyAiSetup decode(Map<String, dynamic> data) {
    try {
      if (data['schemaVersion'] != 1) throw const FormatException();
      final s = Map<String, dynamic>.from(data['settings'] as Map);
      final prompts =
          (data['prompts'] as List)
              .map(
                (p) => AiPrompt(
                  p['id'] as String,
                  p['text'] as String,
                  List<String>.unmodifiable(p['topics'] as List),
                ),
              )
              .toList();
      if (prompts.length != 5 ||
          prompts.map((p) => p.id).toSet().length != 5 ||
          prompts.any((p) => p.text.trim().isEmpty)) {
        throw const FormatException();
      }
      final groups = List<String>.from(s['groups'] as List);
      final customGroups = List<String>.from(s['customGroups'] as List);
      final topics = List<String>.from(s['topics'] as List);
      final customTopics = List<String>.from(s['customTopics'] as List);
      final draft = GameSetupState(
        gameSelection: "Prompt'd",
        isCustom: true,
        groupCategories: groups,
        customGroups: customGroups,
        groupDescription: s['description'] as String,
        selectedTopics: topics,
        customTopics: customTopics,
        styleLevel: s['style'] as String,
        averageAgeText: s['averageAge']?.toString() ?? '',
        safeMode: s['safeMode'] as bool,
        rounds: s['rounds'] as int,
        mixCards: s['mixCards'] as bool,
        playingWith: groups
            .expand((g) => g == 'Other' ? customGroups : [g])
            .join(', '),
        gameMood: topics
            .expand((t) => t == 'Other' ? customTopics : [t])
            .join(', '),
        examplePrompts: prompts.map((p) => p.text).toList(),
        approvedExamples: prompts.map((p) => p.text).toList(),
        approvedExampleTopics: {for (final p in prompts) p.text: p.topics},
      );
      promptProfile(
        draft,
      ); // IA: Fail visibly on unsupported/malformed setup data.
      return PartyAiSetup(
        revision: data['revision'] as int,
        sessionId: data['sessionId'] as String,
        draft: draft,
        prompts: List.unmodifiable(prompts),
      );
    } catch (_) {
      throw const PromptAiException(
        'Saved AI setup could not be read. Ask the host to save it again.',
      );
    }
  }
}
