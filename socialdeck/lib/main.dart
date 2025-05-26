import 'package:flutter/material.dart';
import 'package:socialdeck/Design_System%20/Utils/Themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system, //Flutter detects the theme of the phone
      theme: SDeckAppTheme.lightTheme, //Light theme
      darkTheme: SDeckAppTheme.darkTheme, //Dark theme
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Social Deck Color System'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Social Deck Design System',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Colors from Figma integrated successfully!'),
          ],
        ),
      ),
    );
  }
}
