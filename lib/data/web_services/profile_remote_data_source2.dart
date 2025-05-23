import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/constants/strings.dart';
import 'package:repairo_provider/data/models/account_status_model.dart';
import 'package:repairo_provider/data/models/profile_step1_request.dart';
import 'package:repairo_provider/data/models/profile_step2_request.dart';
import 'package:repairo_provider/data/models/profile_step3_request.dart';

class ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSource(this.client, globa);

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $globalAccessToken',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> updateStep1(
    String name,
    String address,
    String image,
  ) async {
    print('Step1--- 6');
    var headers = {'Authorization': 'Bearer $globalAccessToken'};
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'http://192.168.124.51:8000/api/technician/account/personal-info',
      ),
    );
    request.fields.addAll({
      'name': name,
      'place': address,
    }); // استخدم المتغير الحقيقي بدل النص الثابت
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image, // استخدم المسار الحقيقي الذي تستلمه
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      print(resBody);
      return {'success': true, 'data': resBody};
    } else {
      print(response.reasonPhrase);
      return {'success': false, 'error': response.reasonPhrase};
    }
  }

  Future<void> updateStep2(Step2Request request) async {
    final response = await client.post(
      Uri.parse('http://192.168.1.104:8000/api/update-step2'),
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode != 200) throw Exception("فشل تحديث الخدمات");
  }

  Future<void> updateStep3(Step3Request request) async {
    var uri = Uri.parse('http://192.168.1.104:8000/api/update-step3');
    var multipart = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers);
    multipart.files.add(
      await http.MultipartFile.fromPath(
        'identity_image',
        request.identityImage.path,
      ),
    );

    var response = await multipart.send();
    if (response.statusCode != 200) throw Exception("فشل رفع صورة الهوية");
  }

  Future<AccountStatus> getAccountStatus() async {
    final response = await client.get(
      Uri.parse('http://192.168.1.101:8000/api/account-status'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return AccountStatus.fromJson(jsonData['data']);
    } else {
      throw Exception("فشل في جلب حالة الحساب");
    }
  }
}
