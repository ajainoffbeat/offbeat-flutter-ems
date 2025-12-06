import 'dart:async';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

    // Auto navigation
    Timer(const Duration(seconds: 5), () {
      // Navigator.pushReplacementNamed(context, '/signin');
      Navigator.pushReplacementNamed(context, '/onboarding');

    });
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
              AppThemeData.primary500, // NEW COLOR #6e61ff
              Colors.white,
              Color.fromARGB(186, 216, 233, 255), // soft grey
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
                // Logo
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset('assets/images/logo.png'),
                ),

                const SizedBox(height: 40),

                // White SpinKit Loader
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
