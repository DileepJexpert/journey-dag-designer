/// Role-based visibility/enablement (build doc §10 "roles"). Maker authors and
/// submits; checker approves/publishes; maker != checker is enforced on the
/// approve path (and again by the backend with a 403).
///
/// Two shapes:
///  * [RoleGate] — hides a subtree unless the user holds the required role.
///  * [roleAllows] — a pure predicate for enabling/disabling a control while
///    keeping it visible (greyed out with a tooltip), which reads better than
///    making buttons vanish.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_user.dart';
import 'auth_controller.dart';

/// True when [user] holds [role]. Null user => false.
bool roleAllows(AppUser? user, UserRole role) =>
    user != null && user.roles.contains(role);

/// Shows [child] only when the current user holds [role]; otherwise [orElse]
/// (default: nothing).
class RoleGate extends ConsumerWidget {
  const RoleGate({
    super.key,
    required this.role,
    required this.child,
    this.orElse,
  });

  final UserRole role;
  final Widget child;
  final Widget? orElse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    if (roleAllows(user, role)) return child;
    return orElse ?? const SizedBox.shrink();
  }
}
