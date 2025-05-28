import 'package:bloc/bloc.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_states.dart';
import 'package:repairo_provider/data/models/service_model.dart';
import 'package:repairo_provider/data/repository/services_repository.dart';

class ServiceCubit extends Cubit<ServiceStates> {
  ServiceCubit(this.serviceRepository) : super(ServiceInitial());

  final ServiceRepository serviceRepository;
  late List<RServiceData> services = [];

  late List selectedServices = [];

  Future<void> getServices(String id) async {
    emit(ServiceLoading());
    try {
      final theservices = await serviceRepository.getServices(id);
      services = theservices;
      emit(ServiceLoaded(services: theservices));
    } catch (e) {
      emit(ServiceFailed("فشل تحميل الخدمات"));
    }
  }
}
