import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/themes/sdeck_theme.dart';
import 'package:socialdeck/test_navigation_bar.dart';
import 'test_buttons.dart';

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
      home: const TestButtonsScreen(),
    );
  }
}
