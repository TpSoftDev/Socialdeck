import 'package:flutter/material.dart';
import 'package:socialdeck/Design_System%20/Utils/Themes/theme.dart';
import 'simple_example.dart';

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
      home: const SimpleExample(),
    );
  }
}
