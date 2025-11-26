import 'package:ems_offbeat/widgets/notification/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_offbeat/providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context);

    final List<Map<String, dynamic>> dummyNotifications = [
      {
        "title": "Your leave request has been approved.",
        "time": "2 mins ago",
        "icon": Icons.check_circle,
      },
      {
        "title": "Your leave request has not been approved.",
        "time": "10 mins ago",
        "icon": Icons.cancel,
      },
      {
        "title": "New announcement from HR.",
        "time": "30 mins ago",
        "icon": Icons.campaign,
      },
      // {
      //   "title": "Timesheet pending for yesterday.",
      //   "time": "1 hour ago",
      //   "icon": Icons.timer,
      // },
      // {
      //   "title": "Weekly report is due tomorrow.",
      //   "time": "2 hours ago",
      //   "icon": Icons.article,
      // },
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Notifications"),
        actions: [
          TextButton(
            onPressed: () {
              notifProvider.clearNotifications();
            },
            child: const Text("Clear All"),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: dummyNotifications.length,
          itemBuilder: (context, i) {
            final item = dummyNotifications[i];
            return NotificationCard(
              title: item["title"],
              time: item["time"],
              icon: item["icon"],
            );
          },
        ),
      ),
    );
  }
}
