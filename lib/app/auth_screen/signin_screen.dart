import 'package:ems_offbeat/app/custom_input.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppThemeData.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- LOGO ---
              SizedBox(
                width: 200,  
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              // --- WELCOME IMAGE ---
              Image.asset(
                "assets/images/welcome.png",
                height: 150,   // reduced height
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              const Text(
                "Sign in now",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "Please sign in to continue our app",
                style: TextStyle(
                  color: AppThemeData.grey600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              CustomInput(
                controller: emailCtrl,
                hint: "Email",
              ),
              const SizedBox(height: 15),

              CustomInput(
                controller: passCtrl,
                hint: "Password",
                isPassword: true,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/forgot");
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color:AppThemeData.primary500),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              PrimaryButton(
                text: "Sign In",
                onTap: () {
                  Navigator.pushNamed(context, "/nav");
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
