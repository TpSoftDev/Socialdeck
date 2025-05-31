import 'package:flutter/material.dart';
import 'package:socialdeck/design_system_new/themes/sdeck_theme.dart';
import 'test_new_design_system.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: SDeckTheme.light,
      darkTheme: SDeckTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const TestNewDesignSystem(),
    );
  }
}
