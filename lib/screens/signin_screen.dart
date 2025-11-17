import 'package:ems_offbeat/screens/custom_input.dart';
import 'package:ems_offbeat/screens/primary_button.dart';
import 'package:flutter/material.dart';


class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back arrow
              const SizedBox(height: 100),
              // Title
              // Illustration
              Center(
                child: Image.asset(
                  "assets/images/welcome.png",  // <--- use your image path
                  height: 200,
                ),
              ),
              const Text(
                "Sign in now",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight:  FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),

              // Subtitle
              Text(
                "Please sign in to continue our app",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              // Email Field
              CustomInput(
                controller: emailCtrl,
                hint: "Email",
              ),
              const SizedBox(height: 15),

              // Password Field
              CustomInput(
                controller: passCtrl,
                hint: "Password",
                isPassword: true,
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/forgot");
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xff006cf1)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Sign In Button (Reusable Button)
              PrimaryButton(
                text: "Sign In",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
