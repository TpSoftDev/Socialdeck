/*-------------------- prompt_custom_setup_page.dart -----------------------*/
// Prompt'd Custom Setup questionnaire (steps 1–4/5), generating,
// example review, finalizing, and complete.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

import '../../providers/game_setup_provider.dart';
import 'prompt_settings_page.dart'
    show PromptSettingsToggle, PromptSettingsPage;

//------------------------------- PromptCustomSetupPage -----------------------------//
class PromptCustomSetupPage extends ConsumerStatefulWidget {
  const PromptCustomSetupPage({super.key, this.onConfirmed});
  // IA: Settings edits return to their caller instead of restarting setup.
  final VoidCallback? onConfirmed;

  @override
  ConsumerState<PromptCustomSetupPage> createState() => _PromptCustomSetupState();
}

class _PromptCustomSetupState extends ConsumerState<PromptCustomSetupPage> {
  late final TextEditingController _other;
  late final TextEditingController _description;
  bool _showDescription = false;
  static const _options = [
    'Friends',
    'Family',
    'Mutuals',
    'Coworkers',
    'Classmates',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(gameSetupProvider);
    _other = TextEditingController(text: draft.otherGroup);
    _description = TextEditingController(text: draft.groupDescription);
    _showDescription = draft.groupDescription.isNotEmpty;
  }

  @override
  void dispose() {
    _other.dispose();
    _description.dispose();
    super.dispose();
  }

  void _next() {
    if (!ref.read(gameSetupProvider.notifier).confirmGroup()) return;
    if (widget.onConfirmed != null) {
      widget.onConfirmed!();
      return;
    }
    _other.text = ref.read(gameSetupProvider).otherGroup;
    FocusScope.of(context).unfocus();
    // IA: Keep this step on the normal navigation stack so Back preserves input.
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PromptCustomSetupMoodPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(gameSetupProvider);
    final actions = ref.read(gameSetupProvider.notifier);
    return _PromptCustomSetupScaffold(
      question: 'Who are you playing with?',
      // IA: Frontend shell placeholder built from existing team components.
      // Frontend team: confirm composition against Figma; keep the wired logic.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IA: Use the team's readable secondary color for helper text.
          Text(
            'Add multiple categories if necessary.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.component.textSecondary,
            ),
          ),
          const SizedBox(height: SDeckSpace.padding16),
          // IA: Reuse the team's original chip layout and SDeck buttons.
          // Selected choices use the existing solid variant; no new chip styling.
          _ChipWrap(
            options: _options.take(3).toList(),
            selected: draft.groupCategories,
            keyPrefix: 'group',
            singleRow: true,
            onSelected: actions.toggleGroupCategory,
          ),
          const SizedBox(height: SDeckSpace.gap6),
          _ChipWrap(
            options: _options.skip(3).toList(),
            selected: draft.groupCategories,
            keyPrefix: 'group',
            singleRow: true,
            onSelected: actions.toggleGroupCategory,
          ),
          if (draft.groupCategories.contains('Other')) ...[
            const SizedBox(height: SDeckSpace.gap12),
            _OtherEntries(
              prefix: 'group',
              controller: _other,
              entries: draft.customGroups,
              placeholder: 'Enter a group/setting',
              onChanged: actions.updateOtherGroup,
              onAdd: () {
                actions.addOtherGroup();
                _other.clear();
              },
              onRemove: actions.removeOtherGroup,
            ),
          ],
          const SizedBox(height: SDeckSpace.gap12),
          SDeckOutlineButton(
            size: SDeckButtonSize.small,
            key: const ValueKey('group-description-toggle'),
            fullWidth: true,
            onPressed:
                () => setState(() => _showDescription = !_showDescription),
            text:
                '${_showDescription ? '−' : '+'} Describe your group (optional)',
          ),
          if (_showDescription)
            SDeckInput(
              key: const ValueKey('group-description-input'),
              state: SDeckInputState.hint,
              label: 'Describe your group (optional)',
              // IA: Smaller example hint; typed answers retain the shared input style.
              placeholderStyle: Theme.of(context).textTheme.bodySmall,
              placeholder:
                  'We’re college friends who enjoy gaming and sarcastic jokes.',
              supportingText:
                  'Tell us about your group’s interests, shared experiences, or sense of humor.',
              controller: _description,
              maxLength: 500,
              onChanged: actions.updateGroupDescription,
            ),
          const SizedBox(height: SDeckSpace.padding16),
          SDeckSolidButton(
            key: const ValueKey('group-next'),
            text: 'Next',
            size: SDeckButtonSize.large,
            fullWidth: true,
            enabled: draft.canContinueGroup,
            onPressed: draft.canContinueGroup ? _next : null,
          ),
        ],
      ),
    );
  }
}

//------------------------------- PromptCustomSetupOtherPage -----------------------------//
/// Other follow-up: labeled input + Next. Back pops to the chip list.
class PromptCustomSetupOtherPage extends ConsumerStatefulWidget {
  const PromptCustomSetupOtherPage({super.key});

  @override
  ConsumerState<PromptCustomSetupOtherPage> createState() => _PromptCustomSetupOtherState();
}

class _PromptCustomSetupOtherState extends ConsumerState<PromptCustomSetupOtherPage>{

  _handleOther(){
    ref.read(gameSetupProvider.notifier).updatePlayingWith(null);
  }

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      question: 'Who are you playing with?',
      child: _SetupEnvironment(
        placeholder: 'Enter a group/setting',
        onNext: () {
          _handleOther();
          print("Here");
          context.push(AppPaths.promptCustomSetupMoodDev);
        },
      ),
    );
  }
}

//------------------------------- PromptCustomSetupMoodPage -----------------------------//
/// Question 2/5. Back returns to the previous environment step.
class PromptCustomSetupMoodPage extends ConsumerStatefulWidget {
  const PromptCustomSetupMoodPage({super.key, this.onConfirmed});
  // IA: Settings edits return to their caller instead of restarting setup.
  final VoidCallback? onConfirmed;

  @override
  ConsumerState<PromptCustomSetupMoodPage> createState() => _PromptCustomSetupMoodStage();
}

// IA: Retain the existing route/class name; step two now collects topics.
class _PromptCustomSetupMoodStage
    extends ConsumerState<PromptCustomSetupMoodPage> {
  late final TextEditingController _other;
  static const _rows = [
    // IA: Similar-length topics share compact rows; Other stays last.
    ['Fitness', 'Memes', 'Pets'],
    ['Group Chat', 'School Life', 'Work Life'],
    ['Epic Fails', 'Party Night', 'Social Media'],
    ['Relationships', 'Family Moments'],
    ['Throwbacks', 'Other'],
  ];

  @override
  void initState() {
    super.initState();
    _other = TextEditingController(
      text: ref.read(gameSetupProvider).otherTopic,
    );
  }

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  void _next() {
    if (!ref.read(gameSetupProvider.notifier).confirmTopics()) return;
    if (widget.onConfirmed != null) {
      widget.onConfirmed!();
      return;
    }
    _other.text = ref.read(gameSetupProvider).otherTopic;
    FocusScope.of(context).unfocus();
    // IA: Normal navigation preserves the topic draft when returning with Back.
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PromptCustomSetupIntensityPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(gameSetupProvider);
    final actions = ref.read(gameSetupProvider.notifier);
    return _PromptCustomSetupScaffold(
      current: 2,
      question: 'What topics do you want to see?',
      // IA: Frontend shell placeholder using the team's existing controls.
      // Frontend team: finalize artwork/spacing; retain multi-select validation.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add multiple categories if necessary.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.component.textSecondary,
            ),
          ),
          const SizedBox(height: SDeckSpace.padding16),
          // IA: Three short labels per row; longer labels get a two-choice row.
          for (final row in _rows) ...[
            _ChipWrap(
              options: row,
              selected: draft.selectedTopics,
              keyPrefix: 'topic',
              singleRow: true,
              onSelected: actions.toggleTopic,
            ),
            const SizedBox(height: SDeckSpace.gap6),
          ],
          if (draft.selectedTopics.contains('Other')) ...[
            const SizedBox(height: SDeckSpace.gap12),
            _OtherEntries(
              prefix: 'topic',
              controller: _other,
              entries: draft.customTopics,
              placeholder: 'Enter a topic',
              onChanged: actions.updateOtherTopic,
              onAdd: () {
                actions.addOtherTopic();
                _other.clear();
              },
              onRemove: actions.removeOtherTopic,
            ),
          ],
          const SizedBox(height: SDeckSpace.padding16),
          SDeckSolidButton(
            key: const ValueKey('topic-next'),
            text: 'Next',
            size: SDeckButtonSize.large,
            fullWidth: true,
            enabled: draft.canContinueTopics,
            onPressed: draft.canContinueTopics ? _next : null,
          ),
        ],
      ),
    );
  }
}

//------------------------------- PromptCustomSetupMoodOtherPage -----------------------------//
/// Mood Other follow-up: labeled input + Next. Back pops to the mood chips.
class PromptCustomSetupMoodOtherPage extends ConsumerStatefulWidget {
  const PromptCustomSetupMoodOtherPage({super.key});

  @override
  ConsumerState<PromptCustomSetupMoodOtherPage> createState() => _PromptCustomSetupMoodOtherState();
}


class _PromptCustomSetupMoodOtherState extends ConsumerState<PromptCustomSetupMoodOtherPage>{

  void _setGameMood(){
    ref.read(gameSetupProvider.notifier).updateMood(null);
  }

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 2,
      question: 'What is the mood?',
      child: _SetupEnvironment(
        placeholder: 'Enter a mood/vibe',
        onNext: () { 
          _setGameMood();
          context.push(AppPaths.promptCustomSetupKeywordsDev);
        },
      ),
    );
  }
}

// IA: Topics Next opens this normal setup step; the existing keywords step follows.
class PromptCustomSetupIntensityPage extends ConsumerStatefulWidget {
  const PromptCustomSetupIntensityPage({super.key, this.onConfirmed});
  // IA: Settings edits return to their caller instead of restarting setup.
  final VoidCallback? onConfirmed;
  @override
  ConsumerState<PromptCustomSetupIntensityPage> createState() =>
      _IntensityState();
}

class _IntensityState extends ConsumerState<PromptCustomSetupIntensityPage> {
  late final TextEditingController _age;
  // IA: Keep the requested SFW/NSFW labels; style never overrides Safe Mode.
  static const _styles = [
    ('light', 'Light (SFW)', 'Prompts are clean and light.'),
    ('bold', 'Bold', 'Adds some spice to the prompts.'),
    ('wild', 'Wild (NSFW)', 'Be prepared for anything.'),
  ];
  @override
  void initState() {
    super.initState();
    _age = TextEditingController(
      text: ref.read(gameSetupProvider).averageAgeText,
    );
  }

  @override
  void dispose() {
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(gameSetupProvider);
    final actions = ref.read(gameSetupProvider.notifier);
    return _PromptCustomSetupScaffold(
      current: 3,
      question: 'How far should we go?',
      // IA: Frontend shell: reuse app cards and the exact existing settings switch.
      // Frontend team: finalize selected-card styling and artwork.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final style in _styles) ...[
            Semantics(
              selected: draft.styleLevel == style.$1,
              child: Stack(
                children: [
                  SDeckSelectionTargetCard(
                    key: ValueKey('style-${style.$1}'),
                    title: style.$2,
                    description: style.$3,
                    background: const SDeckVisualPlaceholder(),
                    onTap: () => actions.updateStyleLevel(style.$1),
                  ),
                  if (draft.styleLevel == style.$1)
                    const Positioned(
                      right: 8,
                      top: 8,
                      child: IgnorePointer(
                        child: Icon(Icons.check_circle, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: SDeckSpace.gap8),
          ],
          const SizedBox(height: SDeckSpace.padding16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safe Mode',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Scan and remove explicit/NSFW content.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'Safe Mode',
                toggled: draft.safeMode,
                child: PromptSettingsToggle(
                  key: const ValueKey('style-safe-mode'),
                  value: draft.safeMode,
                  onChanged: actions.updateSafeMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: SDeckSpace.padding16),
          // IA: Keep the compact age row, with a small explanation underneath.
          // Frontend shell reuses the existing input and text styles.
          Row(
            children: [
              Expanded(
                child: Text(
                  'Average group age (optional)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: SDeckSpace.gap8),
              SizedBox(
                width: 112,
                child: Semantics(
                  label: 'Average group age, optional',
                  child: SDeckInput(
                    key: const ValueKey('style-age'),
                    placeholder: 'Not sure',
                    placeholderStyle: Theme.of(context).textTheme.bodySmall,
                    controller: _age,
                    keyboardType: TextInputType.number,
                    state:
                        draft.validAverageAge
                            ? SDeckInputState.hint
                            : SDeckInputState.error,
                    onChanged: actions.updateAverageAge,
                  ),
                ),
              ),
            ],
          ),
          if (draft.validAverageAge)
            Padding(
              padding: const EdgeInsets.only(top: SDeckSpace.gap4),
              child: Text(
                'Leave blank if unsure. Age helps guide references and humor.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.component.textSecondary,
                ),
              ),
            ),
          if (!draft.validAverageAge)
            Padding(
              padding: const EdgeInsets.only(top: SDeckSpace.gap4),
              child: Text(
                'Enter a whole number from 0 to 120, or leave blank.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: SDeckSpace.padding16),
          SDeckSolidButton(
            key: const ValueKey('style-next'),
            text: 'Next',
            size: SDeckButtonSize.large,
            fullWidth: true,
            enabled: draft.canContinueStyle,
            onPressed:
                draft.canContinueStyle
                    ? () {
                      if (!ref.read(gameSetupProvider).canContinueStyle) return;
                      if (widget.onConfirmed != null) {
                        widget.onConfirmed!();
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      // IA: Keep draft data on Back. AI payload mapping is separate work.
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder:
                              (_) => const PromptCustomSetupGeneratingPage(),
                        ),
                      );
                    }
                    : null,
          ),
        ],
      ),
    );
  }
}

//------------------------------- PromptCustomSetupKeywordsPage -----------------------------//
/// Question 4/5. Keywords input + Next. Back returns to the intensity step.
class PromptCustomSetupKeywordsPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupKeywordsPage({super.key});

  @override
  ConsumerState<PromptCustomSetupKeywordsPage> createState() => _PromptCustomSetupKeywordsState();
}

//_classNameState
class _PromptCustomSetupKeywordsState extends ConsumerState<PromptCustomSetupKeywordsPage>{

  void _setGameKeywords(){
    ref.read(gameSetupProvider.notifier).updateKeywords();
  }

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 4,
      question: 'Include any keywords & topics?',
      child: _SetupEnvironment(
        label: 'Keywords & Topics',
        placeholder: 'Enter one/many things',
        supportingText:
            'Use descriptive words or sentences to get more accurate and creative results.',
        onNext: () { 
          _setGameKeywords();
          context.push(AppPaths.promptCustomSetupGeneratingDev);
        },
      ),
    );
  }
}

//------------------------------- PromptCustomSetupGeneratingPage -----------------------------//
/// Loading beat after keywords. Fades in, holds, then fades to example 1.
// IA: Normal setup skips the old keywords page and waits for the repository.
class PromptCustomSetupGeneratingPage extends ConsumerStatefulWidget {
  const PromptCustomSetupGeneratingPage({super.key});
  @override
  ConsumerState<PromptCustomSetupGeneratingPage> createState() =>
      _GeneratingState();
}

class _GeneratingState extends ConsumerState<PromptCustomSetupGeneratingPage> {
  String? _error;
  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    try {
      // IA: Keep loading visible while the real server generates/reviews examples.
      // Run the minimum display time alongside generation, not after it.
      await Future.wait([
        ref.read(gameSetupProvider.notifier).generatePrompts(),
        Future<void>.delayed(const Duration(milliseconds: 1500)),
      ]);
      if (!mounted) return;
      final prompts = ref.read(gameSetupProvider).examplePrompts;
      // IA: Never enter a five-example review with missing/blank prompts.
      if (prompts == null ||
          prompts.length < 5 ||
          prompts.take(5).any((p) => p.trim().isEmpty)) {
        throw StateError('Five examples are required');
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const PromptCustomSetupReviewPage(),
        ),
      );
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) =>
      _error != null
          ? _PromptCustomSetupScaffold(
            current: 4,
            question: _error!,
            child: SDeckSolidButton(
              text: 'Try again',
              fullWidth: true,
              onPressed: () {
                setState(() => _error = null);
                _generate();
              },
            ),
          )
          : const _PromptStatusPage(
            status: 'Generating example prompts...',
            logoOnly: true,
          );
}

// IA: Same team review layout, but votes now wait for server acknowledgement.
// Frontend shell TODO: replace checkerboard artwork with approved Rive animation.
class PromptCustomSetupReviewPage extends ConsumerStatefulWidget {
  const PromptCustomSetupReviewPage({super.key});
  @override
  ConsumerState<PromptCustomSetupReviewPage> createState() => _ReviewState();
}

class _ReviewState extends ConsumerState<PromptCustomSetupReviewPage> {
  int _index = 0;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    final next = ref.read(gameSetupProvider.notifier).nextAiExample;
    if (next >= 0) _index = next;
  }

  void _next() {
    final notifier = ref.read(gameSetupProvider.notifier);
    final next =
        notifier.usesRealAi
            ? notifier.nextAiExample
            : (_index < 4 ? _index + 1 : -1);
    if (next >= 0) {
      setState(() => _index = next);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const PromptCustomSetupFinishingPage(),
      ),
    );
  }

  Future<void> _like() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(gameSetupProvider.notifier).approveExample(_index);
      if (mounted) _next();
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompts =
        ref.watch(gameSetupProvider).examplePrompts ?? const <String>[];
    if (prompts.length < 5)
      return const _PromptStatusPage(
        status: 'Examples are unavailable. Go back and try again.',
      );
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: _busy,
          child: _ExamplePromptPage(
            question: 'How does this example look?',
            counter: 'Example ${_index + 1} of 5',
            prompt: prompts[_index],
            onLike: _like,
            onDislike: () async {
              if (_busy) return;
              final submitted = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder:
                      (reasonContext) => _ExamplePromptEditPage(
                        prompt: prompts[_index],
                        onSubmit: (labels, custom) async {
                          await ref
                              .read(gameSetupProvider.notifier)
                              .rejectExample(_index, labels, custom);
                          if (reasonContext.mounted)
                            Navigator.of(reasonContext).pop(true);
                        },
                      ),
                ),
              );
              if (mounted && submitted == true) _next();
            },
          ),
        ),
        if (_busy)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

// IA: Completion means five accepted server cards, never just an elapsed timer.
class PromptCustomSetupFinishingPage extends ConsumerStatefulWidget {
  const PromptCustomSetupFinishingPage({super.key});
  @override
  ConsumerState<PromptCustomSetupFinishingPage> createState() =>
      _FinishingState();
}

class _FinishingState extends ConsumerState<PromptCustomSetupFinishingPage> {
  Timer? _timer;
  bool _complete = false;
  int _replacing = 0;
  String? _error;
  @override
  void initState() {
    super.initState();
    // IA: Snapshot the rejected count before the response replaces those cards.
    // Frontend shell: reuse the approved generating layout/artwork placeholder.
    _replacing = ref.read(gameSetupProvider.notifier).rejectedAiExamples;
    _finish();
  }

  Future<void> _finish() async {
    try {
      final done =
          await ref.read(gameSetupProvider.notifier).finalizeExamples();
      if (!mounted) return;
      if (!done) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => const PromptCustomSetupReviewPage(),
          ),
        );
        return;
      }
      // IA: Only after all five are approved, reserve two seconds for each
      // animation shell. Frontend will replace the placeholders with Rive.
      setState(() => _replacing = 0);
      _timer = Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _complete = true);
        _timer = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const PromptSettingsPage()),
          );
        });
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _error != null
          ? _PromptCustomSetupScaffold(
            current: 5,
            question: _error!,
            child: SDeckSolidButton(
              text: _replacing > 0 ? 'Retry replacements' : 'Try again',
              fullWidth: true,
              onPressed: () {
                setState(() => _error = null);
                _finish();
              },
            ),
          )
          : _PromptStatusPage(
            status:
                _complete
                    ? 'Complete!'
                    : _replacing > 0
                    ? 'Generating $_replacing replacement ${_replacing == 1 ? 'example' : 'examples'}...\n\nYour approved examples stay unchanged.'
                    : 'Finalizing prompts...',
            logoOnly: true,
            aspectRatio: _complete ? 1 : 370 / 185,
          );
}

//------------------------------- _PromptStatusPage -----------------------------//
/// Figma generating / finalizing / complete: placeholder + body-large status.
/// IA: Status display only; the owning generation/finalization page controls timing.
class _PromptStatusPage extends StatelessWidget {
  const _PromptStatusPage({
    required this.status,
    this.logoOnly = false,
    this.aspectRatio = 370 / 185,
  });

  final bool logoOnly;
  final String status;
  final double aspectRatio;
  final SDeckTopBarLeft left = SDeckTopBarLeft.back;
  final SDeckTopBarRight right = SDeckTopBarRight.icon;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            // IA: Generating uses the reference's logo-only header; other status pages keep theirs.
            if (logoOnly)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SDeckSpace.padding16,
                ),
                child: Image.asset(
                  SDeckIcon.promptdSticker,
                  width: 133.953,
                  height: SDeckSize.size48,
                ),
              )
            else
              _CustomSetupTopBar(left: left, right: right),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: SDeckSpace.margin16,
                  right: SDeckSpace.margin16,
                  bottom: SDeckSpace.margin16,
                ),
                child: Column(
                  spacing: SDeckSpace.gap24,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: aspectRatio,
                      child: SDeckVisualPlaceholder(
                        borderRadius: BorderRadius.circular(
                          SDeckRadius.borderRadius16,
                        ),
                      ),
                    ),
                    Text(
                      status,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.component.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------- PromptCustomSetupExamplePage -----------------------------//
/// Example 1/3. Check → example 2. X → reason, then example 2.
class PromptCustomSetupExamplePage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupExamplePage({super.key});

  @override
  ConsumerState<PromptCustomSetupExamplePage> createState() => _PromptCustomSetupExampleState();
}

//_classNameState
class _PromptCustomSetupExampleState extends ConsumerState<PromptCustomSetupExamplePage>{

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);

    return _ExamplePromptPage(
      question: 'How does this example look?',
      prompt: state.examplePrompts?.elementAt(0) ?? "Error Occured",
      onLike: () => context.push(AppPaths.promptCustomSetupExample2Dev),
      onDislike: () => context.push(AppPaths.promptCustomSetupExampleEditDev),
    );
  }
}

//------------------------------- PromptCustomSetupExampleEditPage -----------------------------//
class PromptCustomSetupExampleEditPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupExampleEditPage({super.key});

  @override
  ConsumerState<PromptCustomSetupExampleEditPage> createState() => _PromptCustomSetupExampleEditState();
}

//_classNameState
class _PromptCustomSetupExampleEditState extends ConsumerState<PromptCustomSetupExampleEditPage>{

  Future<void> _sendReason() async {
    ref.read(gameSetupProvider.notifier).sendDislikeReason(1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);

    return _ExamplePromptEditPage(
      prompt: state.examplePrompts?.elementAt(0) ?? "Error Occured",
      onNext: () {
        _sendReason();
        context.push(AppPaths.promptCustomSetupExample2Dev);
        },
    );
  }
}

//------------------------------- PromptCustomSetupExample2Page -----------------------------//
/// Example 2/3. Check → example 3. X → reason, then example 3.
class PromptCustomSetupExample2Page extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupExample2Page({super.key});

  @override
  ConsumerState<PromptCustomSetupExample2Page> createState() => _PromptCustomSetupExample2State();
}

//_classNameState
class _PromptCustomSetupExample2State extends ConsumerState<PromptCustomSetupExample2Page>{

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);

    return _ExamplePromptPage(
      question: 'Now what about this one?',
      prompt: state.examplePrompts?.elementAt(1) ?? "Error Occured",
      onLike: () => context.push(AppPaths.promptCustomSetupExample3Dev),
      onDislike: () =>
          context.push(AppPaths.promptCustomSetupExample2EditDev),
    );
  }
}

//------------------------------- PromptCustomSetupExample2EditPage -----------------------------//
class PromptCustomSetupExample2EditPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupExample2EditPage({super.key});

  @override
  ConsumerState<PromptCustomSetupExample2EditPage> createState() => _PromptCustomSetupExample2EditState();
}

//_classNameState
class _PromptCustomSetupExample2EditState extends ConsumerState<PromptCustomSetupExample2EditPage>{

  Future<void> _sendReason() async {
    ref.read(gameSetupProvider.notifier).sendDislikeReason(2);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);

    return _ExamplePromptEditPage(
      prompt: state.examplePrompts?.elementAt(1) ?? "Error Occured",
      onNext: () {
        _sendReason();
        context.push(AppPaths.promptCustomSetupExample3Dev);
      },
    );
  }
}

//------------------------------- PromptCustomSetupExample3Page -----------------------------//
/// Example 3/3. Check → finalizing. X → reason, then finalizing.
class PromptCustomSetupExample3Page extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupExample3Page({super.key});

  @override
  ConsumerState<PromptCustomSetupExample3Page> createState() => _PromptCustomSetupExample3State();
}

//_classNameState
class _PromptCustomSetupExample3State extends ConsumerState<PromptCustomSetupExample3Page>{

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);

    return _ExamplePromptPage(
      question: 'Lastly, how is this one?',
      prompt: state.examplePrompts?.elementAt(2) ?? "Error Occured",
      onLike: () => context.push(AppPaths.promptSettingsDev),
      onDislike: () =>
          context.push(AppPaths.promptCustomSetupExample3EditDev),
    );
  }
}

//------------------------------- PromptCustomSetupExample3EditPage -----------------------------//
class PromptCustomSetupExample3EditPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupExample3EditPage({super.key});

  @override
  ConsumerState<PromptCustomSetupExample3EditPage> createState() => _PromptCustomSetupExample3EditState();
}

//_classNameState
class _PromptCustomSetupExample3EditState extends ConsumerState<PromptCustomSetupExample3EditPage>{

  Future<void> _sendReason() async {
    ref.read(gameSetupProvider.notifier).sendDislikeReason(3);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameSetupProvider);

    return _ExamplePromptEditPage(
      prompt: state.examplePrompts?.elementAt(2) ?? "Error Occured",
      onNext: () {
          _sendReason();
          context.push(AppPaths.promptSettingsDev);
        },
    );
  }
}

//------------------------------- _ExamplePromptPage -----------------------------//
class _ExamplePromptPage extends StatelessWidget {
  const _ExamplePromptPage({
    required this.question,
    required this.prompt,
    required this.onLike,
    required this.onDislike,
    this.counter,
  });

  final String question;
  final String? counter;
  final String prompt;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 5,
      question: question,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: SDeckSpace.gap24,
          children: [
            if (counter != null)
              Text(counter!, style: Theme.of(context).textTheme.bodySmall),
            Text(
              '"$prompt"',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.h6.copyWith(color: context.component.textPrimary),
            ),
            _ExampleVoteButtons(onLike: onLike, onDislike: onDislike),
          ],
        ),
      ),
    );
  }
}

//------------------------------- _ExamplePromptEditPage -----------------------------//
/// Figma `Prompt 2 Edit`: quoted prompt + Reason input + Next.
class _ExamplePromptEditPage extends ConsumerStatefulWidget {
  //classNamePage
  const _ExamplePromptEditPage({
    required this.prompt,
    this.onNext,
    this.onSubmit,
  });

  final String prompt;
  final VoidCallback? onNext;
  final Future<void> Function(List<String>, List<String>)? onSubmit;

  @override
  ConsumerState<_ExamplePromptEditPage> createState() => _ExamplePromptEditState();
}

//_classNameState
class _ExamplePromptEditState extends ConsumerState<_ExamplePromptEditPage> {
  bool _busy = false;
  String? _error;
  // IA: Feedback is local to this example; cancelling does not submit a reason.
  final _selected = <String>[];
  final _custom = <String>[];
  final _other = TextEditingController();
  // IA: Group similar-length labels so long reasons do not stretch short rows.
  static const _rows = [
    ['Too safe', 'Too weird', 'Too serious'],
    ['Too boring', 'Too intense', 'Too generic'],
    ['Not personal enough', 'Wrong kind of humor'],
    ['Touches something to avoid'],
    // IA: Compact final row; Other remains the last choice.
    ['Too personal', 'Not relevant', 'Other'],
  ];
  bool get _valid =>
      _selected.isNotEmpty &&
      (!_selected.contains('Other') ||
          _custom.isNotEmpty ||
          _other.text.trim().isNotEmpty);

  @override
  void dispose() {
    _other.dispose();
    super.dispose();
  }

  void _addOther() {
    final text = _other.text.trim();
    if (text.isEmpty) return;
    setState(() {
      if (!_custom.any((item) => item.toLowerCase() == text.toLowerCase()))
        _custom.add(text);
      _other.clear();
    });
  }

  Future<void> _next() async {
    if (!_valid || _busy) return;
    if (_selected.contains('Other')) _addOther();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // IA: Keep labels/custom notes separate; backend receives multiple reason IDs.
      if (widget.onSubmit != null) {
        await widget.onSubmit!(List.of(_selected), List.of(_custom));
      } else {
        await ref
            .read(gameSetupProvider.notifier)
            .updateHolderText(
              _selected
                  .expand((item) => item == 'Other' ? _custom : [item])
                  .join('; '),
            );
        if (mounted) widget.onNext?.call();
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => _PromptCustomSetupScaffold(
    current: 5,
    question: 'How could this prompt be better?',
    // IA: Frontend shell groups short labels three per row; longer labels get
    // wider rows. Reuse compact team chips without tall, broken-up words.
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '"${widget.prompt}"',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.h6.copyWith(color: context.component.textPrimary),
        ),
        const SizedBox(height: SDeckSpace.padding16),
        Text(
          'Choose all that apply. Add your own with Other.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.component.textSecondary,
          ),
        ),
        const SizedBox(height: SDeckSpace.gap12),
        for (final row in _rows) ...[
          _ChipWrap(
            options: row,
            selected: _selected,
            keyPrefix: 'feedback',
            singleRow: true,
            onSelected:
                (item) => setState(() {
                  if (!_selected.remove(item)) _selected.add(item);
                }),
          ),
          const SizedBox(height: SDeckSpace.gap6),
        ],
        if (_selected.contains('Other')) ...[
          const SizedBox(height: SDeckSpace.gap12),
          _OtherEntries(
            prefix: 'feedback',
            controller: _other,
            entries: _custom,
            placeholder: 'Add a suggestion',
            onChanged: (_) => setState(() {}),
            onAdd: _addOther,
            onRemove: (item) => setState(() => _custom.remove(item)),
          ),
        ],
        const SizedBox(height: SDeckSpace.padding16),
        if (_error != null) Text(_error!, textAlign: TextAlign.center),
        SDeckSolidButton(
          key: const ValueKey('feedback-next'),
          text: _busy ? 'Saving...' : 'Next',
          size: SDeckButtonSize.large,
          fullWidth: true,
          enabled: _valid && !_busy,
          onPressed: _valid && !_busy ? _next : null,
        ),
      ],
    ),
  );
}

//------------------------------- _PromptCustomSetupScaffold -----------------------------//
class _PromptCustomSetupScaffold extends StatelessWidget {
  const _PromptCustomSetupScaffold({
    required this.child,
    required this.question,
    this.current = 1,
  });

  final Widget child;
  final String question;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            const _CustomSetupTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: SDeckSpace.margin16,
                  right: SDeckSpace.margin16,
                  bottom: SDeckSpace.margin16,
                ),
                child: Column(
                  spacing: SDeckSpace.gap24,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ProgressStatus(current: current, total: 5),
                    AspectRatio(
                      aspectRatio: 370 / 185,
                      child: SDeckVisualPlaceholder(
                        borderRadius: BorderRadius.circular(
                          SDeckRadius.borderRadius16,
                        ),
                      ),
                    ),
                    Text(
                      question,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: context.component.textSecondary,
                      ),
                    ),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------- _CustomSetupTopBar -----------------------------//
/// Figma `topBar`: centered Prompt'd sticker. Back + 36px info unless hidden.
class _CustomSetupTopBar extends StatelessWidget {
  const _CustomSetupTopBar({
    this.left = SDeckTopBarLeft.back,
    this.right = SDeckTopBarRight.icon,
  });

  final SDeckTopBarLeft left;
  final SDeckTopBarRight right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SDeckSpace.padding16 + SDeckSize.size48 + SDeckSpace.padding12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SDeckTopNavigationBar(
            left: left,
            type: SDeckTopBarType.subpage,
            right: right,
            showTitle: false,
            rightIcon: SDeckIcons(
              SDeckIcon.information,
              size: SDeckSize.size36,
              color: context.component.navigationIcon,
            ),
          ),
          IgnorePointer(
            child: Image.asset(
              SDeckIcon.promptdSticker,
              width: 133.953,
              height: SDeckSize.size48,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

//------------------------------- _ProgressStatus -----------------------------//
/// Figma `progressStatus`: 8px track + 1/4 fill + footer label.
class _ProgressStatus extends StatelessWidget {
  const _ProgressStatus({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: SDeckSpace.gap8,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SDeckRadius.borderRadius4),
            child: SizedBox(
              height: SDeckSize.size8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: context.semantic.tertiary),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: current / total,
                    child: ColoredBox(color: context.semantic.secondary),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text(
          '$current/$total',
          style: Theme.of(
            context,
          ).textTheme.footer.copyWith(color: context.semantic.secondary),
        ),
      ],
    );
  }
}

//------------------------------- _ExampleVoteButtons -----------------------------//
/// Figma `Icon Buttons`: 64px Check Circle + Delete, gap8.
class _ExampleVoteButtons extends StatelessWidget {
  const _ExampleVoteButtons({required this.onLike, required this.onDislike});

  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: SDeckSpace.gap8,
      mainAxisSize: MainAxisSize.min,
      children: [
        _VoteIconButton(
          iconPath: SDeckIcon.checkCircle,
          semanticsLabel: 'Like this prompt',
          onPressed: onLike,
        ),
        _VoteIconButton(
          iconPath: SDeckIcon.delete,
          semanticsLabel: 'Dislike this prompt',
          onPressed: onDislike,
        ),
      ],
    );
  }
}

//------------------------------- _VoteIconButton -----------------------------//
class _VoteIconButton extends StatelessWidget {
  const _VoteIconButton({
    required this.iconPath,
    required this.semanticsLabel,
    this.onPressed,
  });

  final String iconPath;
  final String semanticsLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SDeckIcons(
        iconPath,
        size: SDeckSize.size64,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}

//------------------------------- _ChipWrap -----------------------------//
/// Figma `Wrap List`: fill width, hug height, gap6, centered outline chips.
// IA: Shared frontend shell for both Other lists, using existing SDeck controls.
// Frontend team: finalize chip/remove styling; preserve add/remove behavior.
class _OtherEntries extends StatelessWidget {
  const _OtherEntries({
    required this.prefix,
    required this.controller,
    required this.entries,
    required this.placeholder,
    required this.onChanged,
    required this.onAdd,
    required this.onRemove,
  });
  final String prefix, placeholder;
  final TextEditingController controller;
  final List<String> entries;
  final ValueChanged<String> onChanged, onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SDeckInput(
        key: ValueKey('$prefix-other-input'),
        state: SDeckInputState.hint,
        label: 'Other',
        placeholder: placeholder,
        placeholderStyle: Theme.of(context).textTheme.bodySmall,
        controller: controller,
        maxLength: 500,
        onChanged: onChanged,
        supportingText: 'Add one at a time. You can add more than one.',
      ),
      const SizedBox(height: SDeckSpace.gap6),
      SDeckOutlineButton(
        key: ValueKey('$prefix-other-add'),
        text: 'Add',
        size: SDeckButtonSize.small,
        fullWidth: true,
        onPressed: controller.text.trim().isEmpty ? null : onAdd,
      ),
      const SizedBox(height: SDeckSpace.gap6),
      Wrap(
        spacing: SDeckSpace.gap6,
        runSpacing: SDeckSpace.gap6,
        children: [
          for (final entry in entries)
            Semantics(
              label: 'Remove $entry',
              button: true,
              child: SDeckOutlineButton(
                key: ValueKey('$prefix-remove-$entry'),
                text: '$entry ×',
                size: SDeckButtonSize.small,
                onPressed: () => onRemove(entry),
              ),
            ),
        ],
      ),
    ],
  );
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.options,
    this.onSelected,
    this.selected = const [],
    this.keyPrefix,
    this.singleRow = false,
  });

  final List<String> options;
  final List<String> selected;
  final String? keyPrefix;
  final bool singleRow;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      for (final option in options)
        Semantics(
          key: keyPrefix == null ? null : ValueKey('$keyPrefix-$option'),
          selected: selected.contains(option),
          button: true,
          child:
              selected.contains(option)
                  ? SDeckSolidButton(
                    text: option,
                    size: SDeckButtonSize.small,
                    shape: SDeckButtonShape.round,
                    fullWidth: false,
                    onPressed: () => onSelected?.call(option),
                  )
                  : SDeckOutlineButton(
                    text: option,
                    size: SDeckButtonSize.small,
                    shape: SDeckButtonShape.round,
                    fullWidth: false,
                    onPressed: () => onSelected?.call(option),
                  ),
        ),
    ];
    // IA: Keep each approved group of three on one line. Scale down only when
    // needed, instead of moving Other to a third row. Other callers still wrap.
    // Frontend team: confirm this compact shell's sizing on smaller phones.
    if (singleRow) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < buttons.length; i++) ...[
              if (i > 0) const SizedBox(width: SDeckSpace.gap6),
              buttons[i],
            ],
          ],
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: SDeckSpace.gap6,
        runSpacing: SDeckSpace.gap6,
        children: buttons,
      ),
    );
  }
}

//------------------------------- _SetupEnvironment -----------------------------//
/// Figma `Environment`: labeled input + Next. Next stays disabled until text.
class _SetupEnvironment extends ConsumerStatefulWidget {
  const _SetupEnvironment({
    required this.placeholder,
    this.label = 'Other',
    this.supportingText,
    this.onNext,
  });

  final String label;
  final String placeholder;
  final String? supportingText;
  final VoidCallback? onNext;

  @override
  ConsumerState<_SetupEnvironment> createState() => _SetupEnvironmentState();
}

class _SetupEnvironmentState extends ConsumerState<_SetupEnvironment> {
  final TextEditingController _controller = TextEditingController();

  bool get _hasText => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _updateHolderText() async {
    ref.read(gameSetupProvider.notifier).updateHolderText(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SDeckSpace.gap12,
      children: [
        SDeckInput(
          label: widget.label,
          placeholder: widget.placeholder,
          supportingText: widget.supportingText,
          size: SDeckInputSize.large,
          state: SDeckInputState.hint,
          controller: _controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {
            _updateHolderText();
          }),
        ),
        SDeckSolidButton(
          text: 'Next',
          size: SDeckButtonSize.large,
          fullWidth: true,
          enabled: _hasText,
          onPressed: _hasText ? (widget.onNext ?? () {}) : null,
        ),
      ],
    );
  }
}
