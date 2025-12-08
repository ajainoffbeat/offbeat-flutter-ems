import 'package:ems_offbeat/app/custom_input.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'package:flutter/material.dart';

class UpdatePasswordScreen extends StatelessWidget {
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData.surface,
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

                    // Back button aligned properly
                    IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppThemeData.primary500,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    

                    const SizedBox(height: 10),

                    // Headings
                    const ScreenHeading(text: "Update Password 🔒"),
                    const SizedBox(height: 6),
                    const ScreenSubtitle(
                      text:
                          "Enter your new password below to continue. Choose a strong and unique password.",
                    ),

                    const SizedBox(height: 30),

                    // Old Password
                    const TitleText(text: "Old Password"),
                    const SizedBox(height: 6),
                    CustomInput(
                      hint: "Old Password",
                      controller: newPassCtrl,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),
                    // New Password
                    const TitleText(text: "New Password"),
                    const SizedBox(height: 6),
                    CustomInput(
                      hint: "New Password",
                      controller: newPassCtrl,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    const TitleText(text: "Confirm Password"),
                    const SizedBox(height: 6),
                    CustomInput(
                      hint: "Confirm New Password",
                      controller: confirmPassCtrl,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Fixed Button (Consistent UI)
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
                  onPressed: () {},
                  child: const Text(
                    "Reset Password",
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
