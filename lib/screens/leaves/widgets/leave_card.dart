import 'package:flutter/material.dart';
import '../model/leave_model.dart';

class LeaveCard extends StatelessWidget {
  final LeaveModel leave;
  final bool isManager;
  final VoidCallback? onAccept;
  final Function(String reason)? onReject;

  const LeaveCard({
    super.key,
    required this.leave,
    this.isManager = false,
    this.onAccept,
    this.onReject,
  });

  void showRejectPopup(BuildContext context) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Reject Reason"),
        content: TextField(
          controller: reasonCtrl,
          decoration: InputDecoration(hintText: "Enter reason"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onReject?.call(reasonCtrl.text);
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

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
          ),
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
                Text(leave.type, style: const TextStyle(fontSize: 14)),

                // Manager Action Buttons
                if (isManager) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                           
                          ),
                          child: Text(
                          "Approve",
                          style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => showRejectPopup(context),
                          style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text("Reject"),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

         if(!isManager) ...[
          // status
          Text(
            _statusText(leave.status),
            style: TextStyle(
              color: _statusColor(leave.status),
              fontWeight: FontWeight.bold,
            ),
          ),
         ]
         
        ],
      ),
    );
  }
}
