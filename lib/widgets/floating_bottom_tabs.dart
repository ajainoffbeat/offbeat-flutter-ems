import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingBottomTabs extends StatelessWidget {
  final VoidCallback onDashboardTap;
  final VoidCallback onSettingsTap;
  final int currentIndex; // 0 = dashboard, 1 = settings

  const FloatingBottomTabs({
    super.key,
    required this.onDashboardTap,
    required this.onSettingsTap,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabItem(
                icon: Icons.dashboard_outlined,
                label: "Dashboard",
                isActive: currentIndex == 0,
                onTap: onDashboardTap,
              ),
              _tabItem(
                icon: Icons.settings_outlined,
                label: "Settings",
                isActive: currentIndex == 1,
                onTap: onSettingsTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color =
        isActive ? AppThemeData.primary500 : Colors.grey.shade500;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
