import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/config/deep_links/socialdeck_app_links_scope.dart';
import 'package:socialdeck/config/routes/routes.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialdeck/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: SocialdeckAppLinksScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      title: 'Socialdeck',
      themeMode: ThemeMode.system,
      theme: SDeckAppTheme.light,
      darkTheme: SDeckAppTheme.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}