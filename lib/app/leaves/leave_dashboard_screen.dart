import 'package:ems_offbeat/app/leaves/leave_apply_sheet.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/empty_state.dart';
import 'package:ems_offbeat/widgets/leave_summary_card.dart';
import 'package:ems_offbeat/widgets/status_tab.dart';
import 'package:flutter/material.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});
  
  void _openLeaveApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LeaveApplySheet(),
    );
  }

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                _buildHeader(constraints),
                _buildContent(context, constraints),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    
    // Responsive font sizes
    final titleFontSize = screenWidth < 360 ? 24.0 : (screenWidth < 400 ? 26.0 : 30.0);
    final subtitleFontSize = screenWidth < 360 ? 13.0 : 14.0;
    
    // Responsive padding
    final horizontalPadding = screenWidth < 360 ? 20.0 : (screenWidth < 400 ? 24.0 : 30.0);
    final topPadding = screenHeight < 600 ? 60.0 : (screenHeight < 700 ? 80.0 : 100.0);
    
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppThemeData.primary500, AppThemeData.primary100],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ready to escape the\nspreadsheet jungle?",
            style: TextStyle(
              color: Colors.white,
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Submit your leave, kick back, and recharge.",
            style: TextStyle(
              color: const Color.fromARGB(179, 248, 248, 248),
              fontSize: subtitleFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BoxConstraints constraints) {
    final screenHeight = constraints.maxHeight;
    final screenWidth = constraints.maxWidth;
    
    // Responsive top position
    final topPosition = screenHeight < 600 ? screenHeight * 0.35 : 
                       (screenHeight < 700 ? screenHeight * 0.38 : 
                       (screenHeight < 800 ? screenHeight * 0.40 : 300.0));
    
    // Responsive padding
    final contentPadding = screenWidth < 360 ? 16.0 : 20.0;
    
    // Responsive spacing
    final cardSpacing = screenWidth < 360 ? 8.0 : 12.0;
    final sectionSpacing = screenHeight < 600 ? 20.0 : 30.0;
    
    return Positioned(
      top: topPosition,
      height: screenHeight - topPosition,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(contentPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: LeaveSummaryCard(
                      title: "Annual Leave Remaining",
                      value: "18",
                      icon: Icons.event_available,
                    ),
                  ),
                  SizedBox(width: cardSpacing),
                  Expanded(
                    child: LeaveSummaryCard(
                      title: "Used Leave Balance",
                      value: "6",
                      icon: Icons.event_busy,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sectionSpacing),
              const StatusTab(),
              SizedBox(height: sectionSpacing),
              const EmptyState(),
            ],
          ),
        ),
      ),
    );
  }
}