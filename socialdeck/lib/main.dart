import 'package:flutter/material.dart';
import 'package:socialdeck/design_system/utils/themes/theme.dart';
import 'test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: SDeckAppTheme.lightTheme,
      darkTheme: SDeckAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const Test(),
    );
  }
}
