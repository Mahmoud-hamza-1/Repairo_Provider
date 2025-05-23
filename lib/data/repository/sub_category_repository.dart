import 'package:repairo_provider/data/web_services/sub_category_remote_data_source.dart';

import '../models/sub_category_model.dart';

class SubCategoryRepository {
  final SubCategoryRemoteDataSource remoteDataSource;

  SubCategoryRepository(this.remoteDataSource);

  Future<List<SubCategory>> getSubCategories() {
    return remoteDataSource.fetchSubCategories();
  }
}
