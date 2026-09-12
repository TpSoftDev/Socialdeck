import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

/// Post-tutorial celebration — Figma `visualPopup` (230:3805).
///
/// Shows [SDeckHomeTutorialCompletionPopup] for [autoNavigateDelay] then
/// [context.go]s to [AppPaths.home] (per design: return user to home).
class HomeTutorialCompletedPage extends StatefulWidget {
  const HomeTutorialCompletedPage({
    super.key,
    this.autoNavigateDelay = const Duration(seconds: 3),
  });

  final Duration autoNavigateDelay;

  @override
  State<HomeTutorialCompletedPage> createState() =>
      _HomeTutorialCompletedPageState();
}

class _HomeTutorialCompletedPageState extends State<HomeTutorialCompletedPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.autoNavigateDelay, _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    context.go(AppPaths.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surfaceVariant,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: SDeckSpace.padding24,
                ),
                child: Center(
                  child: SDeckHomeTutorialCompletionPopup(
                    maxWidth: constraints.maxWidth -
                        (2 * SDeckSpace.padding24),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
