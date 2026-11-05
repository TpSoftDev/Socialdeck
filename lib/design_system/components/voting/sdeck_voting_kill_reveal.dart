import 'package:flutter/material.dart';

/// Coordinates the visual collapse of losing cards during Kill/Double Kill.
/// The caller changes [revealed] when the reveal stage starts; no game logic
/// or timers are hidden in this design-system component.
class SDeckVotingKillReveal extends StatelessWidget {
  const SDeckVotingKillReveal({
    super.key,
    required this.options,
    required this.winnerIndex,
    required this.revealed,
    this.doubleKill = false,
    this.duration = const Duration(milliseconds: 550),
    this.spacing = 0,
  }) : assert(options.length >= 2),
       assert(winnerIndex >= 0 && winnerIndex < options.length);

  final List<Widget> options;
  final int winnerIndex;
  final bool revealed;
  final bool doubleKill;
  final Duration duration;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final collapsed = revealed && doubleKill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < options.length; i++)
          AnimatedSize(
            key: ValueKey('kill-slot-$i'),
            duration: duration,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child:
                (collapsed && i != winnerIndex)
                    ? const SizedBox(width: double.infinity, height: 0)
                    : AnimatedOpacity(
                      duration: duration,
                      opacity:
                          revealed && i != winnerIndex
                              ? (doubleKill ? 0 : .38)
                              : 1,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: i == options.length - 1 ? 0 : spacing,
                        ),
                        child: options[i],
                      ),
                    ),
          ),
      ],
    );
  }
}
