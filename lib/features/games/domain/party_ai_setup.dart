import 'game_setup_state.dart';
import 'prompt_ai.dart';

// IA: Finalized shared result, not the host's temporary questionnaire draft.
class PartyAiSetup {
  final int revision;
  final String sessionId;
  final GameSetupState draft;
  final List<AiPrompt> prompts;
  const PartyAiSetup({
    required this.revision,
    required this.sessionId,
    required this.draft,
    required this.prompts,
  });
}

abstract class PartyAiSetupRepository {
  Stream<PartyAiSetup?> watch(String partyId);
  Future<PartyAiSetup> save(
    String partyId,
    int expectedRevision,
    GameSetupState draft,
    PromptAiSession session,
  );
}
