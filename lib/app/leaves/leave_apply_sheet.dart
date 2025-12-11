import 'package:ems_offbeat/model/leaveType.dart';
import 'package:ems_offbeat/services/leave_service.dart';
import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LeaveApplySheet extends StatefulWidget {
  const LeaveApplySheet({super.key});

  @override
  State<LeaveApplySheet> createState() => _LeaveApplySheetState();
}

class _LeaveApplySheetState extends State<LeaveApplySheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _startDateCtrl = TextEditingController();
  final TextEditingController _endDateCtrl = TextEditingController();
  final TextEditingController _reasonCtrl = TextEditingController();


  DateTime? _startDate;
  DateTime? _endDate;

 List<LeaveType> _leaveTypes = [];
 LeaveType? _selectedLeaveType;
 
  @override
  void dispose() {
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }
  
@override
void initState() {
  super.initState();
  loadLeaveTypes();
}
void loadLeaveTypes() async {
   _leaveTypes = await fetchLeaveTypes();

  setState(() {});
  print("Leave Types: ${_leaveTypes}");
}


  // 📅 Date Picker
  Future<void> _pickDate({
    required TextEditingController controller,
    DateTime? firstDate,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
                  _formCard(),
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

  Widget _formCard() {
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
          const Text(
            "Information about leave details",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _leaveTypeDropdown(),
          const SizedBox(height: 16),

          _startDateField(),
          const SizedBox(height: 16),

          _endDateField(),
          const SizedBox(height: 16),

          _reasonField(),
          const SizedBox(height: 24),

          _submitButton(),
        ],
      ),
    );
  }

  // ───────────── Form Fields ─────────────

  Widget _leaveTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Pick your kind of break — we don't judge",
          style: _labelStyle(),
        ),
        const SizedBox(height: 6),
DropdownButtonFormField<LeaveType>(
  value: _selectedLeaveType,
  decoration: _inputDecoration("Select Type"),
  items: _leaveTypes.map((leave) {
    return DropdownMenuItem(
      value: leave,
      child: Text(leave.name),
    );
  }).toList(),

  onChanged: (val) {
    setState(() {
      _selectedLeaveType = val;
    });
  },

  validator: (val) => val == null ? "Please select leave type" : null,
)
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
              firstDate: _endDateCtrl.text.isNotEmpty
                  ? DateTime.parse(_endDateCtrl.text)
                  : null,
            );
          },
          decoration: _inputDecoration("End Date").copyWith(
            suffixIcon: const Icon(Icons.calendar_month),
          ),
          validator: (val) =>
              val!.isEmpty ? "Please select end date" : null,
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

  Widget _submitButton() {
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
       onPressed: () async {
  if (!_formKey.currentState!.validate()) return;

  if (_selectedLeaveType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select leave type")),
    );
    return;
  }

  final success = await applyLeave(
    employeeId: 115,             // jo user hai jika leave apply hoga
    enteredBy:  93,             // Logged in UserId logid use 
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

  if (success) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave applied successfully!")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to apply leave")),
    );
  }
},

        child: const Text(
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
