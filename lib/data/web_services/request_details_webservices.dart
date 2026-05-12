import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RequestDetailsWebservices {
  Future<Map<String, dynamic>> getRequestDetails(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/service-request/$id',
    );
    var token = prefs.getString('auth_token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('User info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final data = dataa['data'];

      print(data.toString());
      return data;
    } else {
      print('Failed to get requset details: ${response.statusCode}');
      throw Exception('failed');
    }
  }
}
