import 'package:ems_offbeat/screens/custom_input.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  final newPassCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomInput(
              hint: "New Password",
              controller: newPassCtrl,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CustomInput(
              hint: "Confirm New Password",
              controller: confirmPassCtrl,
              isPassword: true,
            ),
          ],
        ),
      ),
    );
  }
}
