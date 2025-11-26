import 'package:ems_offbeat/app/custom_input.dart';
import 'package:ems_offbeat/widgets/primary_button.dart' show PrimaryButton;
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ← back button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              // 🔒 Illustration
              Center(
                child: Image.asset(
                  "assets/images/reset.png",  // your lock image
                  height: 200,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // New Password
              CustomInput(
                hint: "New Password",
                controller: newPassCtrl,
                isPassword: true,
              ),

              const SizedBox(height: 16),

              // Confirm New Password
              CustomInput(
                hint: "Confirm New Password",
                controller: confirmPassCtrl,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              // RESET PASSWORD BUTTON
              PrimaryButton(
                text: "Reset Password",
                onTap: () {
                  // Your logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
