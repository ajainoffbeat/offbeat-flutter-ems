import 'package:flutter/material.dart';
import 'model/leave_model.dart';
import 'widgets/leave_card.dart';
import 'widgets/leave_filter_bar.dart';

class LeavesScreen extends StatefulWidget {
  const LeavesScreen({super.key});

  @override
  State<LeavesScreen> createState() => _LeavesScreenState();
}

class _LeavesScreenState extends State<LeavesScreen> {
  int selectedTab = 0;

  final List<LeaveModel> leaves = [
    LeaveModel(
      startDate: "25/5/2023",
      endDate: "25/5/2023",
      type: "Short Leave",
      status: LeaveStatus.submitted,
    ),
    LeaveModel(
      startDate: "5/5/2023",
      endDate: "6/5/2023",
      type: "Full-day Leave",
      status: LeaveStatus.accepted,
    ),
    LeaveModel(
      startDate: "14/5/2023",
      endDate: "17/4/2023",
      type: "Full-day Leave",
      status: LeaveStatus.rejected,
    ),
  ];

  List<LeaveModel> get filteredLeaves {
    switch (selectedTab) {
      case 1:
        return leaves.where((l) => l.status == LeaveStatus.accepted).toList();
      case 2:
        return leaves.where((l) => l.status == LeaveStatus.submitted).toList();
      case 3:
        return leaves.where((l) => l.status == LeaveStatus.rejected).toList();
      default:
        return leaves;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),
      body: SafeArea(
        child: Column(
          children: [
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
               
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    "Leaves",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  
                  const SizedBox(width: 40),
                ],
              ),
            ),

        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: LeaveFilterBar(
                selectedIndex: selectedTab,
                onChanged: (index) {
                  setState(() => selectedTab = index);
                },
              ),
            ),

            const SizedBox(height: 10),

        
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  itemCount: filteredLeaves.length,
                  itemBuilder: (_, i) => LeaveCard(leave: filteredLeaves[i]),
                ),
              ),
            ),

       
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/leave-request');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Leave Request",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
