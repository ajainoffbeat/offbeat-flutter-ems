// lib/providers/leave_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../repository/leave_repository.dart';
import '../state/leave_state.dart';
import '../services/api_service.dart';

/// PROVIDER: Leave Repository
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  print("🔵 leaveRepositoryProvider created");
  return LeaveRepository(client: http.Client());
});

/// PROVIDER: Leave Controller
final leaveProvider = NotifierProvider<LeaveController, LeaveState>(() {
  print("🔵 leaveProvider created");
  return LeaveController();
});

class LeaveController extends Notifier<LeaveState> {
  @override
  LeaveState build() {
    print("🔵 LeaveController.build() called");
    // Auto-load data when provider initializes
    Future.microtask(() {
      print("🔵 Starting auto-load of data");
      loadMyLeaves();
      loadLeaveTypes();
    });
    return const LeaveState();
  }

  /// Load My Leaves (from API)
  Future<void> loadMyLeaves() async {
    print("🔵 loadMyLeaves started");
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repo = ref.read(leaveRepositoryProvider);
      print("🔵 Calling repository.getMyLeaves()");
      final result = await repo.getMyLeaves();
      
      print("🔵 Repository result: $result");
      
      final code = result["statusCode"];
      final data = result["data"];

      print("🔵 Status code: $code");

      if (code == 200) {
        final leaves = data["leaves"] as List<dynamic>;
        
        print("🔵 Leaves fetched: ${leaves.length}");
        if (leaves.isNotEmpty) {
          print("🔵 First leave sample: ${leaves[0]}");
        }
        
        state = state.copyWith(
          isLoading: false,
          myLeaves: leaves,
        );
        
        print("🔵 State updated with ${leaves.length} leaves");
        
        // Apply current filter
        applyFilter();
      } else {
        print("🔴 API returned non-200 code: $code");
        state = state.copyWith(
          isLoading: false,
          errorMessage: data["message"] ?? "Failed to load leaves",
        );
      }
    } catch (e, stackTrace) {
      print("🔴 Error loading leaves: $e");
      print("🔴 Stack trace: $stackTrace");
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Something went wrong: ${e.toString()}",
      );
    }
  }

  /// Load Leave Types (for dropdown in apply sheet)
  Future<void> loadLeaveTypes() async {
    print("🔵 loadLeaveTypes started");
    state = state.copyWith(isLoadingLeaveTypes: true);

    try {
      final leaveTypes = await fetchLeaveTypes();
      
      print("🔵 Leave Types fetched: ${leaveTypes.length}");
      
      state = state.copyWith(
        isLoadingLeaveTypes: false,
        leaveTypes: leaveTypes,
      );
      
      print("🔵 Leave types state updated");
    } catch (e, stackTrace) {
      print("🔴 Error loading leave types: $e");
      print("🔴 Stack trace: $stackTrace");
      state = state.copyWith(
        isLoadingLeaveTypes: false,
        errorMessage: "Failed to load leave types: ${e.toString()}",
      );
    }
  }

  /// Set Filter (Pending, Approved, Rejected)
  void setFilter(String filter) {
    print("🔵 setFilter called with: $filter");
    state = state.copyWith(currentFilter: filter);
    applyFilter();
  }

  /// Apply Filter to Leaves
  // lib/providers/leave_provider.dart

/// Apply Filter to Leaves
void applyFilter() {
  print("🔵 applyFilter called");
  print("🔵 Current filter: ${state.currentFilter}");
  print("🔵 Total leaves to filter: ${state.myLeaves.length}");
  
  if (state.myLeaves.isEmpty) {
    print("🔵 No leaves to filter");
    state = state.copyWith(filteredLeaves: []);
    return;
  }

  // Print first leave structure
  if (state.myLeaves.isNotEmpty) {
    print("🔵 Sample leave structure: ${state.myLeaves[0]}");
  }

  // ✅ FIX: Prioritize rejection status
  final filtered = state.myLeaves.where((leave) {
    final isApproved = leave['IsApproved'] ?? false;
    final isRejected = leave['IsRejected'] ?? false;
    
    print("🔵 Leave ID ${leave['ID']}: IsApproved=$isApproved, IsRejected=$isRejected, Filter='${state.currentFilter}'");
    
    // ✅ RULE: If rejected, it's rejected (regardless of IsApproved)
    if (isRejected == true) {
      final matches = state.currentFilter == "Rejected";
      print("🔵   -> Leave is REJECTED, matches filter: $matches");
      return matches;
    }
    
    // ✅ RULE: If approved (and not rejected), it's approved
    if (isApproved == true) {
      final matches = state.currentFilter == "Approved";
      print("🔵   -> Leave is APPROVED, matches filter: $matches");
      return matches;
    }
    
    // ✅ RULE: If neither approved nor rejected, it's pending
    final matches = state.currentFilter == "Pending";
    print("🔵   -> Leave is PENDING, matches filter: $matches");
    return matches;
  }).toList();

  print("🔵 Filtered leaves count: ${filtered.length}");

  state = state.copyWith(filteredLeaves: filtered);
  print("🔵 State updated with filtered leaves");
}


  /// Apply Leave
  Future<void> applyLeave({
    // required int employeeId,
    // required int enteredBy,
    required int leaveTypeId,
    required String leaveDateFrom,
    required String leaveDateTo,
    required String reason,
  }) async {
    print("🔵 applyLeave called");
    state = state.copyWith(
      isApplyingLeave: true,
      applyLeaveSuccess: false,
      applyLeaveMessage: null,
    );

    try {
      final repo = ref.read(leaveRepositoryProvider);
      final result = await repo.applyLeave(
        // employeeId: employeeId,
        // enteredBy: enteredBy,
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
          applyLeaveMessage: data["message"] ?? "Leave applied successfully!",
        );
        
        // Reload leaves after successful application
        await loadMyLeaves();
      } else {
        state = state.copyWith(
          isApplyingLeave: false,
          applyLeaveSuccess: false,
          applyLeaveMessage: data["message"] ?? "Failed to apply leave",
        );
      }
    } catch (e) {
      print("🔴 Error applying leave: $e");
      state = state.copyWith(
        isApplyingLeave: false,
        applyLeaveSuccess: false,
        applyLeaveMessage: "Something went wrong: ${e.toString()}",
      );
    }
  }

  /// Refresh Data
  Future<void> refresh() async {
    print("🔵 refresh called");
    await loadMyLeaves();
    await loadLeaveTypes();
  }

  /// Reset Apply Leave State
  void resetApplyLeaveState() {
    state = state.copyWith(
      isApplyingLeave: false,
      applyLeaveSuccess: false,
      applyLeaveMessage: null,
    );
  }
}
