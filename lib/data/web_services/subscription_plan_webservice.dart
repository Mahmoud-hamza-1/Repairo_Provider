import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPlanWebservice {



  Future<Map<String, dynamic>> subscribeplan({
    required String planid,
    required String paymentmethod,
  }) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/technician-subscription',
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
        body: jsonEncode({
          'subscription_plan_id': planid,
          'payment_method': paymentmethod,
        }),
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
