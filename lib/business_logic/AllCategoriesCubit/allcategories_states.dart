import 'package:repairo_provider/data/models/category_model.dart';

abstract class AllcategoriesStates {}

class AllcategoriesInitial extends AllcategoriesStates {}

class AllcategoriesFailed extends AllcategoriesStates {
  final String message;
  AllcategoriesFailed(this.message);
}

class AllcategoriesLoading extends AllcategoriesStates {}

class AllcategoriesLoaded extends AllcategoriesStates {
  final List<RCategoryData> categories;
  AllcategoriesLoaded({required this.categories});
}
