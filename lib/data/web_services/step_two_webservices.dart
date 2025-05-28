import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'dart:convert';
import 'package:repairo_provider/data/models/step_two_request_model.dart';

class StepTwoWebservices {
  Future<void> steptwo(ServicesRequestBody body) async {
    final url = Uri.parse(
      '${AppConstants.baseUrl}/technician/account/services',
    );
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${AppConstants.globalAccessToken}",
      },
      body: jsonEncode(body.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Success: ${response.body}");
    } else {
      print("Failed: ${response.statusCode} - ${response.body}");
    }
  }
}
