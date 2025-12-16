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

    return {
      "statusCode": response.statusCode,
      "data": data,
    };
  }
}
