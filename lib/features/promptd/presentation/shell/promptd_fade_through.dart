/*------------------------ promptd_fade_through.dart -----------------------*/
// Same fade as the Prompt'd page routes. The current screen fades out,
// the surface shows, then the next screen fades in.
// Outgoing uses the first half of [SDeckMotionDuration.slower], incoming
// the second half, both on [SDeckMotionCurve.easeIn].
// A new [child] with the same [step] updates in place, so a screen can
// change its own contents without fading.
/*--------------------------------------------------------------------------*/

import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

//------------------------------- PromptdFadeThrough --------------------------//
class PromptdFadeThrough extends StatefulWidget {
  const PromptdFadeThrough({
    super.key,
    required this.step,
    required this.child,
  });

  /// Changes when [child] should replace the current screen.
  final int step;
  final Widget child;

  @override
  State<PromptdFadeThrough> createState() => _PromptdFadeThroughState();
}

class _PromptdFadeThroughState extends State<PromptdFadeThrough>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Widget? _outgoing;
  late Widget _incoming;

  @override
  void initState() {
    super.initState();
    _incoming = widget.child;
    _controller = AnimationController(
      vsync: this,
      duration: SDeckMotionDuration.slower,
    )..addStatusListener((AnimationStatus status) {
      if (status != AnimationStatus.completed || !mounted) return;
      setState(() => _outgoing = null);
    });
  }

  @override
  void didUpdateWidget(covariant PromptdFadeThrough oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.step == oldWidget.step) {
      _incoming = widget.child;
      return;
    }
    _outgoing = _incoming;
    _incoming = widget.child;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        final Widget? outgoing = _outgoing;
        final double t = _controller.value;
        if (outgoing == null || t >= 1) return _incoming;
        final double outProgress = (t / 0.5).clamp(0.0, 1.0);
        final double inProgress = ((t - 0.5) / 0.5).clamp(0.0, 1.0);
        final double outOpacity =
            t < 0.5 ? 1 - SDeckMotionCurve.easeIn.transform(outProgress) : 0;
        final double inOpacity =
            t < 0.5 ? 0 : SDeckMotionCurve.easeIn.transform(inProgress);

        return ColoredBox(
          color: context.semantic.surface,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(opacity: outOpacity, child: outgoing),
              Opacity(opacity: inOpacity, child: _incoming),
            ],
          ),
        );
      },
    );
  }
}
