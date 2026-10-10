import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/features/games/domain/games_include.dart';
import '../domain/game_setup_state.dart';
import "../data/game_setup_repository.dart";
import "../data/mock_game_setup_repository.dart";
import 'package:socialdeck/design_system/index.dart';

class GameSetupNotifier extends StateNotifier<GameSetupState>{

  final GameSetupRepository _repository;

  GameSetupNotifier(this._repository) : super(const GameSetupState());

  Future<void> resetDomain() async {
    state = const GameSetupState();
  }

  Future<void> updateGame(GameChoice gameToPlay) async {
    state = state.copyWith(gameSelection: gameToPlay);
  }

  Future<void> updateAIUse(bool use) async {
    state =state.copyWith(isCustom: use);
  }

  Future<void> updatePlayingWith(String groupPlayingWith) async {
    state = state.copyWith(playingWith: groupPlayingWith);
  }

  Future<void> updateMood(String mood) async {
    state = state.copyWith(gameMood: mood);
  }

  Future<void> updateKeywords(String keywords) async {
    state = state.copyWith(gameKeywords: keywords);
  }

  Future<bool> generatePrompts() async {
    List<String> options = [state.playingWith, state.gameMood, state.gameKeywords];
    List<String> prompts = await _repository.generateExamplePrompts(options);
    state = state.copyWith(examplePrompts: prompts);
    return true;
  }

  Future<void> sendDislikeReason(int promptNumber, String reason) async {
    PromptFeedbackData data = PromptFeedbackData(promptNumber: promptNumber, promptFeedback: reason);

    _repository.reportFeedback(data);
  }

  void setPlayStyles() {
    List<(String, SDeckChipColor)> playStyles = [
      (state.playingWith, SDeckChipColor.tangerine),
      (state.gameMood, SDeckChipColor.mintGreen),
      (state.gameKeywords, SDeckChipColor.vibrantYellow)
    ];
    state = state.copyWith(playStyles: playStyles);
  }
}

final gameSetupProvider= StateNotifierProvider<GameSetupNotifier, GameSetupState>
  ((ref) => GameSetupNotifier(MockGameSetupRepository()));