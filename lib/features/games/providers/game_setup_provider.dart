import 'package:socialdeck/shared/providers/auth_state_provider.dart';
import '../domain/prompt_ai.dart';
import '../data/firebase_prompt_ai_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';
import '../domain/game_setup_state.dart';
import "../data/game_setup_repository.dart";
import "../data/connections_game_setup_repository.dart";

class GameSetupNotifier extends StateNotifier<GameSetupState>{

  final GameSetupRepository _repository;

  final PromptAiFlow? _ai;
  GameSetupNotifier(this._repository, {PromptAiRepository? aiRepository})
    : _ai = aiRepository == null ? null : PromptAiFlow(aiRepository),
      super(const GameSetupState());

  PromptAiSession? get finalizedAiSession => aiReady ? _ai?.session : null;
  int get nextAiExample => _ai?.session?.nextUnreviewed ?? -1;
  bool get usesRealAi => _ai != null;
  // IA: Only rejected cards need generation; approved cards remain unchanged.
  int get rejectedAiExamples {
    final session = _ai?.session;
    return session == null
        ? 0
        : session.prompts.where((p) => session.feedback[p.id] == false).length;
  }

  bool get aiReady {
    if (_ai == null)
      return true; // IA: Explicit legacy mock repositories remain usable in tests.
    try {
      return _ai.session?.complete == true && _ai.matches(promptProfile(state));
    } catch (_) {
      return false;
    }
  }

  void _applyAi(PromptAiSession session) {
    if (!mounted) return;
    state = state.copyWith(
      examplePrompts: session.prompts.map((p) => p.text).toList(),
      approvedExamples: List.unmodifiable(session.approved),
      approvedExampleTopics: Map.unmodifiable({
        for (final p in session.prompts)
          if (session.feedback[p.id] == true)
            p.text: List<String>.unmodifiable(p.topics),
      }),
    );
  }

  Future<bool> finalizeExamples() async {
    if (_ai == null) return true;
    if (!_ai.matches(promptProfile(state)))
      throw const PromptAiException(
        'Setup changed. Update prompts before continuing.',
      );
    final session = await _ai.finish();
    _applyAi(session);
    return session.complete;
  }

  @override
  void dispose() {
    _ai?.reset();
    super.dispose();
  }

  Future<void> resetDomain() async {
    _ai?.reset();
    state = const GameSetupState();
  }

  Future<void> updateGame(String gameToPlay) async {
    state = state.copyWith(gameSelection: gameToPlay);
  }

  Future<void> updateAIUse(bool use) async {
    state =state.copyWith(isCustom: use);
  }

  Future<void> updateHolderText(String updateText) async {
    state = state.copyWith(holderText: updateText);
  }

  Future<void> updatePlayingWith(String? groupPlayingWith) async {
    state = state.copyWith(
      playingWith: groupPlayingWith ?? state.holderText,
      holderText: "",
    );
  }

  // IA: Multiple group choices stay in the draft until the user presses Next.
  void toggleGroupCategory(String category) {
    final categories = [...state.groupCategories];
    if (!categories.remove(category)) categories.add(category);
    state = state.copyWith(groupCategories: List.unmodifiable(categories));
  }

  void updateOtherGroup(String value) {
    state = state.copyWith(otherGroup: value);
  }

  void updateGroupDescription(String value) {
    state = state.copyWith(groupDescription: value);
  }

  // IA: Trim entries and ignore duplicates regardless of capitalization.
  void addOtherGroup() {
    final value = state.otherGroup.trim();
    if (value.isEmpty) return;
    final entries = [...state.customGroups];
    if (!entries.any((entry) => entry.toLowerCase() == value.toLowerCase())) {
      entries.add(value);
    }
    state = state.copyWith(
      customGroups: List.unmodifiable(entries),
      otherGroup: '',
    );
  }

  void removeOtherGroup(String value) {
    state = state.copyWith(
      customGroups: List.unmodifiable(
        state.customGroups.where((entry) => entry != value),
      ),
    );
  }

  bool confirmGroup() {
    if (!state.canContinueGroup) return false;
    // IA: Next also saves pending text so the last entry is not lost.
    if (state.groupCategories.contains('Other')) addOtherGroup();
    // IA: Keep the display summary alongside structured AI input.
    // Hidden Other text is excluded when that category has been deselected.
    final groups = state.groupCategories
        .map(
          (category) =>
              category == 'Other' ? state.customGroups.join(', ') : category,
        )
        .join(', ');
    state = state.copyWith(
      playingWith: [
        if (groups.isNotEmpty) groups,
        if (state.groupDescription.trim().isNotEmpty)
          state.groupDescription.trim(),
      ].join('. '),
    );
    return true;
  }

  // IA: Tapping topics only changes the draft; Next confirms the whole choice.
  void toggleTopic(String topic) {
    final topics = [...state.selectedTopics];
    if (!topics.remove(topic)) topics.add(topic);
    state = state.copyWith(selectedTopics: List.unmodifiable(topics));
  }

  void updateOtherTopic(String value) {
    state = state.copyWith(otherTopic: value);
  }

  // IA: Trim entries and ignore duplicates regardless of capitalization.
  void addOtherTopic() {
    final value = state.otherTopic.trim();
    if (value.isEmpty) return;
    final entries = [...state.customTopics];
    if (!entries.any((entry) => entry.toLowerCase() == value.toLowerCase())) {
      entries.add(value);
    }
    state = state.copyWith(
      customTopics: List.unmodifiable(entries),
      otherTopic: '',
    );
  }

  void removeOtherTopic(String value) {
    state = state.copyWith(
      customTopics: List.unmodifiable(
        state.customTopics.where((entry) => entry != value),
      ),
    );
  }

  bool confirmTopics() {
    if (!state.canContinueTopics) return false;
    // IA: Next also saves pending text so the last entry is not lost.
    if (state.selectedTopics.contains('Other')) addOtherTopic();
    // IA: Keep the existing repository's mood slot compatible for now.
    // AI mapping uses structured topics; deselected Other is excluded.
    state = state.copyWith(
      gameMood: state.selectedTopics
          .map(
            (topic) => topic == 'Other' ? state.customTopics.join(', ') : topic,
          )
          .join(', '),
    );
    return true;
  }

  // IA: Store the chosen AI direction without changing topic selections.
  void updateStyleLevel(String value) {
    if (!const ['light', 'bold', 'wild'].contains(value)) return;
    state = state.copyWith(styleLevel: value);
  }

  void updateAverageAge(String value) {
    state = state.copyWith(averageAgeText: value);
  }

  Future<void> updateMood(String? mood) async {
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
    if (_ai != null) {
      final session = await _ai.generate(promptProfile(state));
      _applyAi(session);
      return true;
    }
    List<String> options = [
      state.playingWith,
      state.gameMood,
      state.gameKeywords,
    ];
    List<String> prompts = await _repository.generateExamplePrompts(options);
    state = state.copyWith(
      examplePrompts: prompts,
      approvedExamples: const [],
      approvedExampleTopics: const {},
    );
    return true;
  }

  // IA: A checkmark approves this exact text. Viewing the summary never generates.
  Future<void> approveExample(int index) async {
    if (_ai != null) {
      _applyAi(await _ai.vote(index, true, const [], ''));
      return;
    }
    final prompts = state.examplePrompts ?? const <String>[];
    if (index < 0 || index >= prompts.length) return;
    final prompt = prompts[index];
    if (state.approvedExamples.contains(prompt)) return;
    state = state.copyWith(
      approvedExamples: List.unmodifiable([...state.approvedExamples, prompt]),
    );
  }

  // IA: Structured reason IDs and custom notes reach the same calibration used by web.
  Future<void> rejectExample(
    int index,
    List<String> labels,
    List<String> custom,
  ) async {
    final explanation = labels.contains('Other') ? custom.join('; ') : '';
    if (_ai != null) {
      final reasons = labels.map((label) => aiReasonIds[label]!).toList();
      _applyAi(await _ai.vote(index, false, reasons, explanation));
    } else {
      await _repository.reportFeedback(
        PromptFeedbackData(
          promptNumber: index + 1,
          promptFeedback: labels
              .expand((label) => label == 'Other' ? custom : [label])
              .join('; '),
        ),
      );
    }
  }

  Future<void> sendDislikeReason(int promptNumber) async {
    final feedback = state.holderText;
    if (_ai != null) {
      _applyAi(
        await _ai.vote(promptNumber - 1, false, const ['other'], feedback),
      );
    } else {
      await _repository.reportFeedback(
        PromptFeedbackData(
          promptNumber: promptNumber,
          promptFeedback: feedback,
        ),
      );
    }
    if (mounted) state = state.copyWith(holderText: '');
  }

  Future<void> setPlayStyles() async {
    List<(String, SDeckChipColor)> playStyles = [
      (state.playingWith, SDeckChipColor.tangerine),
      (state.gameMood, SDeckChipColor.mintGreen),
      (state.gameKeywords, SDeckChipColor.vibrantYellow),
    ];
    state = state.copyWith(playStyles: playStyles);
  }

  Future<bool> createGameLobby() async {
    state = state.copyWith(loadingDatabase: true);
    GameSubmissionData data = GameSubmissionData(
      gameType: state.gameSelection,
      amountRounds: state.rounds,
      playingWith: state.playingWith,
      mood: state.gameMood,
      keywords: state.gameKeywords,
      safeMode: state.safeMode,
      mixCards: state.mixCards,
    );
    //TODO: use success to indicate game upload
    return await _repository.createGame(data);
  }
}

final gameSetupProvider = StateNotifierProvider<
  GameSetupNotifier,
  GameSetupState
>((ref) {
  // IA: Switching accounts discards the previous owner's AI session and pending requests.
  ref.watch(currentUserProvider.select((user) => user?.uid));
  final ai = FirebasePromptAiRepository();
  ref.onDispose(ai.dispose);
  // IA: Production always uses the real adapter; samples exist only in explicit test mocks.
  return GameSetupNotifier(ConnectionsGameSetupRepository(), aiRepository: ai);
  // IA: Account-scoped overrides must also scope their dependent setup state.
}, dependencies: [currentUserProvider]);
