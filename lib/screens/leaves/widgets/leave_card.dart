import 'package:flutter/material.dart';
import '../model/leave_model.dart';

class LeaveCard extends StatelessWidget {
  final LeaveModel leave;

  const LeaveCard({super.key, required this.leave});

  Color _statusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.accepted:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _statusText(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.accepted:
        return "Accepted";
      case LeaveStatus.rejected:
        return "Rejected";
      default:
        return "Submitted";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // vertical colored stripe
          Container(
            width: 4,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),

          // content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${leave.startDate} - ${leave.endDate}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  leave.type,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // status
          Text(
            _statusText(leave.status),
            style: TextStyle(
              color: _statusColor(leave.status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
