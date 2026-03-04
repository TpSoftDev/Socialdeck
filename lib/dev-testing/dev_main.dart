// lib/dev-testing/dev_main.dart
// Purpose: Development entry point to test EditPhotoPage directly,
// while still loading the Socialdeck design system themes.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/design_system/index.dart';

import 'package:socialdeck/features/sprint2_training/edit_photo/presentation/pages/edit_photo_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DevApp(),
    ),
  );
}

class DevApp extends StatelessWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ This is the important part: use the same themes as the real app
      themeMode: ThemeMode.system,
      theme: SDeckAppTheme.light,
      darkTheme: SDeckAppTheme.dark,

      // ✅ Your screen
      home: const EditPhotoPage(),
    );
  }
}