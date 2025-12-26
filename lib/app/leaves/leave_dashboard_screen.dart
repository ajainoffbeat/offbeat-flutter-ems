import 'package:ems_offbeat/app/leaves/leave_apply_sheet.dart';
import 'package:ems_offbeat/providers/leave_provider.dart';
import 'package:ems_offbeat/providers/reporting_provider.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/empty_state.dart';
import 'package:ems_offbeat/widgets/leave_item_card.dart';
import 'package:ems_offbeat/widgets/leave_summary_card.dart';
import 'package:ems_offbeat/widgets/status_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LeaveView { self, team }

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  LeaveView _leaveView = LeaveView.self;
  String? _selectedUser;

  final List<String> teamUsers = [
    "Amit Jain",
    "Rahul Sharma",
    "Neha Verma",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(leaveProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    final isReportingAsync = ref.watch(isReportingProvider);

    return Scaffold(
      backgroundColor: AppThemeData.primary500,
      body: isReportingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Something went wrong")),
        data: (isReporting) {
          return Stack(
            children: [
              _buildHeader(),
              _buildContent(context, leaveState, isReporting),
            ],
          );
        },
      ),
    );
  }

  // ───────── HEADER ─────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ready to escape the\nspreadsheet jungle?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Submit your leave, kick back, and recharge.",
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ───────── CONTENT (SCROLLABLE) ─────────
  Widget _buildContent(
      BuildContext context, leaveState, bool isReporting) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.68,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// 📊 SUMMARY
            SliverToBoxAdapter(
              child: Row(
                children: [
                  LeaveSummaryCard(
                    title: "Annual Left",
                    value: "${leaveState.annualLeaveRemaining}",
                    icon: Icons.event_available,
                  ),
                  const SizedBox(width: 12),
                  LeaveSummaryCard(
                    title: "Used",
                    value: "${leaveState.usedLeaveBalance}",
                    icon: Icons.event_busy,
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            /// 🔐 ADMIN TABS
            if (isReporting)
              SliverToBoxAdapter(child: _buildAdminTabs()),

            if (isReporting)
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

            /// 👥 TEAM USER DROPDOWN
            if (isReporting && _leaveView == LeaveView.team)
              SliverToBoxAdapter(child: _buildUserDropdown()),

            if (isReporting && _leaveView == LeaveView.team)
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

            /// 📌 STATUS FILTER
            if (!(isReporting && _leaveView == LeaveView.team))
              SliverToBoxAdapter(
                child: StatusTab(
                  onStatusChanged: (status) {
                    ref.read(leaveProvider.notifier).setFilter(status);
                  },
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: Divider()),

            /// 📃 LEAVE LIST
            _buildLeaveSliverList(leaveState),
          ],
        ),
      ),
    );
  }

  // ───────── ADMIN TABS ─────────
  Widget _buildAdminTabs() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppThemeData.background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _adminTab("My Leaves", LeaveView.self),
          _adminTab("Team Leaves", LeaveView.team),
        ],
      ),
    );
  }

  Widget _adminTab(String title, LeaveView view) {
    final isSelected = _leaveView == view;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _leaveView = view;
            _selectedUser = null;
          });

          final notifier = ref.read(leaveProvider.notifier);

          if (view == LeaveView.team) {
            notifier.setFilter("Pending");
          }

          notifier.refresh();
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color:
                isSelected ? AppThemeData.primary500 : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ───────── TEAM USER DROPDOWN ─────────
  Widget _buildUserDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUser,
      decoration: InputDecoration(
        labelText: "Select Team Member",
        filled: true,
        fillColor: AppThemeData.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: teamUsers
          .map(
            (user) => DropdownMenuItem(
              value: user,
              child: Text(user),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() => _selectedUser = value);
        ref.read(leaveProvider.notifier).setFilter("Pending");
        ref.read(leaveProvider.notifier).refresh();
      },
    );
  }

  // ───────── LEAVE LIST (SLIVER) ─────────
  Widget _buildLeaveSliverList(leaveState) {
    if (leaveState.isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (leaveState.errorMessage != null) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            leaveState.errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final leaves = leaveState.filteredLeaves;

    if (leaves.isEmpty) {
      return const SliverFillRemaining(child: EmptyState());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return LeaveItemCard(leave: leaves[index]);
        },
        childCount: leaves.length,
      ),
    );
  }
}
