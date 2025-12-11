class LeaveType {
  final int id;
  final String name;
  final String description;
  final double leaveValue;
  final bool IsApproved;

  LeaveType({
    required this.id,
    required this.name,
    required this.description,
    required this.leaveValue,
     required this.IsApproved,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      leaveValue: json['leaveValue'].toDouble(),
      IsApproved: json['IsApproved'],
    );
  }

}
