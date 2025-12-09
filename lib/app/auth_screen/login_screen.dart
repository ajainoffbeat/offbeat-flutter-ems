import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_subtitle.dart';
import 'package:ems_offbeat/widgets/screen_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

  /// ✅ LOGIN API CALL
  Future<void> _login() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password are required")),
      );
      return;
    }
    setState(() => _isLoading = true);
    final url =
        Uri.parse("http://www.offbeatsoftwaresolutions.com/api/Auth/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "Username": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      print(data.toString());

      if (response.statusCode == 200) {
        // ✅ Example: token
        final token = data["token"];
        print("TOKENNNNNNNNNNNNNNNNNNNN: $token");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login successful")),
        );

        Navigator.pushReplacementNamed(context, '/leaves');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),

              const SizedBox(height: 10),

              const ScreenTitle(text: "Welcome Back! 👋"),
              const SizedBox(height: 6),
              const ScreenSubtitle(
                text: "Log in and manage your HR tasks with ease",
              ),

              const SizedBox(height: 24),

              // ✅ EMAIL
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hint: "Email",
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 16),

              // ✅ PASSWORD
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration(
                  hint: "Password",
                  icon: Icons.lock_outline,
                  suffix: Icons.visibility_off,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (v) {
                      setState(() => _rememberMe = v ?? false);
                    },
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: AppThemeData.primary500,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Text("Remember me"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
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
              const Center(child: Text("or")),
              const SizedBox(height: 20),

              _socialButton(
                icon: Icons.g_mobiledata,
                text: "Continue with Google",
              ),
              const SizedBox(height: 18),

              _socialButton(icon: Icons.apple, text: "Continue with Apple"),
              const SizedBox(height: 18),

              _socialButton(
                icon: Icons.facebook,
                text: "Continue with Facebook",
              ),

              const SizedBox(height: 30),

              // ✅ LOGIN BUTTON
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
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
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

  /// ✅ COMMON INPUT DECORATION
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
        borderSide:
            const BorderSide(color: AppThemeData.primary400, width: 2),
      ),
    );
  }

  /// ✅ SOCIAL BUTTON
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
