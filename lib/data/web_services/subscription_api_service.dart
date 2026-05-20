import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import '../models/subscription_plan.dart'; // تأكد من المسار الصحيح

class SubscriptionApiService {
  final String _baseUrl = "${AppConstants.baseUrl}/technician";

  // ملاحظة: يجب أن تحصل على التوكن من مكان آمن (مثل SharedPreferences)
  // وليس مكتوبًا بشكل ثابت هنا.
  final String _token = AppConstants.globalAccessToken;

  // API 1: جلب كل باقات الاشتراك
  // في ملف subscription_api_service.dart

  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    final uri = Uri.parse(
      "http://192.168.1.9:8000/api/technician/subscription-plan",
    );

    // تأكد من أن التوكن له قيمة صحيحة قبل إرسال الطلب
    print("DEBUG: Using Token: Bearer $_token");

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    final response = await http.get(uri, headers: headers);

    // --- هنا أهم جزء في اكتشاف الأخطاء ---
    // سنقوم بطباعة حالة الاستجابة ونص الخطأ من الخادم
    print("DEBUG: Response StatusCode: ${response.statusCode}");
    print("DEBUG: Response Body: ${response.body}");
    // -----------------------------------------

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];
      return data
          .map((jsonItem) => SubscriptionPlan.fromJson(jsonItem))
          .toList();
    } else {
      // الآن سنرمي خطأ أكثر تفصيلاً
      throw Exception(
        'Failed to load plans. StatusCode: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // API 3: إنشاء اشتراك جديد
  Future<bool> createSubscription({
    required String planId,
    required String paymentMethod,
  }) async {
    final uri = Uri.parse('$_baseUrl/technician-subscription');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    var request =
        http.MultipartRequest('POST', uri)
          ..fields['subscription_plan_id'] = planId
          ..fields['payment_method'] = paymentMethod
          ..headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      // تم الاشتراك بنجاح
      return true;
    } else {
      // فشل الاشتراك
      final respStr = await response.stream.bytesToString();
      print(respStr); // لطباعة سبب الخطأ
      throw Exception('Failed to create subscription');
    }
  }
}
