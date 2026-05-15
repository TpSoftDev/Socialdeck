import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/design_system/index.dart';

/// Dev page for [SDeckHomeTutorialStepDialog] — no header close, first step is
/// Next-only; later steps use Back + Next (matches Home Figma tutorial).
class HomeTutorialStepDialogTestPage extends StatefulWidget {
  const HomeTutorialStepDialogTestPage({super.key});

  @override
  State<HomeTutorialStepDialogTestPage> createState() =>
      _HomeTutorialStepDialogTestPageState();
}

class _HomeTutorialStepDialogTestPageState
    extends State<HomeTutorialStepDialogTestPage> {
  static const List<String> _titles = [
    'Tutorial',
    'Friends',
    'Decks',
    'Play',
    'Shop',
    'Profile',
    'Learn More',
  ];

  static const int _totalSteps = 7;

  int _step = 1;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String get _title =>
      _titles[(_step - 1).clamp(0, _titles.length - 1)];

  bool get _pastFirstStep => _step > 1;

  bool get _onLastStep => _step >= _totalSteps;

  void _goNext() {
    if (_onLastStep) {
      context.push(AppPaths.homeTutorialCompleted);
      return;
    }
    setState(() => _step++);
  }

  void _goBack() {
    if (_step <= 1) {
      _snack('No step before this one');
      return;
    }
    setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surfaceVariant,
      appBar: AppBar(
        title: const Text('Home tutorial step dialog (dev)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SDeckSpace.padding24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: SDeckSpace.gap8),
              Text(
                'Embedded preview (no modal). Step $_step of $_totalSteps — '
                'no X in the dialog; use screen AppBar back to leave.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.component.textSecondary,
                    ),
              ),
              const SizedBox(height: SDeckSpace.gap24),
              SDeckHomeTutorialStepDialog(
                title: _title,
                currentStep: _step,
                totalSteps: _totalSteps,
                primaryButtonText: _onLastStep ? 'Finish' : 'Next',
                secondaryButtonText: _pastFirstStep ? 'Back' : null,
                onSecondaryPressed: _pastFirstStep ? _goBack : null,
                onPrimaryPressed: _goNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
