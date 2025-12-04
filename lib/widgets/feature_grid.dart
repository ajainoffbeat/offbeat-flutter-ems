import 'package:flutter/material.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  final List<Map<String, dynamic>> features = const [
    {"icon": Icons.calendar_today, "label": "Leaves"},
    {"icon": Icons.access_time, "label": "Attendance"},
    {"icon": Icons.people, "label": "Meetings"},
    {"icon": Icons.payments, "label": "Salary"},
    {"icon": Icons.newspaper, "label": "News"},
    {"icon": Icons.business, "label": "Company"},
    {"icon": Icons.group, "label": "Our Team"},
    {"icon": Icons.health_and_safety, "label": "Insurance"},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: .9,
      ),
      itemCount: features.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            if (features[i]["label"] == "Leaves") {
              Navigator.pushNamed(context, '/leaves');
            }
              if (features[i]["label"] == "Attendance") {
              Navigator.pushNamed(context, '/manage-leaves');
            }
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xffd8f5ff),
                  shape: BoxShape.circle,
                ),
                child: Icon(features[i]["icon"], color: Colors.blue, size: 26),
              ),
              const SizedBox(height: 6),
              Text(features[i]["label"], style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
