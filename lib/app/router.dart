/// go_router config with an auth redirect guard (build doc §10). Unauthenticated
/// users are sent to /login; authenticated users away from /login.
///
/// Only the routes that exist in this scaffold are wired (login, journeys). The
/// editor/versions/approvals/audit/bindings routes (build doc §10) are added as
/// their features land.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/journeys/journeys_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/journeys',
    redirect: (context, state) {
      final authed = ref.read(authControllerProvider).isAuthenticated;
      final loggingIn = state.matchedLocation == '/login';
      if (!authed) return loggingIn ? null : '/login';
      if (loggingIn) return '/journeys';
      return null;
    },
    refreshListenable: _AuthListenable(ref),
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/journeys', builder: (_, __) => const JourneysScreen()),
    ],
  );
});

/// Rebuilds the router when auth state changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authControllerProvider, (_, __) => notifyListeners());
  }
}
