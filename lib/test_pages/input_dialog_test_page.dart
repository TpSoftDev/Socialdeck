import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socialdeck/design_system/index.dart';

/// Dev-only page to visually tune [SDeckInputDialog].
class InputDialogTestPage extends StatefulWidget {
  const InputDialogTestPage({super.key});

  @override
  State<InputDialogTestPage> createState() => _InputDialogTestPageState();
}

class _InputDialogTestPageState extends State<InputDialogTestPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.semantic.surfaceVariant,
      appBar: AppBar(
        title: const Text('Input dialog (dev)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SDeckSpace.padding24),
          child: Center(
            child: SDeckInputDialog(
              title: 'Title',
              controller: _controller,
              onClose: () => context.pop(),
              onPrimaryPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Submitted: ${_controller.text}')),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
