import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:repairo_provider/constants/strings.dart';

class VerificationWebservices {
  Future<Map<String, dynamic>> verifyNumber(String phone, String code) async {
    print(" ver---7");

    var headers = {'Accept': 'application/json', 'lang': 'ar'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'http://192.168.124.51:8000/api/technician/authentication/check-code',
      ),
    );
    print(" ver---8");

    request.fields.addAll({
      'phone': phone,
      'code': code, // استخدم المتغير المُمرّر، وليس "0000" ثابتة
    });
    print(" ver---9");

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("ver ---10");

      String responseBody = await response.stream.bytesToString();

      print(responseBody);
      print(" ver---11");
      final data = jsonDecode(responseBody);
      final accessToken = data['data']['access_token'];
      globalAccessToken = accessToken;
      print(globalAccessToken);

      return jsonDecode(responseBody);
    } else {
      print(response.reasonPhrase);
      throw Exception('فشل التحقق من الرمز: ${response.reasonPhrase}');
    }
  }
}

    // print("ver ---6");

    // final response = await http.post(
    //   Uri.parse(
    //     'http://192.168.171.51:8000/api/user/authentication/check-code',
    //   ),
    //   body: {'phone': phone, 'code': code},
    // );
    // print("ver ---7");

    // if (response.statusCode == 200) {
    //   print("successsssss");
    //   final data = jsonDecode(response.body);
    //   print(data.toString());
    //   return data;
    // } else {
    //   print("Error happened");
    //   throw Exception('Login failed');
    // }
 