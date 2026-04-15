/*------------------------------- sdeck_keyboard_anchor.dart -------------------------------*/
// Keeps a target widget (e.g. “Forget password?”) visible when the soft keyboard opens.
// Uses Scrollable.ensureVisible on a GlobalKey so behavior adapts to screen + keyboard size.
/*------------------------------------------------------------------------------------------*/

import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

/// Design-system helpers for keyboard-aware scrolling.
abstract final class SDeckKeyboardScroll {
  SDeckKeyboardScroll._();

  /// Whether the OS is currently reserving bottom inset for the keyboard / IME.
  static bool isKeyboardOpen(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom > 0;

  /// Scrolls the nearest [Scrollable] ancestor so the widget at [anchorKey] is visible.
  ///
  /// Typically call when a field gains focus or when [WidgetsBindingObserver.didChangeMetrics]
  /// reports a keyboard inset change.
  ///
  /// If [revealAlignment] is **null** (default), uses [alignmentPolicy] — usually
  /// [ScrollPositionAlignmentPolicy.keepVisibleAtEnd] for minimal scroll.
  ///
  /// If [revealAlignment] is set (e.g. `0.92`), uses [ScrollPositionAlignmentPolicy.explicit]
  /// so the target sits slightly **above** the bottom of the viewport. That helps clear
  /// IME toolbars and extra keyboard chrome that sometimes extend past [viewInsets].
  ///
  /// [afterRevealExtraOverlap] scrolls further **down** the list by that many logical pixels
  /// after [Scrollable.ensureVisible] completes — use for a fixed gap above the keyboard
  /// (Figma often shows ~16px) when IME chrome is taller than [MediaQuery.viewInsets].
  ///
  /// **Android reliability:** When the scroll view’s viewport can still sit under the IME,
  /// attach the same [ScrollController] you pass to [SingleChildScrollView] here and call
  /// [jumpScrollToMax] from your focus / metrics logic, or use [SDeckKeyboardAnchorListener]
  /// with [SDeckKeyboardAnchorListener.scrollToEndController] and
  /// [SDeckKeyboardAnchorListener.padChildWithViewInsetBottom].
  static void jumpScrollToMax(ScrollController controller) {
    void go() {
      if (!controller.hasClients) return;
      controller.jumpTo(controller.position.maxScrollExtent);
    }

    go();
    WidgetsBinding.instance.addPostFrameCallback((_) => go());
    Future<void>.delayed(const Duration(milliseconds: 80), go);
    Future<void>.delayed(const Duration(milliseconds: 200), go);
  }

  static void ensureAnchorVisible(
    GlobalKey anchorKey, {
    Duration duration = const Duration(milliseconds: 220),
    Curve curve = Curves.easeOutCubic,
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    double? revealAlignment,
    double afterRevealExtraOverlap = 0,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        _ensureAnchorVisibleAsync(
          anchorKey,
          duration: duration,
          curve: curve,
          alignmentPolicy: alignmentPolicy,
          revealAlignment: revealAlignment,
          afterRevealExtraOverlap: afterRevealExtraOverlap,
        ),
      );
    });
  }

  static Future<void> _ensureAnchorVisibleAsync(
    GlobalKey anchorKey, {
    required Duration duration,
    required Curve curve,
    required ScrollPositionAlignmentPolicy alignmentPolicy,
    required double? revealAlignment,
    required double afterRevealExtraOverlap,
  }) async {
    final target = anchorKey.currentContext;
    if (target == null || !target.mounted) return;

    final useExplicit = revealAlignment != null;
    await Scrollable.ensureVisible(
      target,
      duration: duration,
      curve: curve,
      alignment: revealAlignment ?? 0,
      alignmentPolicy:
          useExplicit
              ? ScrollPositionAlignmentPolicy.explicit
              : alignmentPolicy,
    );

    if (afterRevealExtraOverlap <= 0) return;
    final ctx = anchorKey.currentContext;
    if (ctx == null || !ctx.mounted) return;

    final scrollable = Scrollable.maybeOf(ctx);
    if (scrollable == null) return;
    final position = scrollable.position;
    if (!position.hasPixels) return;

    final next = (position.pixels + afterRevealExtraOverlap).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((next - position.pixels).abs() < 0.5) return;

    await position.animateTo(
      next,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
    );
  }
}

/// Listens for keyboard geometry changes and optional [FocusNode] focus, then scrolls
/// so [anchorKey] stays in view.
///
/// Place this **above** the [Scrollable] that contains the anchored child (e.g. wrap
/// [SingleChildScrollView]). Put [GlobalKey] on the widget that must stay visible.
///
/// Example:
/// ```dart
/// final _linkKey = GlobalKey();
/// final _passwordFocus = FocusNode();
///
/// SDeckKeyboardAnchorListener(
///   anchorKey: _linkKey,
///   focusNode: _passwordFocus,
///   child: SingleChildScrollView(
///     child: Column(
///       children: [
///         ...,
///         KeyedSubtree(
///           key: _linkKey,
///           child: TextButton(onPressed: () {}, child: Text('Forgot?')),
///         ),
///       ],
///     ),
///   ),
/// );
/// ```
///
/// **Android (IME under scroll viewport):** use [padChildWithViewInsetBottom] and
/// [scrollToEndController] together with [Scaffold.resizeToAvoidBottomInset] = false — see class docs.
class SDeckKeyboardAnchorListener extends StatefulWidget {
  const SDeckKeyboardAnchorListener({
    required this.anchorKey,
    required this.child,
    this.focusNode,
    this.scrollOnKeyboardOnlyIfFocused = true,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOutCubic,
    this.alignmentPolicy = ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
    this.revealAlignment = 0.92,
    this.afterRevealExtraOverlap = 0,
    this.padChildWithViewInsetBottom = false,
    this.scrollToEndController,
    super.key,
  });

  final GlobalKey anchorKey;
  final Widget child;

  /// When non-null, focus changes can trigger a scroll (see [scrollOnKeyboardOnlyIfFocused]).
  final FocusNode? focusNode;

  /// If true (default), keyboard metric changes scroll only when [focusNode] has focus.
  /// Set false to always keep [anchorKey] visible whenever the keyboard opens.
  final bool scrollOnKeyboardOnlyIfFocused;

  final Duration duration;
  final Curve curve;
  final ScrollPositionAlignmentPolicy alignmentPolicy;

  /// Passed to [SDeckKeyboardScroll.ensureAnchorVisible] as [revealAlignment].
  /// Slightly below `1.0` (default `0.92`) clears IME toolbars; set to **null** for
  /// [alignmentPolicy]-only behavior (minimal scroll).
  final double? revealAlignment;

  /// Extra scroll after [Scrollable.ensureVisible] — device/IME-safe bottom gap (e.g. `16`).
  final double afterRevealExtraOverlap;

  /// When true, wraps [child] in [Padding] using [MediaQuery.viewInsets.bottom] so the scroll
  /// viewport ends above the keyboard. Use with [Scaffold.resizeToAvoidBottomInset] = **false**
  /// on the same screen so insets are not applied twice.
  final bool padChildWithViewInsetBottom;

  /// Optional [ScrollController] from your [SingleChildScrollView]; jumps to [ScrollPosition.maxScrollExtent]
  /// when the anchored field is focused and when keyboard metrics change (with retries).
  final ScrollController? scrollToEndController;

  @override
  State<SDeckKeyboardAnchorListener> createState() =>
      _SDeckKeyboardAnchorListenerState();
}

class _SDeckKeyboardAnchorListenerState extends State<SDeckKeyboardAnchorListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.focusNode?.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SDeckKeyboardAnchorListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChanged);
      widget.focusNode?.addListener(_onFocusChanged);
    }
  }

  void _onFocusChanged() {
    if (widget.focusNode?.hasFocus ?? false) {
      // Run even before viewInsets update so the scroll settles as the keyboard animates.
      SDeckKeyboardScroll.ensureAnchorVisible(
        widget.anchorKey,
        duration: widget.duration,
        curve: widget.curve,
        alignmentPolicy: widget.alignmentPolicy,
        revealAlignment: widget.revealAlignment,
        afterRevealExtraOverlap: widget.afterRevealExtraOverlap,
      );
      final c = widget.scrollToEndController;
      if (c != null) {
        SDeckKeyboardScroll.jumpScrollToMax(c);
      }
    }
  }

  bool _shouldReactToKeyboard() {
    if (widget.focusNode == null) return true;
    if (widget.scrollOnKeyboardOnlyIfFocused) {
      return widget.focusNode!.hasFocus;
    }
    return true;
  }

  void _maybeEnsureVisible() {
    if (!mounted) return;
    if (!SDeckKeyboardScroll.isKeyboardOpen(context)) return;
    if (!_shouldReactToKeyboard()) return;
    _runEnsureVisible();
  }

  void _runEnsureVisible() {
    SDeckKeyboardScroll.ensureAnchorVisible(
      widget.anchorKey,
      duration: widget.duration,
      curve: widget.curve,
      alignmentPolicy: widget.alignmentPolicy,
      revealAlignment: widget.revealAlignment,
      afterRevealExtraOverlap: widget.afterRevealExtraOverlap,
    );
    final c = widget.scrollToEndController;
    if (c != null) {
      SDeckKeyboardScroll.jumpScrollToMax(c);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeEnsureVisible();
      // IME height often settles a frame or two after the first inset update.
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        _maybeEnsureVisible();
      });
    });
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.padChildWithViewInsetBottom) {
      return widget.child;
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: widget.child,
    );
  }
}
