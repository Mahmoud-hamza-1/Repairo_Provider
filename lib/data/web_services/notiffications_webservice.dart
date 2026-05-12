import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllNotifficationsWebservice {
  Future<Map<String, dynamic>> getNotiffications() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/technician/notification');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Notiffications info: ${response.body}');
      final dataa = jsonDecode(response.body);
      return dataa; // رجّع الـ response كامل
    } else {
      print('Failed to get Notiffications info: ${response.statusCode}');
      throw Exception('Notiffications info failed');
    }
  }

  Future<Map<String, dynamic>> readNotiffication({
    required String notiffication_id,
  }) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/notification/$notiffication_id',
    );
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'_method': 'put'}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'فشل الطلب',
          'status': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'success': false,
        'message': 'حصل خطأ غير متوقع',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> readAllNotiffications() async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/notification/read-all',
    );
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'فشل الطلب',
          'status': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'success': false,
        'message': 'حصل خطأ غير متوقع',
        'error': e.toString(),
      };
    }
  }
}
