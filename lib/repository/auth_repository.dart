import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ems_offbeat/utils/token_storage.dart';

class AuthRepository {
  final http.Client client;

  AuthRepository({required this.client});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(
      "http://www.offbeatsoftwaresolutions.com/api/Auth/login",
    );

    final response = await client.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "Username": email.trim(),
        "password": password.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    // Save token only if login was successful
    if (response.statusCode == 200 && data["token"] != null) {
      await TokenStorage.saveToken(data["token"]);
    }
      // ✅ CALL is-reporting API AFTER LOGIN
      final isReporting = await _checkIsReporting();
      print("Is reporting: $isReporting");
      await TokenStorage.saveIsReporting(isReporting);
      print("Is reporting saved: $isReporting");

    return {
      "statusCode": response.statusCode,
      "data": data,
    };
  }

  Future<bool> _checkIsReporting() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse(
      "http://192.168.1.11:5220/api/User/is-reporting-person",
    );

    final response = await client.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      /// adjust key if backend changes
      return data["isReportingPerson"] == true;
    }

    return false;
  }
}
