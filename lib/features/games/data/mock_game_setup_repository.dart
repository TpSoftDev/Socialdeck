import 'game_setup_repository.dart';
import 'dart:async';

class MockGameSetupRepository implements GameSetupRepository {
  Future<List<String>> generateExamplePrompts(List<String> options) async {
    // IA: Five fixed preview samples until the real AI endpoint is connected.
    List<String> Prompts = [
      "The face you make when the investor says 'let's circle back'",
      "POV: you just found out your co-founder used the last of the office snacks... on a Tuesday",
      "This is fine (it is not fine)",
      "When the group chat turns a simple plan into a full debate",
      "The look you give when someone says one more round",
    ];
    return Prompts;
  }

  Future<void> reportFeedback(PromptFeedbackData data) async{
    Timer(const Duration(seconds: 3), () {});
  }

  Future<bool> createGame(GameSubmissionData data) async{
    Timer(const Duration(seconds: 3), () {});
    return true;
  }
}