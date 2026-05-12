import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsWebservice {
  Future<Map<String, dynamic>?> fetchStatistics({
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // تجهيز الـ query parameters
      String url = "${AppConstants.baseUrl}/technician/statistic";
      if (fromDate != null && toDate != null) {
        url += "?from_date=$fromDate&to_date=$toDate";
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("فشل الطلب: ${response.statusCode}");
        print("الرد: ${response.body}");
        return null;
      }
    } catch (e) {
      print("خطأ: $e");
      return null;
    }
  }
}
