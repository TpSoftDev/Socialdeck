import '../constants/route_constants.dart';

bool needsProfileStatus(String path) =>
    path == AppPaths.home || path.startsWith('${AppPaths.home}/') ||
    path == AppPaths.login || path == AppPaths.signUp;

// Null means the lookup failed, not that onboarding is incomplete.
String? profileSetupRedirect(String path, bool? complete) {
  if (complete == null) return null;
  if (complete && (path == AppPaths.login || path == AppPaths.signUp)) {
    return AppPaths.home;
  }
  if (!complete && (path == AppPaths.home || path.startsWith('${AppPaths.home}/'))) {
    return '/profile/introduce-card';
  }
  return null;
}
