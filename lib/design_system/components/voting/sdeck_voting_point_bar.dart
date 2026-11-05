
import 'package:flutter/material.dart';

/// The narrow bottom strip on Prompt'd result screens.
/// The parent owns the score calculation; this component only displays it.
class SDeckVotingPointBar extends StatelessWidget {
  const SDeckVotingPointBar({
    super.key,
    required this.points,
    this.label = 'You',
    this.photo,
    this.height = 88,
  });

  final int points;
  final String label;
  final Widget? photo;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final negative = points < 0;
    final value = points > 0 ? '+$points' : '$points';

    return Container(
      height: height,
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: photo ??
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onSurface
                        .withOpacity(.08),
                  ),
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: negative
                  ? const Color(0xFFFF595E)
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
