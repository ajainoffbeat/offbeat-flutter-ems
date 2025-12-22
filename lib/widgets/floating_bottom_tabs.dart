import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingBottomTabs extends StatelessWidget {
  final int currentIndex; // 0 = leave, 1 = settings
  final VoidCallback onLeaveTap;
  final VoidCallback onAddTap;
  final VoidCallback onSettingsTap;

  const FloatingBottomTabs({
    super.key,
    required this.currentIndex,
    required this.onLeaveTap,
    required this.onAddTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              icon: Icons.dashboard_outlined,
              label: "Leave",
              active: currentIndex == 0,
              onTap: onLeaveTap,
            ),

            /// ➕ CENTER ACTION
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppThemeData.primary500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

            _navItem(
              icon: Icons.settings_outlined,
              label: "Settings",
              active: currentIndex == 1,
              onTap: onSettingsTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final color =
        active ? AppThemeData.primary500 : Colors.grey.shade500;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight:
                    active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
