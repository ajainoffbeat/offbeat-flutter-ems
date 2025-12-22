import 'package:flutter/material.dart';
import 'package:ems_offbeat/app/leaves/leave_apply_sheet.dart';
import 'package:ems_offbeat/app/leaves/leave_dashboard_screen.dart';
import 'package:ems_offbeat/app/settings/settings_screen.dart';
import 'package:ems_offbeat/widgets/floating_bottom_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    LeaveScreen(),
    SettingsScreen(),
  ];

  void _openLeaveApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LeaveApplySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),

      /// 🔹 SWITCH SCREENS (no route push)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      /// ✅ BOTTOM NAV WITH CENTER ACTION
      bottomNavigationBar: FloatingBottomTabs(
        currentIndex: _currentIndex,
        onLeaveTap: () {
          setState(() => _currentIndex = 0);
        },
        onAddTap: () {
          _openLeaveApplySheet(context);
        },
        onSettingsTap: () {
          setState(() => _currentIndex = 1);
        },
      ),
    );
  }
}
