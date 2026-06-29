/// The authenticated user and their roles (build doc §9 auth, §10 roles).
/// Roles drive RoleGate (maker can edit/submit; checker can approve/publish).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

enum UserRole { maker, checker }

@freezed
class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String name,
    @Default(<UserRole>{}) Set<UserRole> roles,
  }) = _AppUser;

  bool get isMaker => roles.contains(UserRole.maker);
  bool get isChecker => roles.contains(UserRole.checker);
}
