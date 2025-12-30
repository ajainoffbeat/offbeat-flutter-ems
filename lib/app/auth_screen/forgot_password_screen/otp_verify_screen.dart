import 'package:ems_offbeat/app/auth_screen/forgot_password_screen/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'package:ems_offbeat/services/api_service.dart' as ForgotPasswordService;
import 'dart:async';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;
  bool isResending = false;
  int resendTimer = 60;
  Timer? _timer;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        setState(() => resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      setState(() => _otpError = "OTP is required");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Call your API to verify OTP
      final isValid = await ForgotPasswordService.verifyOtp(
        email: widget.email,
        otp: otp,
      );

      if (isValid) {
        _showSnack("OTP verified successfully");

        // Navigate to reset password screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ForgotPasswordResetScreen(email: widget.email, otp: otp),
            ),
          );
        }
      } else {
        _showSnack("Invalid OTP. Please try again.");
      }
    } catch (e) {
      _showSnack(e.toString().replaceAll("Exception:", ""));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => isResending = true);

    try {
      await ForgotPasswordService.sendOtpToEmail(email: widget.email);
      _showSnack("OTP resent to your email");
      _startResendTimer();

      // Clear previous OTP
      for (var controller in otpControllers) {
        controller.clear();
      }
      focusNodes[0].requestFocus();
    } catch (e) {
      _showSnack(e.toString().replaceAll("Exception:", ""));
    } finally {
      if (mounted) {
        setState(() => isResending = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      height: 55,
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        textAlign: TextAlign.center,

        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppThemeData.grey100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppThemeData.primary400,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (_otpError != null) setState(() => _otpError = null);
          if (value.isNotEmpty && index < 5) {
            focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }

          // Auto verify when all 6 digits are entered
          if (index == 5 && value.isNotEmpty) {
            final otp = otpControllers.map((c) => c.text).join();
            if (otp.length == 6) {
              _verifyOtp();
            }
          }
        },
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppThemeData.primary500,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(height: 10),

                    const ScreenHeading(text: "Verify Code 📧"),
                    const SizedBox(height: 6),
                    ScreenSubtitle(
                      text:
                          "Enter the 6-digit code we sent to\n${widget.email}",
                    ),

                    const SizedBox(height: 40),

                    /// OTP BOXES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => _buildOtpBox(index),
                      ),
                    ),
                    if (_otpError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 2),
                        child: Text(
                          _otpError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),

                    /// RESEND OTP
                    Center(
                      child: resendTimer > 0
                          ? Text(
                              "Resend code in ${resendTimer}s",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            )
                          : TextButton(
                              onPressed: isResending ? null : _resendOtp,
                              child: isResending
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Resend Code",
                                      style: TextStyle(
                                        color: AppThemeData.primary500,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
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
                  onPressed: isLoading ? null : _verifyOtp,
                  //             onPressed: () {
                  //               Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ForgotPasswordResetScreen(email:"hero@gmail.com",otp:"123456"),
                  //   ),
                  // );},
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify Code",
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
