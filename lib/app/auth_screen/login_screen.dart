import 'dart:convert';
import 'package:ems_offbeat/app/auth_screen/forgot_password_screen/verify_email_screen.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_controller.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'dart:io' show Platform;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  String? _fcmToken;
  String? _deviceType;
  // St

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _fcmToken = await FirebaseMessaging.instance.getToken();
    });
    //     if (Platform.isAndroid) {
    //   _deviceType =
    // } else if (Platform.isIOS) {
    //   _deviceType =
    // }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    /// LISTEN FOR SUCCESS / ERROR MESSAGES
    ref.listen(authProvider, (prev, next) {
      if (next.message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message!)));

        if (next.success) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    });

    final isLoading = authState.isLoading;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const ScreenHeading(text: "Welcome Back! 👋"),
              const SizedBox(height: 6),
              const ScreenSubtitle(
                text: "Log in and manage your HR tasks with ease",
              ),

              const SizedBox(height: 24),

              const TitleText(text: "Email"),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    _emailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 16),

              const TitleText(text: "Password"),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration:
                    _inputDecoration(
                      hint: "Password",
                      icon: Icons.lock_outline,
                      suffix: _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                onChanged: (_) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
              ),

              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8),
                  child: Text(
                    _passwordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 14),
              Row(
                children: [
                  // Checkbox(
                  //   value: _rememberMe,
                  //   onChanged: (v) => setState(() => _rememberMe = v ?? false),
                  //   checkColor: Colors.white,
                  //   side: const BorderSide(
                  //     color: AppThemeData.primary500,
                  //     width: 2,
                  //   ),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  // ),
                  // const Text("Remember me"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ForgotPasswordEmailScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppThemeData.primary500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeData.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            _emailError = _emailController.text.trim().isEmpty
                                ? "Email is required"
                                : null;
                            _passwordError =
                                _passwordController.text.trim().isEmpty
                                ? "Password is required"
                                : null;
                          });

                          if (_emailError != null || _passwordError != null)
                            return;

                          try {
                            await ref
                                .read(authProvider.notifier)
                                .login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _fcmToken,
                                  _deviceType,
                                )
                                .timeout(const Duration(seconds: 5));
                          } catch (_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Something went wrong, please try again",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Log in",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    IconData? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix != null ? Icon(suffix) : null,
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

  Widget _socialButton({required IconData icon, required String text}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
