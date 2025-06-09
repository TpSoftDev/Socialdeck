import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

// Converts a Stream into a ChangeNotifier so GoRouter can listen to it
// This allows GoRouter to refresh when Firebase Auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
