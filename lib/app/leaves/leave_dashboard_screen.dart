import 'package:dropdown_search/dropdown_search.dart';
import 'package:ems_offbeat/providers/leave_provider.dart';
import 'package:ems_offbeat/providers/reporting_provider.dart';
import 'package:ems_offbeat/providers/role_provider.dart';
import 'package:ems_offbeat/services/api_service.dart' as LeaveService;
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/empty_state.dart';
import 'package:ems_offbeat/widgets/input_dialog.dart';
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
  int? _selectedUser;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(leaveProvider.notifier).refresh();
    });
  }

  /// 🔄 PULL TO REFRESH HANDLER
  Future<void> _onRefresh() async {
    final notifier = ref.read(leaveProvider.notifier);

    if (_leaveView == LeaveView.self) {
      await notifier.refresh();
    } else {
      await notifier.loadTeamLeaves(employeeId: _selectedUser ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    final isReportingAsync = ref.watch(isReportingProvider);
    final isSuperAdminAsync = ref.watch(isSuperAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to Ems Offbeat",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppThemeData.primary500,
      ),
      body: isReportingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Something went wrong")),
        data: (isReporting) {
          return isSuperAdminAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text("Something went wrong")),
            data: (isSuperAdmin) {
              return _buildContent(
                context,
                leaveState,
                isReporting: isReporting,
                isSuperAdmin: isSuperAdmin,
              );
            },
          );
        },
      ),
    );
  }

  // ───────── MAIN CONTENT ─────────
  Widget _buildContent(
    BuildContext context,
    dynamic leaveState, {
    required bool isReporting,
    required bool isSuperAdmin,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            //_buildTopSummaryCards(leaveState),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            if (isReporting && !isSuperAdmin)
              SliverToBoxAdapter(child: _buildAdminTabs()),

            if (isReporting && !isSuperAdmin)
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

            if (isReporting && !isSuperAdmin && _leaveView == LeaveView.team)
              SliverToBoxAdapter(child: _buildUserDropdown()),

            if (isReporting && !isSuperAdmin && _leaveView == LeaveView.team)
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

            if (!(isReporting && !isSuperAdmin && _leaveView == LeaveView.team))
              SliverToBoxAdapter(
                child: StatusTab(
                  onStatusChanged: (status) {
                    ref.read(leaveProvider.notifier).setFilter(status);
                  },
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: Divider()),

            _buildLeaveSliverList(leaveState, _leaveView),
          ],
        ),
      ),
    );
  }

  // ───────── TOP SUMMARY ─────────
  SliverToBoxAdapter _buildTopSummaryCards(dynamic leaveState) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            _selectedUser = 0;
          });

          final notifier = ref.read(leaveProvider.notifier);

          if (view == LeaveView.self) {
            notifier.setFilter("Pending");
            notifier.refresh();
          } else {
            notifier.loadTeamLeaves(employeeId: _selectedUser ?? 0);
          }
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? AppThemeData.primary500 : Colors.transparent,
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

  // ───────── USER DROPDOWN ─────────
 Widget _buildUserDropdown() {
  final leaveState = ref.watch(leaveProvider);

  if (leaveState.isLoadingTeamUsers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppThemeData.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppThemeData.primary500,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Loading team members...",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  return DropdownSearch<int>(
    items: (filter, infiniteScrollProps) => leaveState.teamUsers.keys.toList(),
    selectedItem: _selectedUser,
    itemAsString: (id) => leaveState.teamUsers[id] ?? "",
    popupProps: PopupProps.dialog(
      showSearchBox: true,
      title: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Select Team Member",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      searchFieldProps: TextFieldProps(
        decoration: InputDecoration(
          hintText: "Search team member...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dialogProps: DialogProps(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    decoratorProps: DropDownDecoratorProps(
      decoration: InputDecoration(
        labelText: "Select Team Member",
        filled: true,
        fillColor: AppThemeData.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    onChanged: (value) {
      setState(() => _selectedUser = value);
      ref.read(leaveProvider.notifier).setFilter("Pending");
      ref
          .read(leaveProvider.notifier)
          .loadTeamLeaves(employeeId: value ?? 0);
    },
  );
}

  // ───────── LEAVE LIST ─────────
  Widget _buildLeaveSliverList(dynamic leaveState, LeaveView leaveView) {
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
      delegate: SliverChildBuilderDelegate((context, index) {
        final leave = leaves[index];
        final int leaveId = leave['ID'];

        return LeaveItemCard(
          leave: leave,
          canApprove:
              (leaveView == LeaveView.team &&
              leave['IsApproved'] == false &&
              leave['IsRejected'] == false),
          onApprove: leaveView == LeaveView.team
              ? () async {
                  await LeaveService.approveLeave(leaveId, approve: true);
                  ref
                      .read(leaveProvider.notifier)
                      .loadTeamLeaves(employeeId: _selectedUser ?? 0);
                }
              : null,
          onReject: leaveView == LeaveView.team
              ? () async {
                  final reason = await showTextInputDialog(context);
                  if (reason != null) {
                    await LeaveService.approveLeave(
                      leaveId,
                      approve: false,
                      reason: reason,
                    );
                    ref
                        .read(leaveProvider.notifier)
                        .loadTeamLeaves(employeeId: _selectedUser ?? 0);
                  }
                }
              : null,
        );
      }, childCount: leaves.length),
    );
  }
}
