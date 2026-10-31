import 'package:flutter/foundation.dart';
import 'package:socialdeck/design_system/index.dart';

class GameSetupState {
  final String gameSelection;
  final bool isCustom;
  final String holderText;
  final String playingWith;
  // IA: Keep structured group input separate from the legacy summary string.
  final List<String> groupCategories;
  final String otherGroup;
  // IA: Added entries are separate from the text currently being typed.
  final List<String> customGroups;
  final String groupDescription;

  // IA: Description alone is allowed. Selecting Other requires its own detail.
  bool get canContinueGroup =>
      (!groupCategories.contains('Other') ||
          (customGroups.isNotEmpty || otherGroup.trim().isNotEmpty)) &&
      (groupCategories.isNotEmpty || groupDescription.trim().isNotEmpty);
  // IA: Topics remain structured while the host edits this setup step.
  final List<String> selectedTopics;
  final String otherTopic;
  // IA: Added entries are separate from the text currently being typed.
  final List<String> customTopics;
  bool get canContinueTopics =>
      selectedTopics.isNotEmpty &&
      (!selectedTopics.contains('Other') ||
          (customTopics.isNotEmpty || otherTopic.trim().isNotEmpty));
  // IA: AI direction and optional age are draft values, separate from topics.
  final String styleLevel;
  final String averageAgeText;
  int? get averageAge => int.tryParse(averageAgeText.trim());
  bool get validAverageAge =>
      averageAgeText.trim().isEmpty ||
      (averageAge != null && averageAge! >= 0 && averageAge! <= 120);
  bool get canContinueStyle =>
      const ['light', 'bold', 'wild'].contains(styleLevel) && validAverageAge;
  final String gameMood;
  final String gameKeywords;
  final bool mixCards;
  final int rounds;
  final bool safeMode;
  final List<String>? examplePrompts;
  // IA: Only explicitly approved examples are shown in the saved lobby summary.
  final List<String> approvedExamples;
  // IA: Server-reviewed labels for exact approved texts; older examples have none.
  final Map<String, List<String>> approvedExampleTopics;
  final List<(String, SDeckChipColor)> playStyles;
  final bool loadingDatabase;

  const GameSetupState({
    this.gameSelection = "None",
    this.isCustom = false,
    this.holderText = "",
    this.playingWith = "",
    this.groupCategories = const [],
    this.otherGroup = "",
    this.customGroups = const [],
    this.groupDescription = "",
    this.selectedTopics = const [],
    this.otherTopic = "",
    this.customTopics = const [],
    this.styleLevel = "",
    this.averageAgeText = "",
    this.gameMood = "",
    this.gameKeywords = "",
    this.mixCards = false,
    this.rounds = 3,
    // IA: Every fresh/reset setup starts safe; the host can explicitly opt out.
    this.safeMode = true,
    this.examplePrompts,
    this.approvedExamples = const [],
    this.approvedExampleTopics = const {},
    this.playStyles = const [("Error", SDeckChipColor.brightCoral)],
    this.loadingDatabase = false,
  }); 

  GameSetupState copyWith({
    String? gameSelection,
    bool? isCustom,
    String? holderText,
    String? playingWith,
    List<String>? groupCategories,
    String? otherGroup,
    List<String>? customGroups,
    String? groupDescription,
    List<String>? selectedTopics,
    String? otherTopic,
    List<String>? customTopics,
    String? styleLevel,
    String? averageAgeText,
    String? gameMood,
    String? gameKeywords,
    bool? mixCards,
    int? rounds,
    bool? safeMode,
    List<String>? examplePrompts,
    List<String>? approvedExamples,
    Map<String, List<String>>? approvedExampleTopics,
    List<(String, SDeckChipColor)>? playStyles,
    bool? loadingDatabase,
  }) {
    return GameSetupState(
      gameSelection: gameSelection ?? this.gameSelection,
      isCustom: isCustom ?? this.isCustom,
      holderText: holderText ?? this.holderText,
      playingWith: playingWith ?? this.playingWith,
      groupCategories: groupCategories ?? this.groupCategories,
      otherGroup: otherGroup ?? this.otherGroup,
      customGroups: customGroups ?? this.customGroups,
      groupDescription: groupDescription ?? this.groupDescription,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      otherTopic: otherTopic ?? this.otherTopic,
      customTopics: customTopics ?? this.customTopics,
      styleLevel: styleLevel ?? this.styleLevel,
      averageAgeText: averageAgeText ?? this.averageAgeText,
      gameMood: gameMood ?? this.gameMood,
      gameKeywords: gameKeywords ?? this.gameKeywords,
      mixCards: mixCards ?? this.mixCards,
      rounds: rounds ?? this.rounds,
      safeMode: safeMode ?? this.safeMode,
      examplePrompts: examplePrompts ?? this.examplePrompts,
      approvedExamples: approvedExamples ?? this.approvedExamples,
      approvedExampleTopics:
          approvedExampleTopics ?? this.approvedExampleTopics,
      playStyles: playStyles ?? this.playStyles,
      loadingDatabase: loadingDatabase ?? this.loadingDatabase,
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
          listEquals(groupCategories, other.groupCategories) &&
          otherGroup == other.otherGroup &&
          listEquals(customGroups, other.customGroups) &&
          groupDescription == other.groupDescription &&
          listEquals(selectedTopics, other.selectedTopics) &&
          otherTopic == other.otherTopic &&
          listEquals(customTopics, other.customTopics) &&
          styleLevel == other.styleLevel &&
          averageAgeText == other.averageAgeText &&
          gameMood == other.gameMood &&
          gameKeywords == other.gameKeywords &&
          mixCards == other.mixCards &&
          rounds == other.rounds &&
          safeMode == other.safeMode &&
          examplePrompts == other.examplePrompts &&
          listEquals(approvedExamples, other.approvedExamples) &&
          mapEquals(approvedExampleTopics, other.approvedExampleTopics) &&
          playStyles == other.playStyles &&
          loadingDatabase == other.loadingDatabase;

  @override
  int get hashCode => Object.hashAll([
    gameSelection,
    isCustom,
    holderText,
    playingWith,
    Object.hashAll(groupCategories),
    otherGroup,
    Object.hashAll(customGroups),
    groupDescription,
    Object.hashAll(selectedTopics),
    otherTopic,
    Object.hashAll(customTopics),
    styleLevel,
    averageAgeText,
    gameMood,
    gameKeywords,
    mixCards,
    rounds,
    safeMode,
    examplePrompts,
    Object.hashAll(approvedExamples),
    playStyles,
    loadingDatabase,
  ]);
}
