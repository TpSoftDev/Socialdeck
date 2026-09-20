/*-------------------- prompt_custom_setup_page.dart -----------------------*/
// Prompt'd Custom Setup questionnaire (steps 1–3/4), generating,
// example review, finalizing, and complete.
/*--------------------------------------------------------------------------*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PromptCustomSetupPage -----------------------------//
class PromptCustomSetupPage extends StatelessWidget {
  const PromptCustomSetupPage({super.key});

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
          context.push(AppPaths.promptCustomSetupMoodDev);
        },
      ),
    );
  }
}

//------------------------------- PromptCustomSetupOtherPage -----------------------------//
/// Other follow-up: labeled input + Next. Back pops to the chip list.
class PromptCustomSetupOtherPage extends StatelessWidget {
  const PromptCustomSetupOtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      question: 'Who are you playing with?',
      child: _SetupEnvironment(
        placeholder: 'Enter a group/setting',
        onNext: () => context.push(AppPaths.promptCustomSetupMoodDev),
      ),
    );
  }
}

//------------------------------- PromptCustomSetupMoodPage -----------------------------//
/// Question 2/4. Back returns to the previous environment step.
class PromptCustomSetupMoodPage extends StatelessWidget {
  const PromptCustomSetupMoodPage({super.key});

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
          context.push(AppPaths.promptCustomSetupKeywordsDev);
        },
      ),
    );
  }
}

//------------------------------- PromptCustomSetupMoodOtherPage -----------------------------//
/// Mood Other follow-up: labeled input + Next. Back pops to the mood chips.
class PromptCustomSetupMoodOtherPage extends StatelessWidget {
  const PromptCustomSetupMoodOtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PromptCustomSetupScaffold(
      current: 2,
      question: 'What is the mood?',
      child: _SetupEnvironment(
        placeholder: 'Enter a mood/vibe',
        onNext: () => context.push(AppPaths.promptCustomSetupKeywordsDev),
      ),
    );
  }
}

//------------------------------- PromptCustomSetupKeywordsPage -----------------------------//
/// Question 3/4. Keywords input + Next. Back returns to the mood step.
class PromptCustomSetupKeywordsPage extends StatelessWidget {
  const PromptCustomSetupKeywordsPage({super.key});

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

//------------------------------- PromptCustomSetupFinalizingPage -----------------------------//
/// Loading beat after example 3. Fades in, holds, then fades to complete.
class PromptCustomSetupFinalizingPage extends StatelessWidget {
  const PromptCustomSetupFinalizingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _PromptStatusPage(
      status: 'Finalizing prompts...',
      left: SDeckTopBarLeft.none,
      right: SDeckTopBarRight.none,
      onNext: () => context.push(AppPaths.promptCustomSetupCompleteDev),
    );
  }
}

//------------------------------- PromptCustomSetupCompletePage -----------------------------//
/// Done state after finalizing. Sticker only; square Rive placeholder + status.
class PromptCustomSetupCompletePage extends StatelessWidget {
  const PromptCustomSetupCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PromptStatusPage(
      status: 'Complete!',
      aspectRatio: 370 / 370,
      left: SDeckTopBarLeft.none,
      right: SDeckTopBarRight.none,
    );
  }
}

//------------------------------- _PromptStatusPage -----------------------------//
/// Figma generating / finalizing / complete: placeholder + body-large status.
/// When [onNext] is set, holds [SDeckMotionDuration.linger] then advances.
class _PromptStatusPage extends StatefulWidget {
  const _PromptStatusPage({
    required this.status,
    this.aspectRatio = 370 / 185,
    this.left = SDeckTopBarLeft.back,
    this.right = SDeckTopBarRight.icon,
    this.onNext,
  });

  final String status;
  final double aspectRatio;
  final SDeckTopBarLeft left;
  final SDeckTopBarRight right;
  final VoidCallback? onNext;

  @override
  State<_PromptStatusPage> createState() => _PromptStatusPageState();
}

class _PromptStatusPageState extends State<_PromptStatusPage> {
  Timer? _advanceTimer;

  @override
  void initState() {
    super.initState();
    final VoidCallback? onNext = widget.onNext;
    if (onNext == null) return;
    _advanceTimer = Timer(SDeckMotionDuration.linger, () {
      if (!mounted) return;
      onNext();
    });
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    super.dispose();
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
class PromptCustomSetupExamplePage extends StatelessWidget {
  const PromptCustomSetupExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamplePromptPage(
      question: 'How does this example look?',
      prompt: _ExamplePrompts.one,
      onLike: () => context.push(AppPaths.promptCustomSetupExample2Dev),
      onDislike: () => context.push(AppPaths.promptCustomSetupExampleEditDev),
    );
  }
}

//------------------------------- PromptCustomSetupExampleEditPage -----------------------------//
class PromptCustomSetupExampleEditPage extends StatelessWidget {
  const PromptCustomSetupExampleEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamplePromptEditPage(
      prompt: _ExamplePrompts.one,
      onNext: () => context.push(AppPaths.promptCustomSetupExample2Dev),
    );
  }
}

//------------------------------- PromptCustomSetupExample2Page -----------------------------//
/// Example 2/3. Check → example 3. X → reason, then example 3.
class PromptCustomSetupExample2Page extends StatelessWidget {
  const PromptCustomSetupExample2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamplePromptPage(
      question: 'Now what about this one?',
      prompt: _ExamplePrompts.two,
      onLike: () => context.push(AppPaths.promptCustomSetupExample3Dev),
      onDislike: () =>
          context.push(AppPaths.promptCustomSetupExample2EditDev),
    );
  }
}

//------------------------------- PromptCustomSetupExample2EditPage -----------------------------//
class PromptCustomSetupExample2EditPage extends StatelessWidget {
  const PromptCustomSetupExample2EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamplePromptEditPage(
      prompt: _ExamplePrompts.two,
      onNext: () => context.push(AppPaths.promptCustomSetupExample3Dev),
    );
  }
}

//------------------------------- PromptCustomSetupExample3Page -----------------------------//
/// Example 3/3. Check → finalizing. X → reason, then finalizing.
class PromptCustomSetupExample3Page extends StatelessWidget {
  const PromptCustomSetupExample3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamplePromptPage(
      question: 'Lastly, how is this one?',
      prompt: _ExamplePrompts.three,
      onLike: () => context.push(AppPaths.promptCustomSetupFinalizingDev),
      onDislike: () =>
          context.push(AppPaths.promptCustomSetupExample3EditDev),
    );
  }
}

//------------------------------- PromptCustomSetupExample3EditPage -----------------------------//
class PromptCustomSetupExample3EditPage extends StatelessWidget {
  const PromptCustomSetupExample3EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _ExamplePromptEditPage(
      prompt: _ExamplePrompts.three,
      onNext: () => context.push(AppPaths.promptCustomSetupFinalizingDev),
    );
  }
}

//------------------------------- _ExamplePrompts -----------------------------//
abstract final class _ExamplePrompts {
  static const String one =
      "The face you make when the investor says 'let's circle back'";
  static const String two =
      'POV: you just found out your co-founder used the last of the office snacks... on a Tuesday';
  static const String three = 'This is fine (it is not fine)';
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
class _ExamplePromptEditPage extends StatelessWidget {
  const _ExamplePromptEditPage({required this.prompt, required this.onNext});

  final String prompt;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
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
              onNext: onNext,
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
