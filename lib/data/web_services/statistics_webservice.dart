import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsApiException implements Exception {
  StatisticsApiException(this.statusCode, [this.message]);

  final int statusCode;
  final String? message;

  @override
  String toString() =>
      message ?? 'فشل جلب الإحصائيات (رمز الخطأ: $statusCode)';
}

class StatisticsWebservice {
  Future<Map<String, dynamic>> fetchStatistics({
    String? fromDate,
    String? toDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null || token.isEmpty) {
      throw StatisticsApiException(401, 'يجب تسجيل الدخول أولاً');
    }

    final query = <String, String>{};
    if (fromDate != null && fromDate.isNotEmpty) {
      query['from_date'] = fromDate;
    }
    if (toDate != null && toDate.isNotEmpty) {
      query['to_date'] = toDate;
    }

    final url = Uri.parse('${AppConstants.baseUrl}/technician/statistic')
        .replace(queryParameters: query.isEmpty ? null : query);

    final response = await http
        .get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(AppConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw StatisticsApiException(200, 'استجابة غير متوقعة من الخادم');
      }
      return decoded;
    }

    if (kDebugMode) {
      debugPrint(
        'fetchStatistics failed: ${response.statusCode} ${response.body}',
      );
    }

    String? serverMessage;
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        serverMessage = body['message']?.toString();
      }
    } catch (_) {}

    throw StatisticsApiException(
      response.statusCode,
      serverMessage ??
          (response.statusCode >= 500
              ? 'خطأ في الخادم، تحقق من إعدادات قاعدة البيانات'
              : 'فشل جلب الإحصائيات'),
    );
  }
}
