import 'package:ems_offbeat/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LeaveApplySheet extends StatelessWidget {
  const LeaveApplySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dragHandle(),
                const SizedBox(height: 20),

                const Text(
                  "Planning your great escape?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),
                _formCard(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppThemeData.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fill Leave Information",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "Information about leave details",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 20),

          _dropdownField("Pick your kind of break — we don't judge"),
          const SizedBox(height: 14),

          _dateField("When does your adventure begin?", "Start Date"),
          const SizedBox(height: 14),

          _dateField("When are you planning your comeback?", "End Date"),
          const SizedBox(height: 14),

          _textArea(),
          const SizedBox(height: 30),

          _submitButton(),
        ],
      ),
    );
  }

  Widget _dropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 6),
        DropdownButtonFormField(
          decoration: _inputDecoration("Select Type"),
          items: const [
            DropdownMenuItem(value: "Full day", child: Text("Full day")),
            DropdownMenuItem(value: "Half day", child: Text("Half day")),
            DropdownMenuItem(value: "Short day", child: Text("Short day")),
          ],
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _dateField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: true,
          decoration: _inputDecoration(hint).copyWith(
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ],
    );
  }

  Widget _textArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Optional, but it helps your manager say yes faster",
          style: _labelStyle(),
        ),
        const SizedBox(height: 6),
        TextFormField(
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
        onPressed: () {},
        child: const Text(
          "Let's Make It Official",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppThemeData.primary200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppThemeData.primary200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppThemeData.primary500),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppThemeData.primary500,
    );
  }
}
