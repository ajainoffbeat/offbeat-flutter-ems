import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.inbox, size: 80, color: AppThemeData.textSecondary),
        SizedBox(height: 12),
        Text(
          "No Pending Requests!",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          "No leave requests in progress — maybe it's time to plan that getaway?",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppThemeData.textSecondary),
        ),
      ],
    );
  }
}
