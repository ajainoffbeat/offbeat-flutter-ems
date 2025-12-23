import 'package:flutter/material.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'package:ems_offbeat/services/api_service.dart' as ForgotPasswordService;

class ForgotPasswordResetScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ForgotPasswordResetScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ForgotPasswordResetScreen> createState() =>
      _ForgotPasswordResetScreenState();
}

class _ForgotPasswordResetScreenState extends State<ForgotPasswordResetScreen> {
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  bool isLoading = false;
  bool showNew = false;
  bool showConfirm = false;

  @override
  void dispose() {
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (newPassCtrl.text.isEmpty || confirmPassCtrl.text.isEmpty) {
      _showSnack("All fields are required");
      return;
    }

    if (newPassCtrl.text.length < 6) {
      _showSnack("Password must be at least 6 characters");
      return;
    }

    if (!_hasUpperCase(newPassCtrl.text)) {
      _showSnack("Password must contain at least one uppercase letter");
      return;
    }

    if (!_hasLowerCase(newPassCtrl.text)) {
      _showSnack("Password must contain at least one lowercase letter");
      return;
    }

    if (!_hasDigit(newPassCtrl.text)) {
      _showSnack("Password must contain at least one number");
      return;
    }

    if (newPassCtrl.text != confirmPassCtrl.text) {
      _showSnack("Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Call your API to reset password
      await ForgotPasswordService.resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: newPassCtrl.text.trim(),
      );

      _showSnack("Password reset successfully");

      // Navigate back to login screen (pop all forgot password screens)
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      _showSnack(e.toString().replaceAll("Exception:", ""));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool _hasUpperCase(String value) => value.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String value) => value.contains(RegExp(r'[a-z]'));
  bool _hasDigit(String value) => value.contains(RegExp(r'[0-9]'));

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool isVisible,
    required VoidCallback toggle,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: toggle,
      ),
      filled: true,
      fillColor: AppThemeData.grey100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppThemeData.primary400,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isMet ? Colors.green : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final password = newPassCtrl.text;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppThemeData.primary500,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 10),

                    const ScreenHeading(text: "Create New Password 🔐"),
                    const SizedBox(height: 6),
                    const ScreenSubtitle(
                      text:
                          "Your new password must be different from previously used passwords.",
                    ),

                    const SizedBox(height: 30),

                    /// NEW PASSWORD
                    const TitleText(text: "New Password"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: newPassCtrl,
                      obscureText: !showNew,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration(
                        hint: "Enter new password",
                        isVisible: showNew,
                        toggle: () => setState(() => showNew = !showNew),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// CONFIRM PASSWORD
                    const TitleText(text: "Confirm Password"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: confirmPassCtrl,
                      obscureText: !showConfirm,
                      decoration: _inputDecoration(
                        hint: "Confirm new password",
                        isVisible: showConfirm,
                        toggle: () =>
                            setState(() => showConfirm = !showConfirm),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PASSWORD REQUIREMENTS
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppThemeData.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Password must contain:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildPasswordRequirement(
                            "At least 6 characters",
                            password.length >= 6,
                          ),
                          _buildPasswordRequirement(
                            "One uppercase letter (A-Z)",
                            _hasUpperCase(password),
                          ),
                          _buildPasswordRequirement(
                            "One lowercase letter (a-z)",
                            _hasLowerCase(password),
                          ),
                          _buildPasswordRequirement(
                            "One number (0-9)",
                            _hasDigit(password),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BOTTOM BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeData.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: isLoading ? null : _resetPassword,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Reset Password",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}