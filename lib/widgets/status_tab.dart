import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';


class StatusTab extends StatefulWidget {
  final Function(String status) onStatusChanged; // 👈 callback

  const StatusTab({super.key, required this.onStatusChanged});

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  String selectedTab = "Pending";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppThemeData.background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TabItem(
            title: "Pending",
            selected: selectedTab == "Pending",
            onTap: () => _changeTab("Pending"),
          ),
          _TabItem(
            title: "Approved",
            selected: selectedTab == "Approved",
            onTap: () => _changeTab("Approved"),
          ),
          _TabItem(
            title: "Rejected",
            selected: selectedTab == "Rejected",
            onTap: () => _changeTab("Rejected"),
          ),
        ],
      ),
    );
  }

  void _changeTab(String tab) {
    setState(() {
      selectedTab = tab;
    });

    widget.onStatusChanged(tab); // 👈 send selected tab to parent
  }
}



class _TabItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppThemeData.primary500 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : AppThemeData.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}