import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:repairo_provider/data/repository/requset_details_repository.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsStates> {
  final RequsetDetailsRepository requsetDetailsRepository;

  RequestDetailsCubit(this.requsetDetailsRepository)
    : super(RequestDetailsInitial());

  void getRequestDetails(String id) async {
    emit(RequestDetailsLoading());
    try {
      final requestdetails = await requsetDetailsRepository.getRequestDetails(
        id,
      );
      emit(RequestDetailsSuccess(requestdetails));
    } catch (e) {
      emit(RequestDetailsError(e.toString()));
    }
  }
}
