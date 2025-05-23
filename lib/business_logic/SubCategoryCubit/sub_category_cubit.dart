import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/sub_category_model.dart';
import '../../data/repository/sub_category_repository.dart';
import 'sub_category_state.dart';

class SubCategoryCubit extends Cubit<SubCategoryState> {
  final SubCategoryRepository repository;

  SubCategoryCubit(this.repository) : super(SubCategoryInitial());

  Future<void> loadSubCategories() async {
    emit(SubCategoryLoading());
    try {
      final subCategories = await repository.getSubCategories();
      emit(SubCategoryLoaded(subCategories));
    } catch (e) {
      emit(SubCategoryError(e.toString()));
    }
  }
}
