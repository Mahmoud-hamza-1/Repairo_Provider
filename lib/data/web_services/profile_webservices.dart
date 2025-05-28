import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWebservices {
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('${AppConstants.baseUrl}/user/profile');
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
      print('Failed to get user info: ${response.statusCode}');
      throw Exception('Login failed');
    }
  }
}
