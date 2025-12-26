// lib/models/user.dart
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String departmentName;
  final String genderName;
  final String designationName;
  final String reportingFirstName;
  final String reportingLastName;
  final String enteredByName;
  final String dateOfJoining;
  final String fatherName;
  final String dob;
  final String emailAddress;
  final String officeEmailAddress;
  final String employeeCode;
  final String mobileNumber;
  final String alternateMobileNumber;
  final String permanentAddress;
  final String temporaryAddress;
  final String dateOfMarraige;
  final String dateOfReleaving;
  final String panNumber;
  final String addharNumber;
  final String passportNumber;
  final int enteredBy;
  final String enteredOn;
  final String departmentID;
  final String genderID;
  final String designationID;
  final String reportingPersonID;
  final bool isDeleted;
  final String imgurl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.departmentName,
    required this.genderName,
    required this.designationName,
    required this.reportingFirstName,
    required this.reportingLastName,
    required this.enteredByName,
    required this.dateOfJoining,
    required this.fatherName,
    required this.dob,
    required this.emailAddress,
    required this.officeEmailAddress,
    required this.employeeCode,
    required this.mobileNumber,
    required this.alternateMobileNumber,
    required this.permanentAddress,
    required this.temporaryAddress,
    required this.dateOfMarraige,
    required this.dateOfReleaving,
    required this.panNumber,
    required this.addharNumber,
    required this.passportNumber,
    required this.enteredBy,
    required this.enteredOn,
    required this.departmentID,
    required this.genderID,
    required this.designationID,
    required this.reportingPersonID,
    required this.isDeleted,
    required this.imgurl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      genderName: json['genderName'] ?? '',
      designationName: json['designationName'] ?? '',
      reportingFirstName: json['reportingFirstName'] ?? '',
      reportingLastName: json['reportingLastName'] ?? '',
      enteredByName: json['enteredByName'] ?? '',
      dateOfJoining: json['dateOfJoining'] ?? '',
      fatherName: json['fatherName'] ?? '',
      dob: json['dob'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      officeEmailAddress: json['officeEmailAddress'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      alternateMobileNumber: json['alternateMobileNumber'] ?? '',
      permanentAddress: json['permanentAddress'] ?? '',
      temporaryAddress: json['temporaryAddress'] ?? '',
      dateOfMarraige: json['dateOfMarraige'] ?? '',
      dateOfReleaving: json['dateOfReleaving'] ?? '',
      panNumber: json['panNumber'] ?? '',
      addharNumber: json['addharNumber'] ?? '',
      passportNumber: json['passportNumber'] ?? '',
      enteredBy: json['enteredBy'] ?? 0,
      enteredOn: json['enteredOn'] ?? '',
      departmentID: json['departmentID']?.toString() ?? '',
      genderID: json['genderID']?.toString() ?? '',
      designationID: json['designationID']?.toString() ?? '',
      reportingPersonID: json['reportingPersonID']?.toString() ?? '',
      isDeleted: json['isDeleted'] ?? false,
      imgurl: json['imgurl'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}