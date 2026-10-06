/*-------------------- prompt_custom_setup_page.dart -----------------------*/
// Prompt'd Custom Setup questionnaire (steps 1–3/4), generating,
// example review, finalizing, and complete.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

import '../../providers/game_setup_provider.dart';

//I can't figure out a better way to do this than just having a global variable
String otherText = "";


//------------------------------- PromptCustomSetupPage -----------------------------//
class PromptCustomSetupPage extends ConsumerStatefulWidget {
  const PromptCustomSetupPage({super.key});

  @override
  ConsumerState<PromptCustomSetupPage> createState() => _PromptCustomSetupState();
}

class _PromptCustomSetupState extends ConsumerState<PromptCustomSetupPage>{

  _selectOptionPlayingWith(String option){
    ref.read(gameSetupProvider.notifier).updatePlayingWith(option);
  }

  static const List<String> _options = [
    'Friends',
    'Family',
    'Mutuals',
    'Coworkers',
    'Classmates',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      question: 'Who are you playing with?',
      child: _ChipWrap(
        options: _options,
        onSelected: (option) {
          if (option == 'Other') {
            context.push(AppPaths.promptCustomSetupOtherDev);
            return;
          }
          _selectOptionPlayingWith(option);
          context.push(AppPaths.promptCustomSetupMoodDev);
        },
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

  _handleOther(String otherOption){
    ref.read(gameSetupProvider.notifier).updatePlayingWith(otherOption);
    otherText = "";
  }

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      question: 'Who are you playing with?',
      child: _SetupEnvironment(
        placeholder: 'Enter a group/setting',
        onNext: () {
          _handleOther(otherText);
          print("Here");
          context.push(AppPaths.promptCustomSetupMoodDev);
        },
      ),
    );
  }
}

//------------------------------- PromptCustomSetupMoodPage -----------------------------//
/// Question 2/4. Back returns to the previous environment step.
class PromptCustomSetupMoodPage extends ConsumerStatefulWidget {

  const PromptCustomSetupMoodPage({super.key});

  @override
  ConsumerState<PromptCustomSetupMoodPage> createState() => _PromptCustomSetupMoodStage();
}


class _PromptCustomSetupMoodStage extends ConsumerState<PromptCustomSetupMoodPage>{

  void _setGameMood(String mood){
    ref.read(gameSetupProvider.notifier).updateMood(mood);
  }

  static const List<String> _options = [
    'Funny',
    'Chill',
    'Nostalgic',
    'Wholesome',
    'Spicy',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 2,
      question: 'What is the mood?',
      child: _ChipWrap(
        options: _options,
        onSelected: (option) {
          if (option == 'Other') {
            context.push(AppPaths.promptCustomSetupMoodOtherDev);
            return;
          }
          _setGameMood(option);
          context.push(AppPaths.promptCustomSetupKeywordsDev);
        },
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

  void _setGameMood(String mood){
    ref.read(gameSetupProvider.notifier).updateMood(mood);
    otherText = "";
  }

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 2,
      question: 'What is the mood?',
      child: _SetupEnvironment(
        placeholder: 'Enter a mood/vibe',
        onNext: () { 
          _setGameMood(otherText);
          context.push(AppPaths.promptCustomSetupKeywordsDev);
          },
      ),
    );
  }
}

//------------------------------- PromptCustomSetupKeywordsPage -----------------------------//
/// Question 3/4. Keywords input + Next. Back returns to the mood step.
class PromptCustomSetupKeywordsPage extends ConsumerStatefulWidget {

    //classNamePage
  const PromptCustomSetupKeywordsPage({super.key});

  @override
  ConsumerState<PromptCustomSetupKeywordsPage> createState() => _PromptCustomSetupKeywordsState();
}
//_classNameState
class _PromptCustomSetupKeywordsState extends ConsumerState<PromptCustomSetupKeywordsPage>{

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 3,
      question: 'Include any keywords & topics?',
      child: _SetupEnvironment(
        label: 'Keywords & Topics',
        placeholder: 'Enter one/many things',
        supportingText:
            'Use descriptive words or sentences to get more accurate and creative results.',
        onNext: () => context.push(AppPaths.promptCustomSetupGeneratingDev),
      ),
    );
  }
}

//------------------------------- PromptCustomSetupGeneratingPage -----------------------------//
/// Loading beat after keywords. Fades in, holds, then fades to example 1.
class PromptCustomSetupGeneratingPage extends StatelessWidget {
  const PromptCustomSetupGeneratingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PromptStatusPage(
      status: 'Generating example prompts...',
      onNext: () => context.push(AppPaths.promptCustomSetupExampleDev),
    );
  }
}

//------------------------------- _PromptStatusPage -----------------------------//
/// Figma generating / finalizing / complete: placeholder + body-large status.
/// When [onNext] is set, holds [SDeckMotionDuration.linger] then advances.
class _PromptStatusPage extends ConsumerStatefulWidget {
  const _PromptStatusPage({
    required this.status,
    this.onNext,
  });

  final String status;
  final double aspectRatio = 370 / 185;
  final SDeckTopBarLeft left = SDeckTopBarLeft.back;
  final SDeckTopBarRight right = SDeckTopBarRight.icon;
  final VoidCallback? onNext;

  @override
  ConsumerState<_PromptStatusPage> createState() => _PromptStatusPageState();
}

class _PromptStatusPageState extends ConsumerState<_PromptStatusPage> {

  Future<void> _generatePrompts(VoidCallback onNext) async {
    bool ready = await ref.read(gameSetupProvider.notifier).generatePrompts();
    if(mounted && ready){
      onNext();
    }
  }

  @override
  void initState() {
    super.initState();
    final VoidCallback? onNext = widget.onNext;
    if (onNext == null) return;
    
    _generatePrompts(onNext);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.semantic.surface,
      body: SafeArea(
        child: Column(
          children: [
            _CustomSetupTopBar(left: widget.left, right: widget.right),
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
                      aspectRatio: widget.aspectRatio,
                      child: SDeckVisualPlaceholder(
                        borderRadius: BorderRadius.circular(
                          SDeckRadius.borderRadius16,
                        ),
                      ),
                    ),
                    Text(
                      widget.status,
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
    ref.read(gameSetupProvider.notifier).sendDislikeReason(1, otherText);
    otherText = "";
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
    ref.read(gameSetupProvider.notifier).sendDislikeReason(2, otherText);
    otherText = "";
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
    ref.read(gameSetupProvider.notifier).sendDislikeReason(3, otherText);
    otherText = "";
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
  });

  final String question;
  final String prompt;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 4,
      question: question,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: SDeckSpace.gap24,
          children: [
            Text(
              '"$prompt"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.h6.copyWith(
                color: context.component.textPrimary,
              ),
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
  const _ExamplePromptEditPage({required this.prompt, required this.onNext});

  final String prompt;
  final VoidCallback onNext;

  @override
  ConsumerState<_ExamplePromptEditPage> createState() => _ExamplePromptEditState();
}
//_classNameState
class _ExamplePromptEditState extends ConsumerState<_ExamplePromptEditPage>{

  @override
  Widget build(BuildContext context) {
    final String prompt = widget.prompt;
    return _PromptCustomSetupScaffold(
      current: 4,
      question: "What's wrong here?",
      child: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: SDeckSpace.gap24,
          children: [
            Text(
              '"$prompt"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.h6.copyWith(
                color: context.component.textPrimary,
              ),
            ),
            _SetupEnvironment(
              label: 'Reason',
              placeholder: 'Type here',
              supportingText:
                  'Provide clarity to help make the experience better.',
              onNext: widget.onNext,
            ),
          ],
        ),
      ),
    );
  }
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
                    _ProgressStatus(current: current, total: 4),
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
          style: Theme.of(context).textTheme.footer.copyWith(
            color: context.semantic.secondary,
          ),
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
class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.options, this.onSelected});

  final List<String> options;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: SDeckSpace.gap6,
        runSpacing: SDeckSpace.gap6,
        children: [
          for (final option in options)
            SDeckOutlineButton(
              text: option,
              size: SDeckButtonSize.small,
              shape: SDeckButtonShape.round,
              onPressed: () => onSelected?.call(option),
            ),
        ],
      ),
    );
  }
}

//------------------------------- _SetupEnvironment -----------------------------//
/// Figma `Environment`: labeled input + Next. Next stays disabled until text.
class _SetupEnvironment extends StatefulWidget {
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
  State<_SetupEnvironment> createState() => _SetupEnvironmentState();
}

class _SetupEnvironmentState extends State<_SetupEnvironment> {
  final TextEditingController _controller = TextEditingController();

  bool get _hasText => _controller.text.trim().isNotEmpty;
  get otherText => _controller.text.trim();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          onChanged: (_) => setState(() {}),
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
