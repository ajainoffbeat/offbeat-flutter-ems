
import 'dart:convert';
import 'package:ems_offbeat/constants/constant.dart';
import 'package:ems_offbeat/models/leaveType.dart';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import '../utils/jwt_helper.dart';

class LeaveService {
  static Future<List<dynamic>> getMyLeaves() async {
    print("🟢 LeaveService.getMyLeaves called");
    
    final token = await TokenStorage.getToken();
    print("🟢 Token: ${token != null ? 'Found' : 'Not found'}");
    
    if (token == null) throw Exception("Token not found");
     
    final EmployeeID = JwtHelper.getEmployeeId(token);
    print("🟢 EmployeeID: $EmployeeID");
    
    if (EmployeeID == null) throw Exception("EmployeeId missing in token");

    final url = Uri.parse(
      "${Constant.BASE_URL}/Leave/list?employeeId=$EmployeeID",
    );
    
    print("🟢 Request URL: $url");

    final response = await http.get(
      url,  
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    
    print("🟢 Response Status: ${response.statusCode}");
    print("🟢 Leaves Response: ${response.body}");
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("🟢 Decoded data type: ${data.runtimeType}");
      print("🟢 Data length: ${data is List ? data.length : 'Not a list'}");
      return data;
    } else {
      print("🔴 API Error: ${response.statusCode} - ${response.body}");
      throw Exception("Failed to load leaves: ${response.statusCode}");
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