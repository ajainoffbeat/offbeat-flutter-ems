// lib/repository/leave_repository.dart
import 'package:ems_offbeat/utils/jwt_helper.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart' as leave_service;

class LeaveRepository {
  final http.Client client;

  LeaveRepository({required this.client});

  Future<Map<String, dynamic>> getMyLeaves() async {
    try {
      final leaves = await leave_service.LeaveService.getMyLeaves();
      
      return {
        "statusCode": 200,
        "data": {
          "leaves": leaves,
          "message": "Leaves fetched successfully",
        },
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "data": {
          "message": e.toString(),
        },
      };
    }
  }

  Future<Map<String, dynamic>> getLeaveTypes() async {
    try {
      final leaveTypes = await leave_service.fetchLeaveTypes();
      
      return {
        "statusCode": 200,
        "data": {
          "leaveTypes": leaveTypes,
          "message": "Leave types fetched successfully",
        },
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "data": {
          "message": e.toString(),
        },
      };
    }
  }

  Future<Map<String, dynamic>> applyLeave({
    // required int employeeId,
    // required int enteredBy,
    required int leaveTypeId,
    required String leaveDateFrom,
    required String leaveDateTo,
    required String reason,
  }) async {
    try {
      final bool success = await leave_service.applyLeave(
        // employeeId: employeeId,
        // enteredBy: enteredBy,
        leaveTypeId: leaveTypeId,
        leaveDateFrom: leaveDateFrom,
        leaveDateTo: leaveDateTo,
        reason: reason,
      );

      if (success) {
        return {
          "statusCode": 200,
          "data": {
            "message": "Leave applied successfully!",
          },
        };
      } else {
        return {
          "statusCode": 400,
          "data": {
            "message": "Failed to apply leave",
          },
        };
      }
    } catch (e) {
      return {
        "statusCode": 500,
        "data": {
          "message": e.toString(),
        },
      };
    }
  }

  Future<Map<String, dynamic>> getLeaves() async {


    
  final token = await TokenStorage.getToken();
  if (token == null) throw Exception("Token not found");
  final role = JwtHelper.getRole(token);

  if (role == "Admin" || role == "SuperAdmin") {
   final allLeaves = await leave_service.getAllLeaves(
      pageNumber: 1,
      pageSize: 10,
    );
     return {
        "statusCode": 200,
        "data": {
          "leaves": allLeaves,
          "message": "Leaves fetched successfully",
        },
      };
   
  } else {
      final Leaves = await leave_service.LeaveService.getMyLeaves();
     return {
        "statusCode": 200,
        "data": {
          "leaves": Leaves,
          "message": "Leaves fetched successfully",
        },
      };

  }

}


} 