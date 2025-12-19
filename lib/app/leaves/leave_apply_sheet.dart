// lib/app/leaves/leave_apply_sheet.dart
import 'package:ems_offbeat/models/leaveType.dart';
import 'package:ems_offbeat/providers/leave_provider.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:ems_offbeat/widgets/screen_headings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveApplySheet extends ConsumerStatefulWidget {
  const LeaveApplySheet({super.key});

  @override
  ConsumerState<LeaveApplySheet> createState() => _LeaveApplySheetState();
}

class _LeaveApplySheetState extends ConsumerState<LeaveApplySheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _startDateCtrl = TextEditingController();
  final TextEditingController _endDateCtrl = TextEditingController();
  final TextEditingController _reasonCtrl = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  LeaveType? _selectedLeaveType;

  @override
  void dispose() {
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  // 📅 Date Picker
 // 📅 Date Picker
Future<void> _pickDate({
  required TextEditingController controller,
  DateTime? firstDate,
}) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: firstDate ?? DateTime.now(), // ✅ Use firstDate as initialDate if provided
    firstDate: firstDate ?? DateTime.now(),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppThemeData.primary500,
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate != null) {
    setState(() {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

      if (controller == _startDateCtrl) {
        _startDate = pickedDate;
        _endDateCtrl.clear();
        _endDate = null;
      } else {
        _endDate = pickedDate;
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);
    
    // Listen to apply leave state changes
    ref.listen(leaveProvider, (previous, next) {
      if (next.applyLeaveSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.applyLeaveMessage ?? "Leave applied successfully!")),
        );
        ref.read(leaveProvider.notifier).resetApplyLeaveState();
      } else if (next.applyLeaveMessage != null && !next.isApplyingLeave) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.applyLeaveMessage!)),
        );
        ref.read(leaveProvider.notifier).resetApplyLeaveState();
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dragHandle(),
                  const SizedBox(height: 16),
                  _title(),
                  const SizedBox(height: 20),
                  _formCard(leaveState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────────────── UI PARTS ─────────────────

  Widget _dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      "Planning your great escape?",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
    );
  }

  Widget _formCard(leaveState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppThemeData.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fill Leave Information",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 4),
          const ScreenSubtitle(text: "Information about leave details"),
          const SizedBox(height: 20),

          _leaveTypeDropdown(leaveState),
          const SizedBox(height: 16),

          _startDateField(),
          const SizedBox(height: 16),

          _endDateField(),
          const SizedBox(height: 16),

          _reasonField(),
          const SizedBox(height: 24),

          _submitButton(leaveState),
        ],
      ),
    );
  }

  // ───────────── Form Fields ─────────────

  // Widget _leaveTypeDropdown(leaveState) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Pick your kind of break — we don't judge",
  //         style: _labelStyle(),
  //       ),
  //       const SizedBox(height: 6),
        
  //       leaveState.isLoadingLeaveTypes
  //           ? const Center(child: CircularProgressIndicator())
  //           : DropdownButtonFormField<LeaveType>(
  //               value: _selectedLeaveType,
  //               decoration: _inputDecoration("Select Type"),
  //               items: leaveState.leaveTypes.map((leave) {
  //                 return DropdownMenuItem(
  //                   value: leave,
  //                   child: Text(leave.name),
  //                 );
  //               }).toList(),
  //               onChanged: (val) {
  //                 setState(() {
  //                   _selectedLeaveType = val;
  //                 });
  //               },
  //               validator: (val) =>
  //                   val == null ? "Please select leave type" : null,
  //             ),
  //     ],
  //   );
  // }

  Widget _leaveTypeDropdown(leaveState) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Pick your kind of break — we don't judge",
        style: _labelStyle(),
      ),
      const SizedBox(height: 6),

      leaveState.isLoadingLeaveTypes
          ? const Center(child: CircularProgressIndicator())
          : DropdownButtonFormField<LeaveType>(
              value: _selectedLeaveType,
              decoration: _inputDecoration("Select Type"),
              items: leaveState.leaveTypes
                  .map<DropdownMenuItem<LeaveType>>((LeaveType leave) {
                return DropdownMenuItem<LeaveType>(
                  value: leave,
                  child: Text(leave.name),
                );
              }).toList(),
              onChanged: (LeaveType? val) {
                setState(() {
                  _selectedLeaveType = val;
                });
              },
              validator: (val) =>
                  val == null ? "Please select leave type" : null,
            ),
    ],
  );
}


  Widget _startDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("When does your adventure begin?", style: _labelStyle()),
        const SizedBox(height: 6),
        TextFormField(
          controller: _startDateCtrl,
          readOnly: true,
          onTap: () => _pickDate(controller: _startDateCtrl),
          decoration: _inputDecoration("Start Date").copyWith(
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          validator: (val) =>
              val!.isEmpty ? "Please select start date" : null,
        ),
      ],
    );
  }

  Widget _endDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("When are you planning your comeback?", style: _labelStyle()),
        const SizedBox(height: 6),
        TextFormField(
          controller: _endDateCtrl,
          readOnly: true,
          onTap: () {
            if (_startDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Select start date first")),
              );
              return;
            }
            _pickDate(
              controller: _endDateCtrl,
              firstDate: _startDate,
            );
          },
          decoration: _inputDecoration("End Date").copyWith(
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          validator: (val) => val!.isEmpty ? "Please select end date" : null,
        ),
      ],
    );
  }

  Widget _reasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Optional, but it helps your manager say yes faster",
          style: _labelStyle(),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _reasonCtrl,
          maxLines: 4,
          decoration: _inputDecoration("Reason / Notes (Optional)"),
        ),
      ],
    );
  }

  Widget _submitButton(leaveState) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeData.primary500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: leaveState.isApplyingLeave
            ? null
            : () async {
                if (!_formKey.currentState!.validate()) return;

                if (_selectedLeaveType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select leave type")),
                  );
                  return;
                }

                // Call the provider method
                await ref.read(leaveProvider.notifier).applyLeave(
                      // employeeId: 115, 
                      // enteredBy: 93,
                      leaveTypeId: _selectedLeaveType!.id,
                      leaveDateFrom: DateTime(
                        _startDate!.year,
                        _startDate!.month,
                        _startDate!.day,
                      ).toUtc().toIso8601String(),
                      leaveDateTo: DateTime(
                        _endDate!.year,
                        _endDate!.month,
                        _endDate!.day,
                      ).toUtc().toIso8601String(),
                      reason: _reasonCtrl.text,
                    );
              },
        child: leaveState.isApplyingLeave
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Let's Make It Official",
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }

  // ───────────── Helpers ─────────────

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppThemeData.primary200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppThemeData.primary200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppThemeData.primary500, width: 1.5),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppThemeData.primary500,
    );
  }
}
