import 'package:ems_offbeat/app/leaves/leave_apply_sheet.dart';
import 'package:ems_offbeat/model/leaveType.dart';
import 'package:ems_offbeat/services/leave_service.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:ems_offbeat/widgets/empty_state.dart';
import 'package:ems_offbeat/widgets/leave_item_card.dart';
import 'package:ems_offbeat/widgets/leave_summary_card.dart';
import 'package:ems_offbeat/widgets/status_tab.dart';
import 'package:flutter/material.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
  
}

class _LeaveScreenState extends State<LeaveScreen> {
  late Future<List<dynamic>> _leavesFuture;
  List<LeaveType> allLeaves = []; 
  List<LeaveType> filteredLeaves = [];

  @override
  void initState() {
    super.initState();
    loadLeaves();
    _leavesFuture = LeaveService.getMyLeaves(); // ✅ API CALL
  }

  void _openLeaveApplySheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LeaveApplySheet(),
    );
    //     await TokenStorage.clearToken();
    // Navigator.pushReplacementNamed(context, '/login');
  }

  String _currentFilter = "Pending";

void loadLeaves() async {
print("ALL LEAVES:fsdgfdgfdgfdddddddddddddddddddddddddddddddddd");
  allLeaves = await fetchLeaveTypes(); // your API call
  print("ALL LEAVES: $allLeaves");
  applyFilter();
}

void applyFilter() {
  setState(() {
    filteredLeaves = allLeaves.where((leave) {
      return leave.IsApproved == _currentFilter; // "Pending", "Approved", "Rejected"
    }).toList();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData.primary500,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppThemeData.primary500,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _openLeaveApplySheet,
      ),
      body: Stack(children: [_buildHeader(), _buildContent(context)]),
    );
  }

  // ───────── HEADER ─────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 100, 24, 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ready to escape the\nspreadsheet jungle?",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          SizedBox(height: 8),
          Text(
            "Submit your leave, kick back, and recharge.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ───────── CONTENT ─────────
  Widget _buildContent(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.70, // bottom card height
        width: double.infinity, // ✅ FIX width issue
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Row(
              children: const [
                LeaveSummaryCard(
                  title: "Annual Leave Remaining",
                  value: "18",
                  icon: Icons.event_available,
                ),
                SizedBox(width: 12),
                LeaveSummaryCard(
                  title: "Used Leave Balance",
                  value: "6",
                  icon: Icons.event_busy,
                ),
              ],
            ),
            const SizedBox(height: 30),
            StatusTab(
              onStatusChanged: (val) {
                setState(() {
                  _currentFilter = val;
                });
                applyFilter();
              },
            ),
            const SizedBox(height: 30),

            Expanded(child: _buildLeaveList()),
          ],
        ),
      ),
    );
  }

  // ───────── LEAVE LIST ─────────
  Widget _buildLeaveList() {
    return FutureBuilder<List<dynamic>>(
      future: _leavesFuture,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load leaves"));
        }
        final leaves = snapshot.data ?? [];
        if (leaves.isEmpty) {
          return const Center(child: EmptyState());
        }

        return ListView.builder(
          itemCount: leaves.length,
          itemBuilder: (context, index) {
            return LeaveItemCard(leave: leaves[index]);
          },
        );
      },
    );
  }
}



