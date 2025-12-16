import 'dart:async';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ems_offbeat/utils/token_storage.dart'; // ✅ ADD THIS

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // keep splash visible

    final token = await TokenStorage.getToken();
    // print("TOKENNNNNNNNNNNNNNNNNNNN: $token");

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // ✅ User already logged in
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ✅ New / Logged out user
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppThemeData.primary500,
              Colors.white,
              Color.fromARGB(186, 216, 233, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset('assets/images/logo.png'),
                ),
                const SizedBox(height: 40),
                const SpinKitCircle(
                  color: AppThemeData.primary500,
                  size: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
