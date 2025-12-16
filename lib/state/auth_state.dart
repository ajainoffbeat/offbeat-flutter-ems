class AuthState {
  final bool isLoading;
  final String? message; // success or error message
  final bool success;

  const AuthState({
    this.isLoading = false,
    this.message,
    this.success = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? message,
    bool? success,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      success: success ?? this.success,
    );
  }
}
