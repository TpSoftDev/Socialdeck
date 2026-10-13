import 'games_include.dart';
import 'package:socialdeck/design_system/index.dart';



class GameSetupState {

  final GameChoice gameSelection;
  final bool isCustom;
  final String holderText;
  final String playingWith;
  final String gameMood;
  final String gameKeywords;
  final bool mixCards;
  final int rounds;
  final bool safeMode;
  final List<String> ? examplePrompts;
  final List<(String, SDeckChipColor)> playStyles;

  const GameSetupState({
    this.gameSelection = GameChoice.None,
    this.isCustom = false,
    this.holderText = "",
    this.playingWith = "",
    this.gameMood = "",
    this.gameKeywords = "",
    this.mixCards = false,
    this.rounds = 3,
    this.safeMode = false,
    this.examplePrompts,
    this.playStyles = const [("Error", SDeckChipColor.brightCoral)],
  }); 

  GameSetupState copyWith({
    GameChoice ? gameSelection,
    bool ? isCustom,
    String ? holderText,
    String ? playingWith,
    String ? gameMood,
    String ? gameKeywords,
    bool ? mixCards,
    int ? rounds,
    bool ? safeMode,
    List<String> ? examplePrompts,
    List<(String, SDeckChipColor)> ? playStyles,
  }) {
    return GameSetupState(
      gameSelection: gameSelection ?? this.gameSelection,
      isCustom: isCustom ?? this.isCustom,
      holderText: holderText ?? this.holderText,
      playingWith: playingWith ?? this.playingWith,
      gameMood: gameMood ?? this.gameMood,
      gameKeywords: gameKeywords ?? this.gameKeywords,
      mixCards: mixCards ?? this.mixCards,
      rounds: rounds ?? this.rounds,
      safeMode: safeMode ?? this.safeMode,
      examplePrompts: examplePrompts ?? this.examplePrompts,
      playStyles: playStyles ?? this.playStyles,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || 
    other is GameSetupState &&
      gameSelection == other.gameSelection &&
      isCustom == other.isCustom &&
      holderText == other.holderText &&
      playingWith == other.playingWith &&
      gameMood == other.gameMood &&
      gameKeywords == other.gameKeywords &&
      mixCards == other.mixCards &&
      rounds == other.rounds &&
      safeMode == other.safeMode &&
      examplePrompts == other.examplePrompts &&
      playStyles == other.playStyles;

  @override
  int get hashCode => Object.hash(
      gameSelection,
      isCustom,
      holderText,
      playingWith,
      gameMood,
      gameKeywords,
      mixCards,
      rounds,
      safeMode,
      examplePrompts,
      playStyles
    );
}