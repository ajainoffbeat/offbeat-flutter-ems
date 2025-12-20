import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  static String? getEmployeeId(String token) {
    final decodedToken = JwtDecoder.decode(token);
    print("decodedToken: $decodedToken");
    // ⚠️ Change key if backend uses different name
    return decodedToken['EmployeeID']?.toString();
  }
  static String? getUserId(String token) {
    final decodedToken = JwtDecoder.decode(token);
    print("decodedToken: $decodedToken");
    // ⚠️ Change key if backend uses different name
    return decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']?.toString();
  }
}
