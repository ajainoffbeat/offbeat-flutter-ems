import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../repository/leave_repository.dart';
import '../state/leave_state.dart';
import '../services/api_service.dart';

/// PROVIDER: Leave Repository
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepository(client: http.Client());
});

/// PROVIDER: Leave Controller
final leaveProvider =
    NotifierProvider<LeaveController, LeaveState>(LeaveController.new);

class LeaveController extends Notifier<LeaveState> {
  @override
  LeaveState build() {
    // 🚫 DO NOT call APIs here
    return const LeaveState();
  }

  /// ===============================
  /// LOAD MY LEAVES
  /// ===============================
  Future<void> loadMyLeaves() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final repo = ref.read(leaveRepositoryProvider);
      final result = await repo.getMyLeaves();

      final int code = result["statusCode"];
      final data = result["data"];

      if (code == 200) {
        // ✅ SAFE PARSING
        final leavesData = data['leaves']?['data'] ?? [];

        state = state.copyWith(
          isLoading: false,
          myLeaves: List<Map<String, dynamic>>.from(leavesData),
          filteredLeaves: List<Map<String, dynamic>>.from(leavesData),
        );

        // 🔄 Apply current filter AFTER state update
        applyFilter();
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Failed to load leaves",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Something went wrong: $e",
      );
    }
  }

  /// ===============================
  /// LOAD LEAVE TYPES
  /// ===============================
  Future<void> loadLeaveTypes() async {
    state = state.copyWith(isLoadingLeaveTypes: true);

    try {
      final leaveTypes = await fetchLeaveTypes();

      state = state.copyWith(
        isLoadingLeaveTypes: false,
        leaveTypes: leaveTypes,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLeaveTypes: false,
        errorMessage: "Failed to load leave types: $e",
      );
    }
  }

  /// ===============================
  /// SET FILTER
  /// ===============================
  void setFilter(String filter) {
    state = state.copyWith(currentFilter: filter);
    applyFilter();
  }

  /// ===============================
  /// APPLY FILTER (PURE LOGIC)
  /// ===============================
  void applyFilter() {
    final leaves = state.myLeaves;

    if (leaves.isEmpty) {
      state = state.copyWith(filteredLeaves: []);
      return;
    }

    final filtered = leaves.where((leave) {
      final bool isApproved = leave['IsApproved'] == true;
      final bool isRejected = leave['IsRejected'] == true;

      if (isRejected) return state.currentFilter == "Rejected";
      if (isApproved) return state.currentFilter == "Approved";
      return state.currentFilter == "Pending";
    }).toList();

    state = state.copyWith(filteredLeaves: filtered);
  }

  /// ===============================
  /// APPLY LEAVE
  /// ===============================
  Future<void> applyLeave({
    required int leaveTypeId,
    required String leaveDateFrom,
    required String leaveDateTo,
    required String reason,
  }) async {
    state = state.copyWith(
      isApplyingLeave: true,
      applyLeaveSuccess: false,
      applyLeaveMessage: null,
    );

    try {
      final repo = ref.read(leaveRepositoryProvider);
      final result = await repo.applyLeave(
        leaveTypeId: leaveTypeId,
        leaveDateFrom: leaveDateFrom,
        leaveDateTo: leaveDateTo,
        reason: reason,
      );

      final code = result["statusCode"];
      final data = result["data"];

      if (code == 200) {
        state = state.copyWith(
          isApplyingLeave: false,
          applyLeaveSuccess: true,
          applyLeaveMessage:
              data["message"] ?? "Leave applied successfully",
        );

        // 🔄 Reload list
        await loadMyLeaves();
      } else {
        state = state.copyWith(
          isApplyingLeave: false,
          applyLeaveSuccess: false,
          applyLeaveMessage:
              data["message"] ?? "Failed to apply leave",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isApplyingLeave: false,
        applyLeaveSuccess: false,
        applyLeaveMessage: "Something went wrong: $e",
      );
    }
  }

  /// ===============================
  /// REFRESH (CALL FROM UI)
  /// ===============================
  Future<void> refresh() async {
    await Future.wait([
      loadMyLeaves(),
      loadLeaveTypes(),
    ]);
  }

  /// ===============================
  /// RESET APPLY STATE
  /// ===============================
  void resetApplyLeaveState() {
    state = state.copyWith(
      isApplyingLeave: false,
      applyLeaveSuccess: false,
      applyLeaveMessage: null,
    );
  }
}
