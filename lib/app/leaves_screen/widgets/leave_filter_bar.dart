import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LeaveFilterBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const LeaveFilterBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab("All", 0),
          _buildTab("Accepted", 1),
          _buildTab("Submitted", 2),
          _buildTab("Rejected", 3),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool isActive = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppThemeData.primary400 : AppThemeData.grey200,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isActive ? AppThemeData.primary400 : AppThemeData.grey200,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
