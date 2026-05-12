import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/planDataCubit/plan_data_states.dart';
import 'package:repairo_provider/data/models/plan_details_model.dart';
import 'package:repairo_provider/data/repository/plan_details_repository.dart';

class PlanDataCubit extends Cubit<PlanDataStates> {
  PlanDataCubit(this.planDataRepository) : super(PlanDataInitial());

  final PlanDataRepository planDataRepository;
  late RPlanDetailsData Plandata;

  Future<RPlanDetailsData?> getPlanData(String id) async {
    emit(PlanDataLoading());
    try {
      final Planinfo = await planDataRepository.getPlanData(id);
      print("insideee Plan d cubitttt");
      print(Planinfo);
      emit(PlanDataLoaded(Plandata: Planinfo));
      return Planinfo;
    } catch (e) {
      print("error in cubit: $e");
      emit(PlanDataFailed(e.toString()));
      return null;
    }
  }
}
