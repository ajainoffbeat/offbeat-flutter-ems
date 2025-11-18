import 'package:ems_offbeat/screens/custom_input.dart';
import 'package:ems_offbeat/screens/primary_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back arrow
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 100),

              // Illustration
              Center(
                child: Image.asset(
                  "assets/images/forgot.png",  // <--- use your image path
                  height: 200,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Center(
                child: Text(
                  "Forgot password",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
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
                    color: Colors.grey.shade600,
                    fontSize: 15,
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
