import '../domain/games_include.dart';

abstract class GameSetupRepository {

  //TODO: Ibrahim, return the 3 example prompts
  Future<List<String>> generateExamplePrompts(List<String> options);

  Future<bool> createGame(GameSubmissionData data);

  //TODO: Ibrahim, deal with the feedback data as needed on your side
  Future<void> reportFeedback(PromptFeedbackData data);
}

class GameSubmissionData {
  final GameChoice gameType;
  final int amountRounds;
  final String ? playingWith;
  final String ? mood;
  final String host;

  GameSubmissionData({
    required this.gameType,
    required this.amountRounds,
    this.playingWith,
    this.mood,
    required this.host
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