import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AccountStatusWebservice {
  Future<Map<String, dynamic>> getAccountStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('${AppConstants.baseUrl}/technician/account/status');
    var token = prefs.getString('auth_token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('account status : ${response.body}');
      final dataa = jsonDecode(response.body);
      final data = dataa['data'];
      AppConstants.subscription_status = dataa['data']['subscription_status'];
      print('✅✅✅✅✅✅✅✅✅✅ == ${AppConstants.subscription_status}');
      print(data.toString());
      return data;
    } else {
      print('Failed to get account status: ${response.statusCode}');
      throw Exception('account status failed');
    }
  }
}
