import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
    static const _isReportingKey = "is_reporting";

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _isReportingKey);
  }

    static Future<bool> getIsReporting() async {
    final value = await _storage.read(key: _isReportingKey);
    print("the value is $value"); 
    // Treat any non-'true' value (including null) as false
    return value == 'true';
  }

  static Future<void> saveIsReporting(bool value) async {
    print("value of  save is $value");
    await _storage.write(
      key: _isReportingKey,
      value: value.toString(),
    );
  }
}
