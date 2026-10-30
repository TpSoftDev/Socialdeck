
abstract class GameSetupRepository {

  //TODO: Ibrahim, return the 3 example prompts
  Future<List<String>> generateExamplePrompts(List<String> options);

  Future<bool> createGame(GameSubmissionData data);

  //TODO: Ibrahim, deal with the feedback data as needed on your side
  Future<void> reportFeedback(PromptFeedbackData data);
}

class GameSubmissionData {
  final String gameType;
  final int amountRounds;
  final String ? playingWith;
  final String ? mood;
  final String ? keywords;
  final bool ? safeMode;
  final bool ? mixCards;

  GameSubmissionData({
    required this.gameType,
    required this.amountRounds,
    this.playingWith,
    this.mood,
    this.keywords,
    this.safeMode,
    this.mixCards,
  });
}

class PromptFeedbackData {
  final int promptNumber;
  final String promptFeedback;

  PromptFeedbackData({
    required this.promptNumber,
    required this.promptFeedback
  });
}