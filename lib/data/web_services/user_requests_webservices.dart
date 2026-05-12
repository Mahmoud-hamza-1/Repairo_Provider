import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';

class TechRequestsWebservices {
  Future<List<Map<String, dynamic>>> getAllRequests({String? status}) async {
    print("herreeee $status");
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/service-request',
    ).replace(
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status_request': status,
      },
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${AppConstants.globalAccessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('TechRequests info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data'],
      );
      return data;
    } else {
      print('Failed to get techRequests info: ${response.statusCode}');
      throw Exception(' techRequests get failed');
    }
  }
}
