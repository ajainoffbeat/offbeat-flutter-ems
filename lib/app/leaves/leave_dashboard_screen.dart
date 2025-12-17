// lib/app/leaves/leave_screen.dart
import 'package:ems_offbeat/app/leaves/leave_apply_sheet.dart';
import 'package:ems_offbeat/providers/leave_provider.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:ems_offbeat/widgets/empty_state.dart';
import 'package:ems_offbeat/widgets/leave_item_card.dart';
import 'package:ems_offbeat/widgets/leave_summary_card.dart';
import 'package:ems_offbeat/widgets/status_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  void _openLeaveApplySheet(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LeaveApplySheet(),
    );

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveState = ref.watch(leaveProvider);

    return Scaffold(
      backgroundColor: AppThemeData.primary500,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 90,
        ), // 👈 adjust to match tab height
        child: FloatingActionButton(
          backgroundColor: AppThemeData.primary500,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _openLeaveApplySheet(context, ref),
        ),
      ),

      body: Stack(
        children: [_buildHeader(), _buildContent(context, ref, leaveState)],
      ),
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
  Widget _buildContent(BuildContext context, WidgetRef ref, leaveState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.70,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                LeaveSummaryCard(
                  title: "Annual Leave Remaining",
                  value: "${leaveState.annualLeaveRemaining}",
                  icon: Icons.event_available,
                ),
                const SizedBox(width: 12),
                LeaveSummaryCard(
                  title: "Used Leave Balance",
                  value: "${leaveState.usedLeaveBalance}",
                  icon: Icons.event_busy,
                ),
              ],
            ),
            const SizedBox(height: 30),
            StatusTab(
              onStatusChanged: (val) {
                ref.read(leaveProvider.notifier).setFilter(val);
              },
            ),
            const SizedBox(height: 30),
            Expanded(child: _buildLeaveList(ref, leaveState)),
          ],
        ),
      ),
    );
  }

  // ───────── LEAVE LIST ─────────
  Widget _buildLeaveList(WidgetRef ref, leaveState) {
    if (leaveState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (leaveState.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leaveState.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(leaveProvider.notifier).refresh();
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final leaves = leaveState.filteredLeaves;

    if (leaves.isEmpty) {
      return const Center(child: EmptyState());
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(leaveProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: leaves.length,
        itemBuilder: (context, index) {
          return LeaveItemCard(leave: leaves[index]);
        },
      ),
    );
  }
}
