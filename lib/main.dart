import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'config/local_gameplay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/config/deep_links/socialdeck_app_links_scope.dart';
import 'package:socialdeck/config/routes/routes.dart';
import 'package:socialdeck/design_system/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialdeck/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (LocalGameplay.requested && !kDebugMode) {
    throw StateError('Local gameplay testing is debug-only.');
  }
  await Firebase.initializeApp(
    options:
        LocalGameplay.enabled
            ? FirebaseOptions(
              apiKey: 'demo-key',
              appId: DefaultFirebaseOptions.currentPlatform.appId,
              messagingSenderId: '123456',
              projectId: LocalGameplay.project,
              storageBucket: '${LocalGameplay.project}.appspot.com',
            )
            : DefaultFirebaseOptions.currentPlatform,
  );
  if (LocalGameplay.enabled) {
    await FirebaseAuth.instance.useAuthEmulator(LocalGameplay.host, 9299);
    FirebaseFirestore.instance.useFirestoreEmulator(LocalGameplay.host, 8280);
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
    await FirebaseStorage.instance.useStorageEmulator(LocalGameplay.host, 9199);
    if (LocalGameplay.testLogin) {
      // IA: Seeded emulator account only; this block cannot run in a normal/release build.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'host@local.test',
        password: 'local-test-password',
      );
    }
  }
  runApp(const ProviderScope(child: SocialdeckAppLinksScope(child: MyApp())));
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
