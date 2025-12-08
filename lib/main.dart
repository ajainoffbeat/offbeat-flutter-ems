import 'package:ems_offbeat/app/leaves/leave_dashboard_screen.dart';
import 'package:ems_offbeat/navigation/bottom_nav.dart';
import 'package:ems_offbeat/app/auth_screen/forgot_password.dart';
import 'package:ems_offbeat/app/notification_screen/notification.dart';
import 'package:ems_offbeat/app/auth_screen/reset_screen.dart';
import 'package:flutter/material.dart';
import 'app/auth_screen/login_screen.dart';
import 'app/onboarding_screens/onboarding_screen.dart';
import 'app/splash_screen.dart';
import 'app/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/notification_provider.dart';
 
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final p = NotificationProvider();
 
            // Add dummy notifications here
            p.addNotification();
            p.addNotification();
            p.addNotification();
 
            return p;
          },
        ),
      ],
      child: const MyApp(),
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
        "/forgot": (_) => ForgotPasswordScreen(),
        "/reset": (_) => ResetPasswordScreen(),
        '/home': (_) => HomeScreen(),
        '/leaves': (_) => const LeaveScreen(),
        "/notifications": (_) => const NotificationsScreen(),
      },
    );
  }
}
 