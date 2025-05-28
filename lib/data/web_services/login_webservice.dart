import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:repairo_provider/core/constants/app_constants.dart';

class AuthWebService {
  Future<Map<String, dynamic>> login(String phone) async {
    var headers = {'Accept': 'application/json', 'lang': 'ar'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/technician/authentication/login'),
    );
    request.fields.addAll({'phone': phone, 'type_message': 'sms'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print(responseBody);

      return jsonDecode(responseBody);
      // return هنا ضرورية
    } else {
      print(response.reasonPhrase);
      throw Exception('فشل تسجيل الدخول: ${response.reasonPhrase}');
    }
  }
}
