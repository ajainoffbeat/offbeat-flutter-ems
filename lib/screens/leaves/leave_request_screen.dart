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
          toDate = null; // reset if previous "to" date becomes invalid
        }
      });
    }
  }

  Future<void> pickToDate() async {
    if (fromDate == null) return;

    final picked = await showDatePicker(
      context: context,
      firstDate: fromDate!, // cannot select earlier date
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

              /// ---------------------- HEADER ----------------------
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
                  const SizedBox(width: 48) // balance spacing with back button
                ],
              ),

              const SizedBox(height: 10),

              /// ---------------------- LEAVE TYPE ----------------------
              const Text("Leave Type", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLeaveType,
                    hint: const Text("Select Leave Type"),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: leaveTypes.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedLeaveType = val),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ---------------------- DATE PICKERS ----------------------
              const Text("Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: pickFromDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(fromDate == null
                                ? "From"
                                : "${fromDate!.day}/${fromDate!.month}/${fromDate!.year}"),
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
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(toDate == null
                                ? "Till"
                                : "${toDate!.day}/${toDate!.month}/${toDate!.year}"),
                            const Icon(Icons.calendar_today, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ---------------------- REASON ----------------------
              const Text("Reason for absence",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
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

              /// ---------------------- SUBMIT BUTTON ----------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Send", style: TextStyle(fontSize: 16, color: Colors.white)),
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
