import 'package:repairo_provider/data/web_services/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepository(this.remoteDataSource);

  Future<List<Category>> fetchCategories() {
    return remoteDataSource.getCategories();
  }
}
