/*-------------------- prompt_custom_setup_page.dart -----------------------*/
// Prompt'd Custom Setup questionnaire (steps 1–2/4).
// Chip lists push nested Other routes; back returns to the chips.
/*--------------------------------------------------------------------------*/

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
      child: _OtherEnvironment(
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
          }
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
    return const _PromptCustomSetupScaffold(
      current: 2,
      question: 'What is the mood?',
      child: _OtherEnvironment(placeholder: 'Enter a mood/vibe'),
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
/// Back + centered Prompt'd sticker + information icon.
class _CustomSetupTopBar extends StatelessWidget {
  const _CustomSetupTopBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SDeckTopNavigationBar(
          left: SDeckTopBarLeft.back,
          type: SDeckTopBarType.subpage,
          right: SDeckTopBarRight.icon,
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

//------------------------------- _OtherEnvironment -----------------------------//
/// Figma `Environment`: Other input + Next. Next stays disabled until text.
class _OtherEnvironment extends StatefulWidget {
  const _OtherEnvironment({required this.placeholder, this.onNext});

  final String placeholder;
  final VoidCallback? onNext;

  @override
  State<_OtherEnvironment> createState() => _OtherEnvironmentState();
}

class _OtherEnvironmentState extends State<_OtherEnvironment> {
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
          label: 'Other',
          placeholder: widget.placeholder,
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
