import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LeaveItemCard extends StatelessWidget {
  final Map<String, dynamic> leave;

  /// 👤 User info (for Team view)
  final String? userName;

  /// 🔐 Approval control
  final bool canApprove;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const LeaveItemCard({
    super.key,
    required this.leave,
    this.userName,
    this.canApprove = false,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final String leaveType = leave['LeaveTypeName'] ?? 'Leave';
   
    final String fromDate = _formatDate(leave['LeaveDateFrom']);
    final String toDate = _formatDate(leave['LeaveDateTo']);

    final bool isApproved = leave['IsApproved'] == true;
    final String? rejectReason = leave['RejectReason'];
    final String? reason = leave['LeaveApplyReason'];

    final _LeaveStatus status = _resolveStatus(
      isApproved: isApproved,
      rejectReason: rejectReason,
    );

  String userName = '${leave['FirstName'] ?? ''} ${leave['LastName'] ?? ''}'.trim();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── User Name (Team View) ───
          if (userName.isNotEmpty && canApprove) ...[
            Row(
              children: [
                const Icon(Icons.person, size: 25, color: AppThemeData.textSecondary),
                const SizedBox(width: 6),
                Text(
                 userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // ─── Header ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leaveType,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
                _statusChip(status),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Date Range ───
          Text(
            "$fromDate  →  $toDate",
            style: const TextStyle(color: AppThemeData.textSecondary),
          ),

          const SizedBox(height: 10),

          // ─── Reason ───
          if (reason != null && reason.isNotEmpty)
            Text(
              "Reason: $reason",
              style: const TextStyle(fontSize: 13),
            ),

          // ─── Rejection Reason ───
          if (status == _LeaveStatus.rejected &&
              rejectReason != null &&
              rejectReason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "Rejected: $rejectReason",
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),

          // ─── Approve / Reject Buttons ───
          if (canApprove &&
              (status == _LeaveStatus.pending ||
                  status == _LeaveStatus.rejected)) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Approve"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ───────── STATUS CHIP ─────────
  Widget _statusChip(_LeaveStatus status) {
    late Color bgColor;
    late Color textColor;
    late String label;

    switch (status) {
      case _LeaveStatus.approved:
        bgColor = Colors.green.shade50;
        textColor = Colors.green;
        label = "APPROVED";
        break;
      case _LeaveStatus.rejected:
        bgColor = Colors.red.shade50;
        textColor = Colors.red;
        label = "REJECTED";
        break;
      case _LeaveStatus.pending:
      default:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange;
        label = "PENDING";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ───────── STATUS RESOLVER ─────────
  _LeaveStatus _resolveStatus({
    required bool isApproved,
    required String? rejectReason,
  }) {
    if (isApproved) return _LeaveStatus.approved;
    if (rejectReason != null && rejectReason.isNotEmpty) {
      return _LeaveStatus.rejected;
    }
    return _LeaveStatus.pending;
  }

  static String _formatDate(String date) {
    final dt = DateTime.parse(date);
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}

// ───────── INTERNAL STATUS ENUM ─────────
enum _LeaveStatus { approved, pending, rejected }
