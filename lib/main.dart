import 'package:ems_offbeat/navigation/bottom_nav.dart';
import 'package:ems_offbeat/screens/forgot_password.dart';
import 'package:ems_offbeat/screens/leaves/leave_request_screen.dart';
import 'package:ems_offbeat/screens/leaves/leaves_screen.dart';
import 'package:ems_offbeat/screens/reset_screen.dart';
import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

// ADD THESE
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// HANDLE NOTIFICATION IN BACKGROUND
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("BACKGROUND MESSAGE: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // INITIALIZE FIREBASE
  await Firebase.initializeApp();

  // SET BACKGROUND HANDLER
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
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
    print("🔥 initState triggered");
    initPushNotification();
  }

  // REQUEST PERMISSION + GET TOKEN + FOREGROUND HANDLING
  void initPushNotification() async {
     print("🔥 initPushNotification called");
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Permission for iOS & Android 13+
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    print(" 🔥  NOTIFICATION PERMISSION: ${settings.authorizationStatus}");

    // Get FCM Token
    String? token = await messaging.getToken();
    print(" 🔥  FCM DEVICE TOKEN: $token");

    // Foreground message listener
    FirebaseMessaging.onMessage.listen((message) {
      print("🔥 FOREGROUND MESSAGE: ${message.notification?.title}");
    });

    // When app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("🔥 OPENED APP FROM NOTIFICATION: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/signin',
      routes: {
        '/nav': (_) => const BottomNav(),
        // '/splash': (context) => const SplashScreen(),
        "/signin": (_) => SignInScreen(),
        "/forgot": (_) => ForgotPasswordScreen(),
        "/reset": (_) => ResetPasswordScreen(),
        '/home': (_) => HomeScreen(),
        '/leaves': (_) => const LeavesScreen(role: "employees"),
        '/leave-request': (_) => const LeaveRequestScreen(),
      },
    );
  }
}
