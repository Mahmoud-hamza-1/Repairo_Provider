import 'package:repairo_provider/data/models/plan_details_model.dart';

abstract class PlanDataStates {}

class PlanDataInitial extends PlanDataStates {}

class PlanDataFailed extends PlanDataStates {
  final String message;
  PlanDataFailed(this.message);
}

class PlanDataLoading extends PlanDataStates {}

class PlanDataLoaded extends PlanDataStates {
  final RPlanDetailsData Plandata;
  PlanDataLoaded({required this.Plandata});
}
