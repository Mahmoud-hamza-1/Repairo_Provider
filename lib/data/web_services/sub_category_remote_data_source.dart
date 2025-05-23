import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sub_category_model.dart';

class SubCategoryRemoteDataSource {
  final http.Client client;

  SubCategoryRemoteDataSource(this.client);

  Future<List<SubCategory>> fetchSubCategories() async {
    print("object -1");
    final response = await client.get(
      Uri.parse('http://192.168.1.102:8000/api/sub-category'),
    );
    print("object-2");
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> dataList = decoded['data'];
      return dataList.map((item) => SubCategory.fromJson(item)).toList();
    } else {
      print("object-3");
      throw Exception('Failed to load subcategories');
    }
  }
}
