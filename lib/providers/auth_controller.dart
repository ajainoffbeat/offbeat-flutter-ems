import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../state/auth_state.dart';
import 'package:http/http.dart' as http;

/// PROVIDER: Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(client: http.Client());
});

/// PROVIDER: Auth Controller (Notifier)
final authProvider = NotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> login(
    String email,
    String password,
    String? fcmToken,
    String? deviceType,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        message: "Email and password are required",
        success: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, message: null);

    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.login(email, password, fcmToken, deviceType);

      final code = result["statusCode"];
      final data = result["data"];

      if (code == 200) {
        state = state.copyWith(
          isLoading: false,
          success: true,
          message: data["message"] ?? "Login successful",
        );
      } else {
        if (code == 401) {
          // specifically handle unauthorized
          state = state.copyWith(
            isLoading: false,
            success: false,
            message: "Invalid credentials", // or "User not found"
          ); 
        } else {
          // fallback for other failures
          state = state.copyWith(
            isLoading: false,
            success: false,
            message: data["message"] ?? "Login failed",
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        success: false,
        message: "Something went wrong",
      );
    }
  }
}
