import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TechServicesWebservice {
  Future<void> updateTechServices(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/account/services',
    );
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Services updated successfully: ${response.body}');
    } else {
      print('Failed to update services: ${response.statusCode}');
      throw Exception('Updating services failed');
    }
  }

  Future<List<Map<String, dynamic>>> getTechServices() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/account/services',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('services for tech info: ${response.body}');
      final Map<String, dynamic> dataa = jsonDecode(response.body);
      // هنا المشكلة: `data` ليست قائمة، بل خريطة واحدة
      // يجب أن يكون التحويل كالتالي:
      final data = dataa['data'] as Map<String, dynamic>;
      return [data];
    } else {
      print('Failed to get services info: ${response.statusCode}');
      throw Exception('getting services info failed');
    }
  }
}
