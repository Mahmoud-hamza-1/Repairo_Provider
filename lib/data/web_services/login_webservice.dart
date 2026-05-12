import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:repairo_provider/core/constants/app_constants.dart';

class AuthWebService {
  Future<Map<String, dynamic>> login(String phone) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/technician/authentication/login'),
      body: {'phone': phone, 'type_message': 'sms'},
    );

    if (response.statusCode == 200) {
      print("successsssss");
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      print("Error happened");
      throw Exception('Login failed');
    }
  }
}
