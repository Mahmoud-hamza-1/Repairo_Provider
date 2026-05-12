import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWebservice {
  Future<Map<String, dynamic>> showChat(String requestid) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/technician/chat/$requestid');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('chat  info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        dataa['data'],
      );
      print(data.toString());
      return data;
    } else {
      print('Failed to get chatting info: ${response.statusCode}');
      throw Exception('getting chatting info failed');
    }
  }

  Future<Map<String, dynamic>> sendmessage(
    String chatid,
    String? message,
    File? image,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    final uri = Uri.parse('${AppConstants.baseUrl}/technician/chat/message');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    // أضف القيم
    request.fields['chat_id'] = chatid;
    if (message != null && message.isNotEmpty) {
      request.fields['message'] = message;
    }

    // أضف الصورة كـ ملف
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      print("Error: ${response.body}");
      throw Exception('sendmessage failed');
    }
  }
}
