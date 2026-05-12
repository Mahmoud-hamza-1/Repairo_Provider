import 'package:dio/dio.dart';

// افترض أن لديك ملفًا لإدارة ثوابت الـ API
const String baseUrl = "https://your-api-base-url.com/api/";

class StepTwoWebservices {
  late Dio dio;

  StepTwoWebservices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 20), // 20 seconds
      receiveTimeout: Duration(seconds: 20),
    );
    dio = Dio(options);
  }

  // دالة لإرسال بيانات الخطوة الثانية
  Future<Map<String, dynamic>> submitStepTwoData(Map<String, dynamic> data) async {
    try {
      // افترض أنك تحتاج لإرسال توكن المصادقة في الـ Headers
      // String? token = await secureStorage.read(key: 'token');
      // dio.options.headers['Authorization'] = 'Bearer $token';
      
      // قم بإجراء طلب POST إلى نقطة النهاية (Endpoint) الصحيحة
      Response response = await dio.post('provider/profile/step-two', data: data);
      print("Step Two API Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      // تعامل مع أخطاء Dio هنا (مثل أخطاء الشبكة أو استجابات الخادم السيئة)
      print("DioException in StepTwoWebservices: ${e.toString()}");
      // يمكنك إرجاع رسالة الخطأ من الخادم إذا كانت متوفرة
      throw Exception(e.response?.data['message'] ?? 'An unknown error occurred');
    } catch (e) {
      print("Error in StepTwoWebservices: ${e.toString()}");
      throw Exception('Something went wrong on the server');
    }
  }
}
