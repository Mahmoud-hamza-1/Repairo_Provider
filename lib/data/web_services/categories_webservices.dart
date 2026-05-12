import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';

class CategoriesWebservices {
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final url = Uri.parse('${AppConstants.baseUrl}/category');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${AppConstants.globalAccessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('User info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data']['data'],
      );
      return data;
    } else {
      print('Failed to get user info: ${response.statusCode}');
      throw Exception('Login failed');
    }
  }
}
