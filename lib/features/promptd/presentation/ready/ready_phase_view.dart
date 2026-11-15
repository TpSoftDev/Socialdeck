/*------------------------- ready_phase_view.dart --------------------------*/
// Prompt'd host ready-up. One widget covers both Figma frames:
// the tutorial toggle off, and the tutorial toggle on.
//
// Light and dark share this widget. The page fill is surface:
// #FDFBF5 in light, #101822 in dark. The title and tutorial title are
// primary: #1F1F1F in light, #F5F5F5 in dark. The status and tutorial
// subtitle are secondary: #5E5E5E in light, #D9D9D9 in dark.
// The button and the toggle keep the colors already built into those widgets.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- ReadyPhaseView ------------------------------//
class ReadyPhaseView extends StatefulWidget {
  const ReadyPhaseView({
    super.key,
    this.title = 'I\'m Ready!',
    required this.readyCount,
    required this.playerCount,
    this.buttonLabel = 'I\'m not ready!',
    this.tutorialTitle = 'In-Game Tutorial?',
    this.tutorialSubtitle = 'It\'s helpful for a player\'s first time.',
    this.tutorialEnabled = false,
    this.onTutorialChanged,
    this.onButtonPressed,
    this.imagePath,
  });

  final String title;

  /// Players who have readied up. The game supplies this later.
  final int readyCount;

  /// Players in the game. The game supplies this later.
  final int playerCount;

  final String buttonLabel;
  final String tutorialTitle;
  final String tutorialSubtitle;

  /// Figma toggleSwitch. False is the left frame, true is the right frame.
  final bool tutorialEnabled;

  final ValueChanged<bool>? onTutorialChanged;
  final VoidCallback? onButtonPressed;

  /// Square above the status line. Null shows the visual placeholder.
  final String? imagePath;

  @override
  State<ReadyPhaseView> createState() => _ReadyPhaseViewState();
}

class _ReadyPhaseViewState extends State<ReadyPhaseView> {
  late bool _tutorialEnabled = widget.tutorialEnabled;

  @override
  void didUpdateWidget(ReadyPhaseView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tutorialEnabled != widget.tutorialEnabled) {
      _tutorialEnabled = widget.tutorialEnabled;
    }
  }

  void _setTutorial(bool value) {
    setState(() => _tutorialEnabled = value);
    widget.onTutorialChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return ColoredBox(
      color: context.semantic.surface,
      child: Column(
        children: [
          const SDeckTopNavigationBar(
            left: SDeckTopBarLeft.none,
            right: SDeckTopBarRight.none,
            showTitle: false,
            centerWidget: SizedBox(height: SDeckSize.size48),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: SDeckSpace.margin16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: SDeckSpace.margin16),
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: text.h4.copyWith(
                            color: context.semantic.primary,
                          ),
                        ),
                        const SizedBox(height: SDeckSpace.gap24),
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              SDeckRadius.borderRadius16,
                            ),
                            child:
                                widget.imagePath == null
                                    ? const SDeckVisualPlaceholder(
                                      borderRadius: BorderRadius.zero,
                                    )
                                    : Image.asset(
                                      widget.imagePath!,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                        const SizedBox(height: SDeckSpace.gap24),
                        Text(
                          'Waiting for ${widget.readyCount}/${widget.playerCount} to ready up...',
                          textAlign: TextAlign.center,
                          style: text.body.copyWith(
                            color: context.semantic.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SDeckSpace.gap16),
                  SDeckSolidButton(
                    text: widget.buttonLabel,
                    size: SDeckButtonSize.large,
                    fullWidth: true,
                    onPressed: widget.onButtonPressed,
                  ),
                  const SizedBox(height: SDeckSpace.gap16),
                  _TutorialRow(
                    title: widget.tutorialTitle,
                    subtitle: widget.tutorialSubtitle,
                    value: _tutorialEnabled,
                    onChanged: _setTutorial,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//------------------------------- Tutorial row --------------------------------//
class _TutorialRow extends StatelessWidget {
  const _TutorialRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return SizedBox(
      height: SDeckSize.size64,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SDeckSpace.padding8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmallFigma.copyWith(
                      color: context.semantic.primary,
                    ),
                  ),
                  const SizedBox(height: SDeckSpace.gap4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.footer.copyWith(
                      color: context.semantic.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SDeckSpace.gap12),
            SDeckToggleSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
