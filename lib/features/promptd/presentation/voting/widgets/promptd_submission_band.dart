import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

import '../../../domain/promptd_vote_models.dart';

class PromptdSubmissionBand extends StatelessWidget {
  const PromptdSubmissionBand({
    super.key,
    required this.submission,
    this.selected = false,
    this.isCurrentPlayer = false,
    this.showRank = true,
    this.voteCount = 0,
    this.showVotes = false,
    this.onTap,
    this.height = 180,
  });

  final PromptdSubmission submission;
  final bool selected;
  final bool isCurrentPlayer;
  final bool showRank;
  final int voteCount;
  final bool showVotes;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = submission.color;

    final background = selected
        ? (dark ? Color.lerp(base, Colors.black, .25)! : base)
        : (dark
            ? Color.lerp(base, const Color(0xFF101822), .76)!
            : Color.lerp(base, Colors.white, .76)!);

    final foreground = selected
        ? Colors.white
        : (dark ? Color.lerp(base, Colors.white, .25)! : base);

    return AnimatedContainer(
      duration: SDeckMotionDuration.normal,
      curve: SDeckMotionCurve.easeInOut,
      height: height,
      color: background,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              children: [
                if (submission.rank.isOdd) ...[
                  _buildCard(),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: SDeckMotionDuration.normal,
                      switchInCurve: SDeckMotionCurve.easeOut,
                      switchOutCurve: SDeckMotionCurve.easeIn,
                      child: showVotes
                          ? _AnimatedVoteMarkers(
                              key: const ValueKey('votes'),
                              count: voteCount,
                              color: foreground,
                            )
                          : _buildRank(foreground),
                    ),
                  ),
                ),
                if (submission.rank.isEven) ...[
                  const SizedBox(width: 12),
                  _buildCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return SDeckPlayingCard(
      size: SDeckPlayingCardSize.small,
      shadow: SDeckPlayingCardShadow.none,
      imagePath: submission.imagePath,
    );
  }

  Widget _buildRank(Color foreground) {
    if (!showRank) {
      return const SizedBox(
        key: ValueKey('empty'),
      );
    }

    return Column(
      key: const ValueKey('rank'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '#${submission.rank}',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: foreground,
          ),
        ),
        if (selected || isCurrentPlayer)
          Text(
            selected ? 'Selected' : 'You',
            style: TextStyle(
              fontSize: 12,
              color: foreground,
            ),
          ),
        if (selected || isCurrentPlayer)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CircleAvatar(
              radius: 19,
              backgroundColor:
                  foreground.withValues(alpha: .85),
            ),
          ),
      ],
    );
  }
}

class _AnimatedVoteMarkers extends StatelessWidget {
  const _AnimatedVoteMarkers({
    super.key,
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) => TweenAnimationBuilder<double>(
          key: ValueKey(index),
          tween: Tween(begin: 0, end: 1),
          duration: SDeckMotionDuration.normal,
          curve: SDeckMotionCurve.easeOut,
          builder: (context, progress, child) {
            return Opacity(
              opacity: progress,
              child: Transform.scale(
                scale: .65 + (.35 * progress),
                child: child,
              ),
            );
          },
          child: CircleAvatar(
            radius: 12,
            backgroundColor: color,
          ),
        ),
      ),
    );
  }
}