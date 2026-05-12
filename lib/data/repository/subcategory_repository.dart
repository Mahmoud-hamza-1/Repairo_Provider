import 'package:repairo_provider/data/models/subcategory_model.dart';
import 'package:repairo_provider/data/web_services/subcategories_webservice.dart';

class SubcategoryRepository {
  final SubcategoriesWebservice subcategoriesWebservice;

  SubcategoryRepository({required this.subcategoriesWebservice});

  Future<List<RSubCategoryData>> getSubCAtegories(String id) async {
    final items = await subcategoriesWebservice.getSubCategories(id);
    return items.map((item) => RSubCategoryData.fromJson(item)).toList();
  }
}
