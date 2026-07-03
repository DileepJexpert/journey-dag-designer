/// Auth state (build doc §9, §10). Exposes the current [AppUser] + roles and
/// login/logout. RoleGate reads roles from here; the router redirects on auth.
///
/// In mock mode (no backend) login accepts any non-empty credentials and grants
/// the role implied by the username ("checker*" -> checker, else maker) so both
/// sides of maker-checker can be exercised locally.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_user.dart';
import 'token_store.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) {
  // In-memory by default; the real app overrides with SecureTokenStore.
  return InMemoryTokenStore();
});

class AuthState {
  const AuthState({this.user});
  final AppUser? user;
  bool get isAuthenticated => user != null;
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('username and password required');
    }
    // Identity is ASSERTED, not authenticated — in mock AND live mode: the
    // username becomes the actor id every repository call carries (the mock
    // stamps it locally; the HTTP client sends it as X-User-Id and the
    // REGISTRY enforces maker-checker on it, 403s included). Replacing this
    // assertion with SSO/OIDC-verified identity is a tracked production gate
    // (platform README); the "checker*" role convention mirrors the seed data.
    final roles = <UserRole>{
      UserRole.maker,
      if (username.toLowerCase().startsWith('checker')) UserRole.checker,
    };
    await ref.read(tokenStoreProvider).write('session-$username');
    state = AuthState(user: AppUser(id: username, name: username, roles: roles));
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
