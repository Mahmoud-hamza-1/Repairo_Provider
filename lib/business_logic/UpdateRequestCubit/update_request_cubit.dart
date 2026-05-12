import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_states.dart';
import 'package:repairo_provider/data/repository/update_request_repository.dart';
import 'package:repairo_provider/data/web_services/update_request_webservice.dart';

class UpdateRequestCubit extends Cubit<UpdateRequestStates> {
  final UpdateRequestRepository updateRequestRepository;

  UpdateRequestCubit(this.updateRequestRepository)
    : super(UpdateRequestInitial());

  void updaterequest({
    required String requestId,
    String? status, // status_request
    List<ServiceUpdate> services = const [],
    List<CustomServiceUpdate> customServices = const [],
  }) async {
    emit(UpdateRequestLoading());
    try {
      await updateRequestRepository.updateRequest(
        requestId: requestId,
        status: status,
        services: services,
        customServices: customServices,
      );
      emit(UpdateRequestSuccess());
    } catch (e) {
      emit(UpdateRequestError(e.toString()));
    }
  }
}
