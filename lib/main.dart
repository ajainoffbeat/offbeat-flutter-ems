import 'package:ems_offbeat/app/settings/update_password.dart';
import 'package:ems_offbeat/app/settings/settings_screen.dart';
import 'package:ems_offbeat/navigation/bottom_nav.dart';
import 'package:ems_offbeat/app/leaves/leave_dashboard_screen.dart';
import 'package:ems_offbeat/app/notification_screen/notification.dart';
import 'package:ems_offbeat/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/auth_screen/login_screen.dart';
import 'app/onboarding_screens/onboarding_screen.dart';
import 'app/splash_screen.dart';
import 'app/home/home_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

Future<void> requestInitialPermissions() async {
  await Permission.camera.request();

  if (Platform.isIOS) {
    await Permission.photos.request();
  } else {
    await Permission.storage.request();
  }
  await Permission.notification.request();
}


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

    await NotificationService.init();

print("thiis is notificatiioon");
  NotificationService.show(
    title: message.notification?.title ?? 'New Notification',
    body: message.notification?.body ?? '',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestInitialPermissions();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await NotificationService.init();

    FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("thiis is notificatiioon");
      NotificationService.show(
        title: message.notification?.title ?? 'No title',
        body: message.notification?.body ?? 'No body',
        payload: message.data.toString(),
      );

    });
  }

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
        "/updatePassword": (_) => UpdatePasswordScreen(),
        '/home': (_) => HomeScreen(),
        '/leaves': (_) => const LeaveScreen(),
        "/notifications": (_) => const NotificationsScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
