import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanDataWebservices {
  Future<Map<String, dynamic>> getPlanData(String id) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/subscription-plan/$id',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('plan d info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        dataa['data'],
      );
      print(data.toString());
      return data;
    } else {
      print('Failed to get plan d info: ${response.statusCode}');
      throw Exception('getting plan info failed');
    }
  }
}
