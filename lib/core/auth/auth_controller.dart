/// Auth state (build doc §9, §10). Exposes the current [AppUser] + roles and
/// login/logout. RoleGate reads roles from here; the router redirects on auth.
///
/// In mock mode (no backend) login accepts any non-empty credentials and grants
/// the role implied by the username ("checker*" -> checker, else maker) so both
/// sides of maker-checker can be exercised locally.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_user.dart';
import '../config/env.dart';
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
    if (Env.useMockBackend) {
      final roles = <UserRole>{
        UserRole.maker,
        if (username.toLowerCase().startsWith('checker')) UserRole.checker,
      };
      await ref.read(tokenStoreProvider).write('mock-token-$username');
      state = AuthState(user: AppUser(id: username, name: username, roles: roles));
      return;
    }
    // Real login wiring (POST /auth/login) lands here in a later step.
    throw UnimplementedError('HTTP login not wired yet; use mock mode');
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    state = const AuthState();
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
