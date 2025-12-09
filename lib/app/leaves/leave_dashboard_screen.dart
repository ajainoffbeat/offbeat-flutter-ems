import 'package:ems_offbeat/app/leaves/leave_apply_sheet.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/empty_state.dart';
import 'package:ems_offbeat/widgets/leave_summary_card.dart';
import 'package:ems_offbeat/widgets/status_tab.dart';
import 'package:flutter/material.dart';

class LeaveScreen extends StatelessWidget {
 
 
 void _openLeaveApplySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const LeaveApplySheet(),
  );
}

  const LeaveScreen({super.key});
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppThemeData.primary500,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppThemeData.primary500,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
            _openLeaveApplySheet(context);
        },
      ),
      body: Stack(
        children: [
          _buildHeader(),   
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppThemeData.primary100, AppThemeData.primary500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(30, 100, 24, 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ready to escape the\nspreadsheet jungle?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Submit your leave, kick back, and recharge.",
            style: TextStyle(color: Color.fromARGB(179, 248, 248, 248)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      top: 300,
      height: screenHeight - 300,
      left: 0,
      right: 0,
      child: Container(
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
            const StatusTab(),
            const SizedBox(height: 30),
            const EmptyState(),
          ],
        ),
      ),
    );
  }
}
