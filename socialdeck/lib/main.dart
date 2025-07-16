import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/config/routes/routes.dart';
import 'package:socialdeck/design_system/themes/sdeck_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialdeck/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      theme: SDeckTheme.inHouseLight,
      darkTheme: SDeckTheme.inHouseDark,
      debugShowCheckedModeBanner: false,
    );
  }
}

//TODO: Profile Creation Check if user name is taken
