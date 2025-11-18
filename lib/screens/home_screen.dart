import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/feature_grid.dart';
import '../widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HomeHeader(),
              SizedBox(height: 20),
              FeatureGrid(),
              SizedBox(height: 20),
              Text("Ongoing task",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              TaskCard(),
            ],
          ),
        ),
      ),
    );
  }
}
