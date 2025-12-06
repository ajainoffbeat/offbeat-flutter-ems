import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:ems_offbeat/widgets/screen_subtitle.dart';
import 'package:ems_offbeat/widgets/screen_title.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

              // Back button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new),
              ),

              const SizedBox(height: 10),

              // Updated header widgets
              const ScreenTitle(text: "Welcome Back! 👋"),
              const SizedBox(height: 6),
              const ScreenSubtitle(
                text: "Log in and manage your HR tasks with ease",
              ),

              const SizedBox(height: 24),

              // Email Field
              TextField(
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),

                  filled: true, // enable background color
                  fillColor: AppThemeData.grey100, // soft grey

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none, // ⬅ removes border
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppThemeData.primary400, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off),
                 filled: true, // enable background color
                  fillColor: AppThemeData.grey100, // soft grey

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none, // ⬅ removes border
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppThemeData.primary400, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (v) {},
                    // activeColor:
                    //     AppThemeData.primary500, // ⬅ fill color when checked
                    checkColor: Colors.white, // ⬅ tick color
                    side: BorderSide(
                      color: AppThemeData.primary500,
                      width: 2,
                    ), // ⬅ optional: border color when unchecked
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // ⬅ curve amount
                    ),
                  ),

                  const Text("Remember me"),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppThemeData.primary500,
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

              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeData.primary500,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
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

  // Social Button Widget
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
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
