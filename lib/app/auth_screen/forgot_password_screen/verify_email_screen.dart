import 'package:ems_offbeat/app/auth_screen/forgot_password_screen/otp_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'package:ems_offbeat/services/api_service.dart' as ForgotPasswordService;

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      _showSnack("Please enter your email");
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnack("Please enter a valid email address");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Call your API to send OTP
      await ForgotPasswordService.sendOtpToEmail(email: email);

      _showSnack("OTP sent to your email");

      // Navigate to OTP verification screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpScreen(email: email),
          ),
        );
      }
    } catch (e) {
      _showSnack(e.toString().replaceAll("Exception:", ""));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppThemeData.primary500,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 10),

                    const ScreenHeading(text: "Forgot Password? 🔑"),
                    const SizedBox(height: 6),
                    const ScreenSubtitle(
                      text:
                          "No worries! Enter your email and we'll send you a verification code.",
                    ),

                    const SizedBox(height: 40),

                    const TitleText(text: "Email Address"),
                    const SizedBox(height: 6),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: const Icon(Icons.email_outlined),
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
                  // onPressed: isLoading ? null : _sendOtp,
                   onPressed: () {
                      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordOtpScreen(email: "samir@gmail.com"),
          ),
        );
                    },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Send Verification Code",
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