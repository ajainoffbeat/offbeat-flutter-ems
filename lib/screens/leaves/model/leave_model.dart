enum LeaveStatus { submitted, accepted, rejected }

class LeaveModel {
  final String startDate;
  final String endDate;
  final String type;
  final LeaveStatus status;

  LeaveModel({
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
  });
}
