import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeaveItemCard extends StatelessWidget {
  final Map<String, dynamic> leave;

  const LeaveItemCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final String leaveType = leave['LeaveTypeName'] ?? 'Leave';
    final String fromDate = _formatDate(leave['LeaveDateFrom']);
    final String toDate = _formatDate(leave['LeaveDateTo']);
    final bool isApproved = leave['IsApproved'] == true;
    final String? reason = leave['LeaveApplyReason'];
    final String? rejectReason = leave['RejectReason'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Top Row ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leaveType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _statusChip(isApproved),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Date Range ───
          Text(
            "$fromDate  →  $toDate",
            style: const TextStyle(
              color: AppThemeData.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          // ─── Reason ───
          if (reason != null && reason.isNotEmpty)
            Text(
              "Reason: $reason",
              style: const TextStyle(fontSize: 13),
            ),

          if (!isApproved &&
              rejectReason != null &&
              rejectReason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "Rejected: $rejectReason",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statusChip(bool isApproved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isApproved ? "APPROVED" : "PENDING",
        style: TextStyle(
          fontSize: 12,
          color: isApproved ? Colors.green : Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static String _formatDate(String date) {
    final dt = DateTime.parse(date);
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}
