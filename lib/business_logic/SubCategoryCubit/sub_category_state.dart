import '../../data/models/sub_category_model.dart';

abstract class SubCategoryState {}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final List<SubCategory> subCategories;

  SubCategoryLoaded(this.subCategories);
}

class SubCategoryError extends SubCategoryState {
  final String message;

  SubCategoryError(this.message);
}
