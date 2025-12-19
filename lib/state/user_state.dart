// lib/state/user_state.dart
import '../models/user.dart';

class UserState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  const UserState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  UserState copyWith({
    bool? isLoading,
    User? user,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}