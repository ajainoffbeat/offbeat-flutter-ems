import 'package:ems_offbeat/utils/jwt_helper.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a boolean indicating whether the current user is a SuperAdmin
/// based on the `role` claim in the JWT.
final isSuperAdminProvider = FutureProvider.autoDispose<bool>((ref) async {
  final token = await TokenStorage.getToken();
  if (token == null) return false;

  final role = JwtHelper.getRole(token);
  return role == 'SuperAdmin';
});
