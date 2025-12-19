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
                      TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Old Password",
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

                    const SizedBox(height: 20),
                    // New Password
                    const TitleText(text: "New Password"),
                    const SizedBox(height: 6),
                      TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
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

                    const SizedBox(height: 20),

                    // Confirm Password
                    const TitleText(text: "Confirm Password"),
                    const SizedBox(height: 6),
                      TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm New Password",
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
