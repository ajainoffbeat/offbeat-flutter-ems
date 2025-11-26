import 'package:ems_offbeat/navigation/bottom_nav.dart';
import 'package:ems_offbeat/screens/forgot_password.dart';
import 'package:ems_offbeat/screens/leaves/leave_request_screen.dart';
import 'package:ems_offbeat/screens/leaves/leaves_screen.dart';
import 'package:ems_offbeat/screens/notification/notification.dart';
import 'package:ems_offbeat/screens/reset_screen.dart';
import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/notification_provider.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final p = NotificationProvider();

          // Add dummy notifications here
          p.addNotification();
          p.addNotification();
          p.addNotification();

          return p;
        }),
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
        '/splash': (context) => const SplashScreen(),
        "/signin": (_) => SignInScreen(),
        "/forgot": (_) =>  ForgotPasswordScreen(),
        "/reset": (_) =>  ResetPasswordScreen(),
        '/home':(_) => HomeScreen(),
        '/leaves': (_) => const LeavesScreen(role: "manager"),
        '/leave-request': (_) => const LeaveRequestScreen(),
         "/notifications": (context) => const NotificationsScreen(),
      },
    );
  }
}
