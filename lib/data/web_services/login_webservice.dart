import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthWebService {
  Future<Map<String, dynamic>> login(String phone) async {
    var headers = {'Accept': 'application/json', 'lang': 'ar'};

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'http://192.168.124.51:8000/api/technician/authentication/login',
      ),
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
  //  Future<Map<String, dynamic>> login(String phone) async {
  // print("web_service ---1");

  //   final response = await http.post(
  //     Uri.parse(
  //       'http://192.168.171.51:8000/api/technician/authentication/login',
  //     ),
  //     body: {'phone': phone, 'type_message': 'sms'},
  //   );
  //   print("web_service ---2");
  //   print(phone);

  //   if (response.statusCode == 200) {
  //     print("successsssss");
  //     final data = jsonDecode(response.body);
  //     print(data.toString());
  //     Get.toNamed('verify');
  //     return data;
  //   } else {
  //     print("Error happened");
  //     throw Exception('Login failed');
  //   }
}

//}
