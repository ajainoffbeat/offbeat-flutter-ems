import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     const CircleAvatar(
          //       radius: 28,
          //       backgroundImage: AssetImage("assets/user.jpg"), // your image
          //     ),
          //     const SizedBox(width: 12),
          //     const Text("Employee Hub",
          //       style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
          //     ),
          //     const Spacer(),
          //     Icon(Icons.notifications_outlined, color: Colors.black54),
          //   ],
          // ),
          const SizedBox(height: 20),

          /// Attendance Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffeef7ff),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text("Attendance", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                    Spacer(),
                    Text("10:15 AM", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("Good Morning Muhammad 👋"),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                    child: const Text("Check In / Out",style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
