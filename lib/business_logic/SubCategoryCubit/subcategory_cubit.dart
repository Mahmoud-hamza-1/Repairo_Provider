import 'package:bloc/bloc.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_states.dart';
import 'package:repairo_provider/data/models/subcategory_model.dart'
    show RSubCategoryData;
import 'package:repairo_provider/data/repository/subcategory_repository.dart';

class SubcategoryCubit extends Cubit<SubcategoryStates> {
  SubcategoryCubit(this.subcategoryRepository) : super(SubcategoriesInitial());

  final SubcategoryRepository subcategoryRepository;
  late List<RSubCategoryData> subcategories = [];

  // Future<List<RSubCategoryData>> getSubCategories(String id) async {
  //   subcategoryRepository.getSubCAtegories(id).then((thesubcategories) {
  //     emit(SubcategoriesLoaded(subcategories: subcategories));
  //     subcategories = thesubcategories;
  //   });
  //   return subcategories;
  // }

  Future<void> getSubCategories(String id) async {
    emit(SubcategoriesLoading());
    try {
      final thesubcategories = await subcategoryRepository.getSubCAtegories(id);
      subcategories = thesubcategories;
      emit(SubcategoriesLoaded(subcategories: thesubcategories));
    } catch (e) {
      emit(SubcategoriesFailed("حدث خطأ أثناء تحميل الفئات الفرعية"));
    }
  }
}
