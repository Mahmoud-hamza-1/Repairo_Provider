// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../models/profile_model.dart';

// class ProfileRemoteDataSource {
//   final http.Client client;

//   ProfileRemoteDataSource(this.client);

//   Future<Profile> updateProfile({required String name, File? image}) async {
//     var uri = Uri.parse("http://192.168.1.102:8000/api/profile/update");
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['name'] = name;

//     if (image != null) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path));
//     }

//     final streamedResponse = await request.send();
//     final response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       final body = json.decode(response.body);
//       return Profile.fromJson(body['data']);
//     } else {
//       throw Exception('فشل تحديث الملف الشخصي');
//     }
//   }
// }
