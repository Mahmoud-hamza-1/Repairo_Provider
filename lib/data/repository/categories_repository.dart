import 'package:repairo_provider/data/models/category_model.dart';
import 'package:repairo_provider/data/web_services/categories_webservices.dart';

class CategoriesRepository {
  final CategoriesWebservices categoriesWebservices;

  CategoriesRepository({required this.categoriesWebservices});

  Future<List<RCategoryData>> getAllCategories() async {
    final items = await categoriesWebservices.getAllCategories();
    return items.map((item) => RCategoryData.fromJson(item)).toList();
  }
}
