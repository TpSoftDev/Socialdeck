import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

/// Dev-only page to visually tune [SDeckStepDialog] (dual actions).
class StepDialogTestPage extends StatefulWidget {
  const StepDialogTestPage({super.key});

  @override
  State<StepDialogTestPage> createState() => _StepDialogTestPageState();
}

class _StepDialogTestPageState extends State<StepDialogTestPage> {
  int _step = 1;
  final int _totalSteps = 4;

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sectionLabel = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: context.component.textSecondary,
        );

    return Scaffold(
      backgroundColor: context.semantic.surfaceVariant,
      appBar: AppBar(
        title: const Text('Step dialog (dev)'),
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
              SDeckStepDialog(
                title: 'Title',
                currentStep: _step,
                totalSteps: _totalSteps,
                primaryButtonText: 'Button',
                secondaryButtonText: 'Button',
                onClose: () => context.pop(),
                onSecondaryPressed: () {
                  if (_step > 0) {
                    setState(() => _step--);
                  } else {
                    _snack('Already at first step');
                  }
                },
                onPrimaryPressed: () {
                  if (_step < _totalSteps) {
                    setState(() => _step++);
                  } else {
                    _snack('On last step — increment clamped in UI');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
