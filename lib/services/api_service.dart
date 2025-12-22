
import 'dart:convert';
import 'package:ems_offbeat/constants/constant.dart';
import 'package:ems_offbeat/models/leaveType.dart';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import '../utils/jwt_helper.dart';

class LeaveService {
static Future<Map<String, dynamic>> getMyLeaves() async {
  final token = await TokenStorage.getToken();
  if (token == null) throw Exception("Token not found");

  final employeeId = JwtHelper.getEmployeeId(token);
  if (employeeId == null) throw Exception("EmployeeId missing");

  final url = Uri.parse(
    "${Constant.BASE_URL}/Leave/list?employeeId=$employeeId",
  );

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body); // ✅ Map
  } else {
    throw Exception("Failed to load leaves");
  }
}
}

Future<List<LeaveType>> fetchLeaveTypes() async {
  print("🟢 fetchLeaveTypes called");
  final url = Uri.parse("${Constant.BASE_URL}/LeaveType/get-all");
  final token = await TokenStorage.getToken();
  
  if (token == null) {
    print("🔴 Token not found in fetchLeaveTypes");
    throw Exception("Token not found");
  }
  
  print("🟢 Fetching leave types from: $url");
  
  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  print("🟢 Leave Types Response Status: ${response.statusCode}");
  print("🟢 Leave Types Response: ${response.body}");

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    print("🟢 Leave types count: ${data.length}");
    return data.map((e) => LeaveType.fromJson(e)).toList();
  } else {
    print("🔴 Failed to load leave types: ${response.statusCode}");
    throw Exception("Failed to load leave types");
  }
}

 Future<String> updatePassword({
    required String userId,
    required String userName,
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse(
      "${Constant.BASE_URL}/User/update-password/$userId",
    );

    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userName": userName,
        "password": oldPassword,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"] ?? "Password updated successfully";
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["message"] ?? "Failed to update password");
    }
  }

Future<bool> applyLeave({
  // required int employeeId,
  // required int enteredBy,
  required int leaveTypeId,
  required String leaveDateFrom,
  required String leaveDateTo,
  required String reason,
}) async {
  print("🟢 applyLeave called");
  
  final url = Uri.parse("${Constant.BASE_URL}/Leave/apply");
  
  final token = await TokenStorage.getToken();
  if (token == null) throw Exception("Token not found");
  final employeeId = JwtHelper.getEmployeeId(token);

    final body = jsonEncode({
    "EmployeeID": employeeId,
    "EnteredBy": employeeId,
    // "EnteredBy": enteredBy,
    "LeaveTypeID": leaveTypeId,
    "LeaveDateFrom": leaveDateFrom,
    "LeaveDateTo": leaveDateTo,
    "LeaveApplyReason": reason,
  });
  
  print("🟢 API Body: $body");
  // print("data=============>: $data");
  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: body,
  );

  print("🟢 Apply Leave Response Status: ${response.statusCode}");
  print("🟢 Apply Leave Response: ${response.body}");

  return response.statusCode == 200 || response.statusCode == 201;
}