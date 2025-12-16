// lib/models/leaveType.dart
class LeaveType {
  final int id;
  final String name;
  final String description;
  final double leaveValue;

  LeaveType({
    required this.id,
    required this.name,
    required this.description,
    required this.leaveValue,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'] ?? json['ID'] ?? 0,
      name: json['name'] ?? json['Name'] ?? '',
      description: json['description'] ?? json['Description'] ?? '',
      leaveValue: (json['leaveValue'] ?? json['LeaveValue'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'leaveValue': leaveValue,
    };
  }
}