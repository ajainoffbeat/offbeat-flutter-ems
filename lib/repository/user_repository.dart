// lib/repository/user_repository.dart
import 'dart:convert';
import 'package:ems_offbeat/constants/constant.dart';
import 'package:ems_offbeat/utils/jwt_helper.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../utils/token_storage.dart';

class UserRepository {
  final http.Client client;

  UserRepository({required this.client});

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token not found");
      final id = JwtHelper.getEmployeeId(token);
      print("id: $id");
      final response = await client.get(
        Uri.parse("${Constant.BASE_URL}/Employee/get/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      print("response.body ");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "statusCode": 200,
          "data": {"user": data},
        };
      } else {
        return {
          "statusCode": response.statusCode,
          "data": {"message": "Failed to load profile"},
        };
      }
    } catch (e) {
      return {
        "statusCode": 500,
        "data": {"message": e.toString()},
      };
    }
  }
}