import 'games_include.dart';



class GameSetupState {

  final GameChoice gameSelection;
  final bool isCustom;
  final String playingWith;
  final String gameMood;
  final List<String> ? examplePrompts;

  const GameSetupState({
    this.gameSelection = GameChoice.None,
    this.isCustom = false,
    this.playingWith = "",
    this.gameMood = "",
    this.examplePrompts,
  }); 

  GameSetupState copyWith({
    GameChoice ? gameSelection,
    bool ? isCustom,
    String ? playingWith,
    String ? gameMood,
    List<String> ? examplePrompts,
  }) {
    return GameSetupState(
      gameSelection: gameSelection ?? this.gameSelection,
      isCustom: isCustom ?? this.isCustom,
      playingWith: playingWith ?? this.playingWith,
      gameMood: gameMood ?? this.gameMood,
      examplePrompts: examplePrompts ?? this.examplePrompts,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) || 
    other is GameSetupState &&
      gameSelection == other.gameSelection &&
      isCustom == other.isCustom &&
      playingWith == other.playingWith &&
      gameMood == other.gameMood &&
      examplePrompts == other.examplePrompts;

  @override
  int get hashCode => Object.hash(
      gameSelection,
      isCustom,
      playingWith,
      gameMood,
      examplePrompts
    );
}