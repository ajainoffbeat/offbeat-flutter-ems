enum LeaveStatus { submitted, accepted, rejected }

class LeaveModel {
  String startDate;
  String endDate;
  String type;
  LeaveStatus status;
  String? rejectionReason;

  LeaveModel({
    required this.startDate,
    required this.endDate,
    required this.type,
    this.status = LeaveStatus.submitted,
    this.rejectionReason,
  });
}
