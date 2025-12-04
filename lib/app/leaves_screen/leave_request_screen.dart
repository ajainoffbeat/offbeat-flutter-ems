import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final List<String> leaveTypes = ["Short Leave", "Half Day", "Full Day"];
  String? selectedLeaveType;

  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController reasonController = TextEditingController();

  // -------- SHORT LEAVE SLOTS (2 HOUR FIXED) --------
  final List<String> shortLeaveSlots = [
    "09:00 - 11:00",
    "11:00 - 13:00",
    "13:00 - 15:00",
    "15:00 - 17:00",
    "17:00 - 19:00",
    "18:00 - 20:00",
  ];
  String? selectedShortSlot;

  // -------- HALF DAY SELECTION --------
  String? selectedHalf;

  Future<void> pickFromDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: fromDate ?? now,
    );

    if (picked != null) {
      setState(() {
        fromDate = picked;
        if (toDate != null && toDate!.isBefore(fromDate!)) {
          toDate = null;
        }
      });
    }
  }

  Future<void> pickToDate() async {
    if (fromDate == null) return;

    final picked = await showDatePicker(
      context: context,
      firstDate: fromDate!,
      lastDate: DateTime(DateTime.now().year + 2),
      initialDate: toDate ?? fromDate!,
    );

    if (picked != null) {
      setState(() {
        toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fc),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------- HEADER ----------------------
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Leave Request",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 10),

              // ---------------------- LEAVE TYPE ----------------------
              const Text(
                "Leave Type",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),

              SizedBox(
                width: double.infinity, // 👈 Makes it full width
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppThemeData.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded:
                          true, // 👈 Important for dropdown text full width
                      value: selectedLeaveType,
                      hint: const Text("Select Leave Type"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: leaveTypes.map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedLeaveType = val;
                          selectedShortSlot = null;
                          selectedHalf = null;
                        });
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------------- SHORT LEAVE SLOTS ----------------------
              if (selectedLeaveType == "Short Leave") ...[
                const Text(
                  "Select Short Leave Slot",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),

                LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = (constraints.maxWidth - 10) / 2;
                    // 10 = spacing between the two items

                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: shortLeaveSlots.map((slot) {
                        final bool isSelected = selectedShortSlot == slot;

                        return GestureDetector(
                          onTap: () => setState(() => selectedShortSlot = slot),
                          child: Container(
                            width: itemWidth, // 👈 EXACT HALF-WIDTH
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppThemeData.primary400 : AppThemeData.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppThemeData.primary400
                                    : AppThemeData.grey200,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppThemeData.grey200,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              slot,
                              style: TextStyle(
                                color: isSelected ? AppThemeData.surface : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],

              // ---------------------- HALF DAY OPTIONS ----------------------
              if (selectedLeaveType == "Half Day") ...[
  const Text(
    "Choose Half",
    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
  ),
  const SizedBox(height: 8),

  Column(
    children: [
      RadioListTile<String>(
        contentPadding: EdgeInsets.zero,        // REMOVE LEFT INDENT
        visualDensity: VisualDensity.compact,   // TIGHTER LOOK
        title: const Text("First Half (9 AM - 1 PM)"),
        value: "First Half",
        groupValue: selectedHalf,
        onChanged: (value) {
          setState(() => selectedHalf = value);
        },
      ),
      RadioListTile<String>(
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        title: const Text("Second Half (1 PM - 5 PM)"),
        value: "Second Half",
        groupValue: selectedHalf,
        onChanged: (value) {
          setState(() => selectedHalf = value);
        },
      ),
    ],
  ),
],


              // ---------------------- DATE PICKERS (shown in all leave types) ----------------------
              const Text(
                "Date",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: pickFromDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeData.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppThemeData.grey200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              fromDate == null
                                  ? "From"
                                  : "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}",
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: pickToDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeData.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppThemeData.grey200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              toDate == null
                                  ? "Till"
                                  : "${toDate!.day}/${toDate!.month}/${toDate!.year}",
                            ),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------------- REASON ----------------------
              const Text(
                "Reason for absence",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppThemeData.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppThemeData.grey200),
                ),
                child: TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Write your reason...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              const Spacer(),

              // ---------------------- SUBMIT BUTTON ----------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppThemeData.primary400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(fontSize: 16, color: AppThemeData.surface),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          ),
        ),
      ),
    );
  }
}
