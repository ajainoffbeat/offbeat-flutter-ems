import 'package:ems_offbeat/services/api_service.dart' as UpdatePasswordService;
import 'package:flutter/material.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:ems_offbeat/utils/jwt_helper.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController oldPassCtrl = TextEditingController();
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  bool isLoading = false;
  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;

  String? oldPassError;
  String? newPassError;
  String? confirmPassError;

  @override
  void dispose() {
    oldPassCtrl.dispose();
    newPassCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    setState(() {
      oldPassError = oldPassCtrl.text.isEmpty ? "Old password is required" : null;
      newPassError = newPassCtrl.text.isEmpty ? "New password is required" : null;
      confirmPassError = confirmPassCtrl.text.isEmpty ? "Confirm password is required" : null;

      if (newPassCtrl.text.length < 6) {
        newPassError = "Password must be at least 6 characters";
      }

      if (newPassCtrl.text != confirmPassCtrl.text) {
        confirmPassError = "Passwords do not match";
      }
    });

    if (oldPassError != null || newPassError != null || confirmPassError != null) return;

    setState(() => isLoading = true);

    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token not found");

      final employeeId = JwtHelper.getEmployeeId(token);
      final userName = "ajain@offbeatsoftwaresolutions.in";

      if (employeeId == null || userName == null) throw Exception("Invalid token data");

      final message = await UpdatePasswordService.updatePassword(
        userId: employeeId,
        userName: userName,
        oldPassword: oldPassCtrl.text.trim(),
        newPassword: newPassCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll("Exception:", ""))),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
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
        borderSide: const BorderSide(color: AppThemeData.primary400, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: const Icon(Icons.arrow_back, color: AppThemeData.primary500),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 10),
                    const ScreenHeading(text: "Update Password 🔒"),
                    const SizedBox(height: 6),
                    const ScreenSubtitle(
                      text: "Enter your current password and choose a new secure password.",
                    ),
                    const SizedBox(height: 30),

                    // OLD PASSWORD
                    const TitleText(text: "Old Password"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: oldPassCtrl,
                      obscureText: !showOld,
                      decoration: _inputDecoration(
                        hint: "Old Password",
                        isVisible: showOld,
                        toggle: () => setState(() => showOld = !showOld),
                      ),
                    ),
                    if (oldPassError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: Text(oldPassError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                      ),

                    const SizedBox(height: 20),

                    // NEW PASSWORD
                    const TitleText(text: "New Password"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: newPassCtrl,
                      obscureText: !showNew,
                      decoration: _inputDecoration(
                        hint: "New Password",
                        isVisible: showNew,
                        toggle: () => setState(() => showNew = !showNew),
                      ),
                    ),
                    if (newPassError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: Text(newPassError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                      ),

                    const SizedBox(height: 20),

                    // CONFIRM PASSWORD
                    const TitleText(text: "Confirm Password"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: confirmPassCtrl,
                      obscureText: !showConfirm,
                      decoration: _inputDecoration(
                        hint: "Confirm New Password",
                        isVisible: showConfirm,
                        toggle: () => setState(() => showConfirm = !showConfirm),
                      ),
                    ),
                    if (confirmPassError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: Text(confirmPassError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // BOTTOM BUTTON
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
                  onPressed: isLoading ? null : _updatePassword,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Reset Password", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
