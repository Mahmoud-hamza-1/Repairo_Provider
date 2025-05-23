import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSource(this.client);

  Future<List<Category>> getCategories() async {
    final token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC4xLjEwMjo4MDAwL2FwaS90ZWNobmljaWFuL2F1dGhlbnRpY2F0aW9uL2NoZWNrLWNvZGUiLCJpYXQiOjE3NDYxOTA4OTYsImV4cCI6MTc0NjE5NDQ5NiwibmJmIjoxNzQ2MTkwODk2LCJqdGkiOiJuNjA1Z2pZcFRJSGFRdzN0Iiwic3ViIjoiOWVkMGFjOWEtMmZhOC00ZGVlLTk5MjYtZTkzYzllYjBkMzAzIiwicHJ2IjoiZTAzMGEyZDE0NmMzMzcwY2Q4MDBhZDFjNWJhOWFiYTNiNmE1MTFlNyJ9.JtSsoyxiBpbiymlHHmbR2Lg7Vv9Cc5X88reRRpfPPZY"; // تأكد أنك خزّنت التوكن بهذا المفتاح

    final response = await client.get(
      Uri.parse('http://192.168.1.102:8000/api/category'),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data']['data'];
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('فشل في تحميل الأقسام');
    }
  }
}
