import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:repairo_provider/core/constants/app_constants.dart';

class VerificationWebservices {
  Future<Map<String, dynamic>> verifyNumber(String phone, String code) async {
    var headers = {'Accept': 'application/json', 'lang': 'ar'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/technician/authentication/check-code'),
    );

    request.fields.addAll({'phone': phone, 'code': code});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();

      print(responseBody);
      final data = jsonDecode(responseBody);
      final accessToken = data['data']['access_token'];
      AppConstants.globalAccessToken = accessToken;
      print(AppConstants.globalAccessToken);

      return jsonDecode(responseBody);
    } else {
      print(response.reasonPhrase);
      throw Exception('فشل التحقق من الرمز: ${response.reasonPhrase}');
    }
  }
}
