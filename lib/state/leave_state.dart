// lib/state/leave_state.dart
import '../models/leaveType.dart';

class LeaveState {
  final bool isLoading;
  final List<dynamic> myLeaves;
  final List<dynamic> filteredLeaves;
  final String currentFilter;
  final String? errorMessage;
  final List<LeaveType> leaveTypes;
  final bool isLoadingLeaveTypes;
  final int annualLeaveRemaining;
  final int usedLeaveBalance;
  final bool isApplyingLeave;
  final bool applyLeaveSuccess;
  final String? applyLeaveMessage;

  const LeaveState({
    this.isLoading = false,
    this.myLeaves = const [],
    this.filteredLeaves = const [],
    this.currentFilter = "Pending",
    this.errorMessage,
    this.leaveTypes = const [],
    this.isLoadingLeaveTypes = false,
    this.annualLeaveRemaining = 18,
    this.usedLeaveBalance = 6,
    this.isApplyingLeave = false,
    this.applyLeaveSuccess = false,
    this.applyLeaveMessage,
  });

  LeaveState copyWith({
    bool? isLoading,
    List<dynamic>? myLeaves,
    List<dynamic>? filteredLeaves,
    String? currentFilter,
    String? errorMessage,
    List<LeaveType>? leaveTypes,
    bool? isLoadingLeaveTypes,
    int? annualLeaveRemaining,
    int? usedLeaveBalance,
    bool? isApplyingLeave,
    bool? applyLeaveSuccess,
    String? applyLeaveMessage,
  }) {
    return LeaveState(
      isLoading: isLoading ?? this.isLoading,
      myLeaves: myLeaves ?? this.myLeaves,
      filteredLeaves: filteredLeaves ?? this.filteredLeaves,
      currentFilter: currentFilter ?? this.currentFilter,
      errorMessage: errorMessage,
      leaveTypes: leaveTypes ?? this.leaveTypes,
      isLoadingLeaveTypes: isLoadingLeaveTypes ?? this.isLoadingLeaveTypes,
      annualLeaveRemaining: annualLeaveRemaining ?? this.annualLeaveRemaining,
      usedLeaveBalance: usedLeaveBalance ?? this.usedLeaveBalance,
      isApplyingLeave: isApplyingLeave ?? this.isApplyingLeave,
      applyLeaveSuccess: applyLeaveSuccess ?? this.applyLeaveSuccess,
      applyLeaveMessage: applyLeaveMessage,
    );
  }
}