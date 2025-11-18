import 'package:ems_offbeat/screens/forgot_password.dart';
import 'package:ems_offbeat/screens/reset_screen.dart';
import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Auth Demo",
      initialRoute: "/signin",
      routes: {
        "/signin": (_) => SignInScreen(),
        "/forgot": (_) =>  ForgotPasswordScreen(),
        "/reset": (_) =>  ResetPasswordScreen(),
      },
    );
  }
}
