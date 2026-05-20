import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/TechServicesCubit/tech_services_states.dart';
import 'package:repairo_provider/data/models/tech_services_model.dart';
import 'package:repairo_provider/data/repository/tech_services_repository.dart';

// class TechServicesCubit extends Cubit<TechServicesStates> {
//   TechServicesCubit(this.techServicesRepository) : super(TechServicesInitial());

//   final TechServicesRepository techServicesRepository;
//   late RTechServicesData techservices;

//   Future<RTechServicesData?> getTechServices() async {
//     emit(TechServicesLoading());
//     try {
//       final services = await techServicesRepository.getTechServices();
//       // print("insideee Plan d cubitttt");
//       // print(Planinfo);
//       emit(TechServicesLoaded(techservices: techservices));
//       return techservices
//     } catch (e) {
//       print("error in cubit: $e");
//       emit(PlanDataFailed(e.toString()));
//       return null;
//     }
//   }
// }

class TechServicesCubit extends Cubit<TechServicesStates> {
  TechServicesCubit(this.techServicesRepository) : super(TechServicesInitial());
  final TechServicesRepository techServicesRepository;
  late RTechServicesData techservices;
  Future<void> getTechServices() async {
    // يفضل استخدام Future<void>
    emit(TechServicesLoading());
    try {
      final List<RTechServicesData> services =
          await techServicesRepository.getTechServices();
      // هنا يجب التعامل مع القائمة، وليس كائن واحد
      // يمكنك تمرير القائمة بأكملها في الحالة
      emit(
        TechServicesLoaded(techservices: services.first),
      ); // مثلاً إذا كنت متأكدًا أنها تحتوي على عنصر واحد
      // أو
      // emit(TechServicesLoaded(techservices: services)); // إذا كنت تريد تمرير القائمة كلها
    } catch (e) {
      print("error in cubit: $e");
      emit(TechServicesFailed(e.toString())); // تم تعديل الحالة هنا
    }
  }

  Future<void> updateTechServices(RTechServicesData techServicesData) async {
    emit(TechServicesSaving());
    try {
      await techServicesRepository.updateTechServices(techServicesData);
      emit(TechServicesSaved());
      // إعادة جلب البيانات بعد الحفظ لضمان تحديث الواجهة
      getTechServices();
    } catch (e) {
      print("error in cubit: $e");
      emit(TechServicesSaveFailed(e.toString()));
    }
  }
}
