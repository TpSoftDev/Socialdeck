import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:socialdeck/features/games/domain/games_include.dart';
import '../domain/game_setup_state.dart';
import "../data/game_setup_repository.dart";
import "../data/mock_game_setup_repository.dart";

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

  Future<void> updateHolderText(String updateText) async {
    state = state.copyWith(holderText: updateText);
  }

  Future<void> updatePlayingWith(String ? groupPlayingWith) async {
    state = state.copyWith(playingWith: groupPlayingWith ?? state.holderText, holderText: "");
  }

  Future<void> updateMood(String ? mood) async {
    state = state.copyWith(gameMood: mood ?? state.holderText, holderText: "");
  }

  Future<void> updateKeywords() async {
    state = state.copyWith(gameKeywords: state.holderText, holderText: "");
  }

  Future<void> updateMixCards(bool mix) async {
    state = state.copyWith(mixCards: mix);
  }

  Future<void> updateRounds(int rounds) async {
    if (rounds < 1 || rounds > 5) return;
    state = state.copyWith(rounds: rounds);
  }

  Future<void> updateSafeMode(bool safe) async {
    state = state.copyWith(safeMode: safe);
  }

  Future<bool> generatePrompts() async {
    List<String> options = [state.playingWith, state.gameMood, state.gameKeywords];
    List<String> prompts = await _repository.generateExamplePrompts(options);
    state = state.copyWith(examplePrompts: prompts);
    return true;
  }

  Future<void> sendDislikeReason(int promptNumber) async {
    PromptFeedbackData data = PromptFeedbackData(promptNumber: promptNumber, promptFeedback: state.holderText);
    state = state.copyWith(holderText: "");

    _repository.reportFeedback(data);
  }

  Future<void> setPlayStyles() async {
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