import 'dart:convert';
import 'package:ems_offbeat/constants/constant.dart';
import 'package:ems_offbeat/models/leaveType.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  final url = Uri.parse("${Constant.BASE_URL}/User/update-password/$userId");

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
      "Content-Type": "application/json",
    },
    body: body,
  );

  print("🟢 Apply Leave Response Status: ${response.statusCode}");
  print("🟢 Apply Leave Response: ${response.body}");

  return response.statusCode == 200 || response.statusCode == 201;
}

Future<void> sendOtpToEmail({required String email}) async {
  try {
    final response = await http.post(
      Uri.parse('${Constant.BASE_URL}/User/reset-password/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    // print('response ${response.body}',);
    // print("EMAIL $email");
    // if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("DATA $data");
    // if (data['success'] != true) {
    //   throw Exception(data['message'] ?? 'Failed to send OTP');
    // }
    // } else {
    //   final data = jsonDecode(response.body);
    //   throw Exception(data['message'] ?? 'Failed to send OTP');
    // }
  } catch (e) {
    throw Exception('Error sending OTP: ${e.toString()}');
  }
}

/// Verify OTP entered by user
Future<bool> verifyOtp({required String email, required String otp}) async {
  try {
    print("email otp");
    print("$email $otp");
    final response = await http.post(
      Uri.parse('${Constant.BASE_URL}/User/reset-password/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    final data = jsonDecode(response.body);
    print("DATAAAAAAAAAAAA $data");
    return true;
    // if (data.message) {
    // return data['success'] == true;
    // } else {
    // final data = jsonDecode(response.body);
    // throw Exception(data['message'] ?? 'Invalid OTP');
    // }
  } catch (e) {
    throw Exception('Error verifying OTP: ${e.toString()}');
  }
}

/// Reset password with verified OTP
Future<void> resetPassword({
  required String userName,
  required String email,
  required String password,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${Constant.BASE_URL}/User/reset-password/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userName,
        'email': email,
        'password': password,
        'newPassword': newPassword,
      }),
    );
  } catch (e) {
    throw Exception('${e.toString()}');
  }
}

Future<void> logout() async {
  try {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    print("deviceTOken $deviceToken");
    final response = await http.post(
      Uri.parse('${Constant.BASE_URL}/Auth/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'deviceToken': deviceToken ?? ""}),
    );
    
    return;
    // // ✅ Check success using message instead
    // if (data['message'] == "Logged out successfully" || data['message'].contains("success")) {
    //   return; // logout success
    // } else {
    //   throw Exception(data['message'] ?? 'Logout failed');
    // }
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<bool> updateProfile(Map<String, String> payload) async {
  final token = await TokenStorage.getToken();
  if (token == null) throw Exception("Token not found");

  final empId = JwtHelper.getEmployeeId(token);
  if (empId == null) throw Exception("empId missing");

  final url = Uri.parse("${Constant.BASE_URL}/Employee/update/$empId");

  // ✅ Convert to multipart form request
  var request = http.MultipartRequest("POST", url);
  request.headers["Authorization"] = "Bearer $token";

  // Add changed fields
  payload.forEach((key, value) {
    if (key != "img") {
      // don't add img to fields
      request.fields[key] = value;
    }
  });
  print("payload $payload");
  // Attach image properly in formData file section
  if (payload.containsKey("img")) {
    final imgBytes = base64Decode(payload["img"]!);
    request.files.add(
      http.MultipartFile.fromBytes(
        "Image", // field name backend expects
        imgBytes,
        filename: "profile.jpg",
      ),
    );
  }

  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (streamedResponse.statusCode == 200) {
    if (response.body.trim().isNotEmpty) {
      final data = jsonDecode(response.body);
      return (data["updated"] ?? 0) >= 1; // true if 1 or more updated
    }
    return true;
  }

  // ✅ New error handling
  if (response.body.trim().isNotEmpty) {
    final data = jsonDecode(response.body);
    throw Exception(data["message"] ?? "Update failed");
  }

  throw Exception("Update failed");
}

// GetAllLeaves
Future<Map<String, dynamic>> getAllLeaves({
  required int pageNumber,
  required int pageSize,
}) async {
  final token = await TokenStorage.getToken();
  if (token == null) throw Exception("Token not found");

  final url = Uri.parse(
    "${Constant.BASE_URL}/Leave/filter?pageNumber=$pageNumber&pageSize=$pageSize",
  );

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    print("inside get all leaves ${response.body}");
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to load all leaves");
  }
}
