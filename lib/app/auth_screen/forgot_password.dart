import 'package:ems_offbeat/app/custom_input.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppThemeData.surface,   // Light background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppThemeData.primary500,   // Blue
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 100),

              // Illustration
              Center(
                child: Image.asset(
                  "assets/images/forgot.png",
                  height: 200,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Center(
                child: Text(
                  "Forgot password",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppThemeData.grey900,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              Center(
                child: Text(
                  "Enter your email account to reset\nyour password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppThemeData.grey600,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Email Input (REUSABLE)
              CustomInput(
                controller: emailCtrl,
                hint: "Email",
              ),

              const SizedBox(height: 25),

              // Reset Password Button (REUSABLE)
              PrimaryButton(
                text: "Reset Password",
                onTap: () {
                  Navigator.pushNamed(context, "/reset");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
