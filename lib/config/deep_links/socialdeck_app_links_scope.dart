// -----------------------------------------------------------------------------
// socialdeck_app_links_scope.dart
// -----------------------------------------------------------------------------
// Subscribes to incoming app / universal links and forwards password-reset URIs
// to [passwordResetOobProvider], then navigates to the reset-password route.
//
// Android: intent filters on MainActivity (see AndroidManifest.xml).
// iOS: add Associated Domains in Xcode, e.g. applinks:socialdeck-dev.web.app,
// and host apple-app-site-association on that domain for Universal Links.
// -----------------------------------------------------------------------------

import 'dart:async';

// import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialdeck/config/routes/constants/route_constants.dart';
import 'package:socialdeck/config/routes/routes.dart';
import 'package:socialdeck/features/login/providers/password_reset_oob_provider.dart';

/// Wraps the app shell so deep links are handled for the whole lifetime.
class SocialdeckAppLinksScope extends ConsumerStatefulWidget {
  const SocialdeckAppLinksScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<SocialdeckAppLinksScope> createState() =>
      _SocialdeckAppLinksScopeState();
}

class _SocialdeckAppLinksScopeState extends ConsumerState<SocialdeckAppLinksScope> {
  StreamSubscription<Uri>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initAppLinks());
  }

  Future<void> _initAppLinks() async {
    try {
      final appLinks = AppLinks();
      final initial = await appLinks.getInitialLink();
      if (initial != null) {
        _handleUri(initial);
      }
      _subscription = appLinks.uriLinkStream.listen(
        _handleUri,
        onError: (Object e, StackTrace st) {
          debugPrint('AppLinks uriLinkStream error: $e');
        },
      );
    } catch (e, st) {
      debugPrint('AppLinks init failed: $e\n$st');
    }
  }

  void _handleUri(Uri uri) {
    if (!mounted) return;

    final ingested =
        ref.read(passwordResetOobProvider.notifier).tryIngestResetLink(uri);
    if (!ingested) return;

    if (kDebugMode) {
      debugPrint('Password reset link ingested: ${uri.host}${uri.path}');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(goRouterProvider).go(AppPaths.loginResetPassword);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
