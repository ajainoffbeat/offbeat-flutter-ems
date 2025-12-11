import 'dart:convert';
import 'package:ems_offbeat/model/leaveType.dart';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import '../utils/jwt_helper.dart';

class LeaveService {
  static Future<List<dynamic>> getMyLeaves() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("Token not found");
     
    final EmployeeID = JwtHelper.getEmployeeId(token);
    print("Token not found $EmployeeID");
    if (EmployeeID == null) throw Exception("EmployeeId missing in token");

    final url = Uri.parse(
      "http://www.offbeatsoftwaresolutions.com/api/Leave/list?employeeId=$EmployeeID",
    );

    final response = await http.get(
      url,  
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load leaves");
    }
  }
}

Future<List<LeaveType>> fetchLeaveTypes() async {
      print("data:");
  final url = Uri.parse("http://offbeatsoftwaresolutions.com/api/LeaveType/get-all");
  final token = await TokenStorage.getToken();
  if (token == null) throw Exception("Token not found");
  final response = await http.get(
    url,
     headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      );

  if (response.statusCode == 200) {
        print("data:");
    final List data = jsonDecode(response.body);
    print("data: $data");
    return data.map((e) => LeaveType.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load leave types");
  }
}


Future<bool> applyLeave({
  required int employeeId,
  required int enteredBy,
  required int leaveTypeId,
  required String leaveDateFrom,
  required String leaveDateTo,
  required String reason,
}) async {
  final url = Uri.parse("http://offbeatsoftwaresolutions.com/api/Leave/apply");

  final body = jsonEncode({
    "EmployeeID": employeeId,
    "EnteredBy": enteredBy,
    "LeaveTypeID": leaveTypeId,
    "LeaveDateFrom": leaveDateFrom,
    "LeaveDateTo": leaveDateTo,
    "LeaveApplyReason": reason,
  });
  print("API Body: $body");
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception("Token not found");
  final response = await http.post(
    url,
    headers: {
        "Authorization": "Bearer $token",
      "Content-Type": "application/json"},
    body: body,
  );

  print("API Response: ${response.body}");

  return response.statusCode == 200 || response.statusCode == 201;
}
