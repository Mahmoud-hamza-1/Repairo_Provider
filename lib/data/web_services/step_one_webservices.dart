import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:repairo_provider/core/constants/app_constants.dart';

class StepOneWebservices {
  Future<Map<String, dynamic>> stepone(
    String name,
    File image,
    String address,
  ) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppConstants.globalAccessToken}',
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}/technician/account/personal-info'),
    );

    request.fields.addAll({'name': name, 'place': address});
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      return jsonDecode(responseBody);
    } else {
      print(response.reasonPhrase);
      throw Exception('فشل  : ${response.reasonPhrase}');
    }
  }
}
