import 'game_setup_repository.dart';
import 'dart:async';

class ConnectionsGameSetupRepository implements GameSetupRepository{

  Future<List<String>> generateExamplePrompts(List<String> options) async{
    //TODO
    List<String> Prompts = [""];
    return Prompts;
  }

  Future<void> reportFeedback(PromptFeedbackData data) async{
    //TODO
    Timer(const Duration(seconds: 3), () {});
  }

  Future<bool> createGame(GameSubmissionData data) async{
    //TODO
    return true;
  }
}