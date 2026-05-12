import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousWorksWebservice {
  Future<List<Map<String, dynamic>>> getAllPrevWorks() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/portfolio/previous-works',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('prev works info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data'],
      );
      return data;
    } else {
      print('Failed to get prev works info: ${response.statusCode}');
      throw Exception('getting prev works  info failed');
    }
  }

  Future<Map<String, dynamic>> addPrevWork({
    required String title,
    required String description,
    required List<File> images,
  }) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/portfolio/previous-works',
    );

    final request = http.MultipartRequest('POST', url);
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['description'] = description;

    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('images[$i]', images[i].path),
        );
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("تم الإرسال بنجاح: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print("فشل الطلب: ${response.statusCode} - ${response.body}");
        return {
          'success': false,
          'message': 'فشل الطلب',
          'status': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      print("خطأ بالطلب: $e");
      return {
        'success': false,
        'message': 'حصل خطأ غير متوقع',
        'error': e.toString(),
      };
    }
  }
}
