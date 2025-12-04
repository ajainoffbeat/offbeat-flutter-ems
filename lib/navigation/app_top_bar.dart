import 'package:flutter/material.dart';
import 'package:ems_offbeat/widgets/notification/notification_bell.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: true,

      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage("assets/profile.png"),
        ),
      ),

      title: Image.asset(
        "assets/images/logo.png",
        height: 80,
      ),

      actions: [
        NotificationBell(
          onTap: () {
            Navigator.pushNamed(context, "/notifications");
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
