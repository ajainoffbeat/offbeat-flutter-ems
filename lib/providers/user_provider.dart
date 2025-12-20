// lib/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../repository/user_repository.dart';
import '../state/user_state.dart';
import '../models/user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(client: http.Client());
});

final userProvider = NotifierProvider<UserController, UserState>(() {
  return UserController();
});

class UserController extends Notifier<UserState> {
  @override
  UserState build() {
    return const UserState();
  }

  Future<void> loadUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repo = ref.read(userRepositoryProvider);
      final result = await repo.getUserProfile();

      final code = result["statusCode"];
      final data = result["data"];

      if (code == 200) {
        final user = User.fromJson(data["user"]);
        state = state.copyWith(isLoading: false, user: user);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Failed to load profile",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Something went wrong: ${e.toString()}",
      );
    }
  }
}