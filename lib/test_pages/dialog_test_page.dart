import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

/// Dev-only page to visually tune [SDeckDialog] (two-button layout).
class DialogTestPage extends StatelessWidget {
  const DialogTestPage({super.key});

  void _snack(BuildContext context, String message) {
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
        title: const Text('Dialog (dev)'),
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
              SDeckDialog(
                title: 'Title',
                description: 'Description',
                secondaryButtonText: 'Button',
                primaryButtonText: 'Button',
                onClose: () => context.pop(),
                onSecondaryPressed: () =>
                    _snack(context, 'Secondary (outline) pressed'),
                onPrimaryPressed: () =>
                    _snack(context, 'Primary (solid) pressed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
