import 'package:flutter/material.dart';
import 'package:ems_offbeat/app/leaves/leave_dashboard_screen.dart';
import 'package:ems_offbeat/widgets/floating_bottom_tabs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),
      body: Stack(
        children: [
          // 🔹 Active screen
          const LeaveScreen(),

          // 🔹 Floating bottom navigation
          FloatingBottomTabs(
            currentIndex: 0,
            onDashboardTap: () {
              Navigator.pushNamed(context,'/home');
            },
            onSettingsTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
