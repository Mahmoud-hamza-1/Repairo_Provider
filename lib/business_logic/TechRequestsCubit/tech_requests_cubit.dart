import 'package:bloc/bloc.dart';
import 'package:repairo_provider/business_logic/TechRequestsCubit/tech_requests_states.dart';
import 'package:repairo_provider/data/models/user_requests_model.dart';
import 'package:repairo_provider/data/repository/user_requests_repository.dart';

class TechRequestsCubit extends Cubit<TechRequestsStates> {
  TechRequestsCubit(this.techRequestsRepository) : super(TechRequestsInitial());

  final TechRequestsRepository techRequestsRepository;
  late List<RTechRequestData> requests = [];

  Future<List<RTechRequestData>> getTechRequests({String? status}) async {
    techRequestsRepository.getAllRequests(status: status).then((therequests) {
      emit(TechRequestsLoaded(requests: therequests));
      requests = therequests;
    });
    return requests;
  }
}
