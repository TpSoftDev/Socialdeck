import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import '../../domain/promptd_vote_models.dart';
import '../voting/widgets/promptd_submission_band.dart';

class PromptdScenarioRevealView extends StatelessWidget {
  const PromptdScenarioRevealView({
    super.key,
    required this.scenario,
    required this.stage,
    this.onPause,
    this.onMore,
  });

  final PromptdScenario scenario;
  final PromptdRevealStage stage;
  final VoidCallback? onPause;
  final VoidCallback? onMore;

  bool get _showHeader =>
      stage != PromptdRevealStage.blank &&
      stage != PromptdRevealStage.finished;

  bool get _showPrompt =>
      stage != PromptdRevealStage.blank &&
      stage != PromptdRevealStage.finished;

  bool get _promptMinimized =>
      stage.index >= PromptdRevealStage.minimized.index;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.semantic.surface,
      child: SafeArea(
        child: Column(
          children: [
            AnimatedOpacity(
              duration: SDeckMotionDuration.normal,
              curve: SDeckMotionCurve.easeInOut,
              opacity: _showHeader ? 1 : 0,
              child: SDeckPromptdTopBar(
                round: 'Round ${scenario.roundNumber}',
                opposingPlayer: 'Vote for your favorite!',
                onPausePressed: onPause,
                onRightIconPressed: onMore,
              ),
            ),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;

                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      AnimatedPositioned(
                        duration: SDeckMotionDuration.slow,
                        curve: SDeckMotionCurve.easeInOut,
                        top: _promptMinimized
                            ? 8
                            : availableHeight * .27,
                        left: _promptMinimized ? 16 : 24,
                        right: _promptMinimized ? 16 : 24,
                        child: AnimatedOpacity(
                          duration: SDeckMotionDuration.normal,
                          curve: SDeckMotionCurve.easeInOut,
                          opacity: _showPrompt ? 1 : 0,
                          child: AnimatedScale(
                            duration: SDeckMotionDuration.slow,
                            curve: SDeckMotionCurve.easeInOut,
                            alignment: Alignment.topCenter,
                            scale: _promptMinimized ? .88 : 1,
                            child: SDeckSpeechBubble(
                              text: scenario.prompt,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: availableHeight * .40,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedSwitcher(
                          duration: SDeckMotionDuration.slow,
                          switchInCurve: SDeckMotionCurve.easeOut,
                          switchOutCurve: SDeckMotionCurve.easeIn,
                          transitionBuilder: (child, animation) {
                            final slide = Tween<Offset>(
                              begin: const Offset(0, .10),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: SDeckMotionCurve.easeOut,
                              ),
                            );

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: slide,
                                child: child,
                              ),
                            );
                          },
                          child: _buildCardStage(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStage() {
    if (scenario.submissions.isEmpty) {
      return const SizedBox.shrink(
        key: ValueKey('no-submissions'),
      );
    }

    switch (stage) {
      case PromptdRevealStage.firstCard:
        return _card(0);

      case PromptdRevealStage.secondCard:
        return _card(
          scenario.submissions.length > 1 ? 1 : 0,
        );

      case PromptdRevealStage.blank:
      case PromptdRevealStage.prompt:
      case PromptdRevealStage.minimized:
      case PromptdRevealStage.transition:
      case PromptdRevealStage.finished:
        return const SizedBox.shrink(
          key: ValueKey('no-card'),
        );
    }
  }

  Widget _card(int index) {
    final submission = scenario.submissions[index];

    return Center(
      key: ValueKey('reveal-${submission.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PromptdSubmissionBand(
          submission: submission,
          showRank: false,
          height: 210,
        ),
      ),
    );
  }
}