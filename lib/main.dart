import 'package:ems_offbeat/app/auth_screen/update_password.dart';
import 'package:ems_offbeat/app/settings/settings_screen.dart';
import 'package:ems_offbeat/navigation/bottom_nav.dart';
import 'package:ems_offbeat/app/leaves/leave_dashboard_screen.dart';
import 'package:ems_offbeat/app/notification_screen/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/auth_screen/login_screen.dart';
import 'app/onboarding_screens/onboarding_screen.dart';
import 'app/splash_screen.dart';
import 'app/home/home_screen.dart';

 
void main() {
   runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/nav': (_) => const BottomNav(),
        '/splash': (_) => const SplashScreen(),
        "/onboarding": (_) => const OnboardingScreen(),
        "/login": (_) => LoginScreen(),
        "/updatePassword":(_) => UpdatePasswordScreen(),
        '/home': (_) => HomeScreen(),
        '/leaves': (_) => const LeaveScreen(),
        "/notifications": (_) => const NotificationsScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
 