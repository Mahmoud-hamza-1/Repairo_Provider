// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:repairo_provider/core/constants/app_constants.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class UpdateRequestWebservice {
//   Future<Map<String, dynamic>> topuprequestedit({
//     required String requestId,
//     String? status,
//     List<String>? addedServicesIds,
//     List<String>? addedServicesquantities,
//     List<String>? customServicesNames,
//     List<String>? customServicesPrices,
//     List<String>? customServicesdetails,
//     List<File>? customServicesimages,
//   }) async {
//     final url = Uri.parse(
//       '${AppConstants.baseUrl}/technician/service-request/$requestId',
//     );

//     final request = http.MultipartRequest('POST', url);
//     final prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('auth_token');
//     request.headers['Authorization'] = 'Bearer $token';

//     request.fields['_method'] = 'put';
//     request.fields['status_request'] = status!;

//     // request.fields['amount'] = amount!;
//     // request.fields['date'] = date!;
//     // if (image != null) {
//     //   request.files.add(await http.MultipartFile.fromPath('image', image.path));
//     // }

//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         print("تم الإرسال بنجاح: ${response.body}");
//         return jsonDecode(response.body);
//       } else {
//         print("فشل الطلب: ${response.statusCode} - ${response.body}");
//         return {
//           'success': false,
//           'message': 'فشل الطلب',
//           'status': response.statusCode,
//           'body': response.body,
//         };
//       }
//     } catch (e) {
//       print("خطأ بالطلب: $e");
//       return {
//         'success': false,
//         'message': 'حصل خطأ غير متوقع',
//         'error': e.toString(),
//       };
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';

class UpdateRequestWebservice {
  Future<Map<String, dynamic>> updateRequest({
    required String requestId,
    String? status, // status_request
    List<ServiceUpdate> services = const [],
    List<CustomServiceUpdate> customServices = const [],
  }) async {
    final endpoint =
        '${AppConstants.baseUrl}/technician/service-request/$requestId';
    final url = Uri.parse(endpoint);
    final request = http.MultipartRequest('POST', url);

    // Auth
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';

    request.fields['_method'] = 'put';

    if (status != null) {
      request.fields['status_request'] = status;
    }

    for (int i = 0; i < services.length; i++) {
      final s = services[i];
      request.fields['services[$i][service_id]'] = s.serviceId;
      request.fields['services[$i][quantity]'] = s.quantity;
    }

    // ====== الخدمات المخصّصة ======
    // custom_services[i][service_name|service_price|additional_details]
    // custom_services[i][image][j]  (متعدد)
    for (int i = 0; i < customServices.length; i++) {
      final c = customServices[i];
      request.fields['custom_services[$i][service_name]'] = c.serviceName;
      request.fields['custom_services[$i][service_price]'] = c.servicePrice;
      if (c.additionalDetails != null && c.additionalDetails!.isNotEmpty) {
        request.fields['custom_services[$i][additional_details]'] =
            c.additionalDetails!;
      }

      // الصور
      for (int j = 0; j < c.images.length; j++) {
        final file = c.images[j];
        final fieldName = 'custom_services[$i][image][$j]';
        final multipartFile = await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          // contentType اختياري، بيفيد أحياناً
          // contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      // 200 أو 201 أو 204 (حسب السيرفر)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body.isEmpty ? '{}' : response.body);
      } else {
        return {
          'success': false,
          'message': 'فشل الطلب',
          'status': response.statusCode,
          'body': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حصل خطأ غير متوقع',
        'error': e.toString(),
      };
    }
  }
}

class ServiceUpdate {
  final String serviceId;
  final String quantity; // خليه String لتفادي مشاكل الـ casting
  ServiceUpdate({required this.serviceId, required this.quantity});
}

class CustomServiceUpdate {
  final String serviceName;
  final String servicePrice;
  final String? additionalDetails;
  final List<File> images; // صور متعدّدة لهاي الخدمة
  CustomServiceUpdate({
    required this.serviceName,
    required this.servicePrice,
    this.additionalDetails,
    this.images = const [],
  });
}
