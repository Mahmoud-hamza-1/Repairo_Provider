import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/PlansCubit/plans_states.dart';
import 'package:repairo_provider/data/models/plans_model.dart';
import 'package:repairo_provider/data/repository/plans_repository.dart';

class AllplansCubit extends Cubit<AllplansStates> {
  AllplansCubit(this.plansRepository) : super(AllplansInitial());

  final PlansRepository plansRepository;
  late List<RPLansData> plans = [];

  Future<List<RPLansData>> getAllplans() async {
    plansRepository.getAllPlans().then((theplans) {
      emit(AllplansLoaded(plans: theplans));
      plans = theplans;
    });
    return plans;
  }
}
