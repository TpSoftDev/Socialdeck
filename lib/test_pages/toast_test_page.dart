import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/index.dart';

/// Gallery for [SDeckToast] variants ([SDeckToastStatus] from [toast_enums.dart]).
class ToastTestPage extends StatelessWidget {
  const ToastTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SDeckSpace.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SDeckToast(
                status: SDeckToastStatus.error,
                title: 'Error',
                description:
                    'This is an error toast with a long description that should wrap to the next line',
              ),
              const SizedBox(height: SDeckSpace.gap16),
              const SDeckToast(
                status: SDeckToastStatus.success,
                title: 'Success',
                description:
                    'This is a success toast with a long description that should wrap to the next line',
              ),
              const SizedBox(height: SDeckSpace.gap16),
              const SDeckToast(
                status: SDeckToastStatus.warning,
                title: 'Warning',
                description:
                    'This is a warning toast with a long description that should wrap to the next line',
              ),
              const SizedBox(height: SDeckSpace.gap16),
              const SDeckToast(
                status: SDeckToastStatus.info,
                title: 'Info',
                description:
                    'This is an info toast with a long description that should wrap to the next line',
              ),
              const SizedBox(height: SDeckSpace.gap16),
              const SDeckToast(
                status: SDeckToastStatus.link,
                title: 'Link',
                description:
                    'This is a link toast with a long description that should wrap to the next line',
              ),
              const SizedBox(height: SDeckSpace.gap16),
              const SDeckToast(
                status: SDeckToastStatus.note,
                title: 'Note',
                description:
                    'This is a note toast with a long description that should wrap to the next line',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
