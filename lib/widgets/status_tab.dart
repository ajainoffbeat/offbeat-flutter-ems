import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';


class StatusTab extends StatelessWidget {
  const StatusTab({super.key});

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
        children: const [
          _TabItem(title: "Pending", selected: true),
          _TabItem(title: "Approved"),
          _TabItem(title: "Rejected"),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool selected;

  const _TabItem({required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
