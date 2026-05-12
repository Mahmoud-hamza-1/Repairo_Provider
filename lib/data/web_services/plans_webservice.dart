import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlansWebservice {
  Future<List<Map<String, dynamic>>> getAllPlans() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/subscription-plan',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('plans info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data'],
      );
      return data;
    } else {
      print('Failed to get plans info: ${response.statusCode}');
      throw Exception('getting plans info failed');
    }
  }
}
