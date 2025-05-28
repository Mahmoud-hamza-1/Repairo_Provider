import 'package:repairo_provider/data/models/subcategory_model.dart';

abstract class SubcategoryStates {}

class SubcategoriesInitial extends SubcategoryStates {}

class SubcategoriesFailed extends SubcategoryStates {
  final String message;
  SubcategoriesFailed(this.message);
}

class SubcategoriesLoading extends SubcategoryStates {}

class SubcategoriesLoaded extends SubcategoryStates {
  final List<RSubCategoryData> subcategories;
  SubcategoriesLoaded({required this.subcategories});
}
