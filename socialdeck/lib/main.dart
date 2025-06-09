import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/config/routes/routes.dart';
import 'package:socialdeck/design_system/themes/sdeck_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      title: 'Socialdeck',
      themeMode: ThemeMode.system,
      theme: SDeckTheme.light,
      darkTheme: SDeckTheme.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
