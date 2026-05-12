import 'package:repairo_provider/data/models/tech_requests_model.dart';

abstract class TechRequestsStates {}

class TechRequestsInitial extends TechRequestsStates {}

class TechRequestsFailed extends TechRequestsStates {
  final String message;
  TechRequestsFailed(this.message);
}

class TechRequestsLoading extends TechRequestsStates {}

class TechRequestsLoaded extends TechRequestsStates {
  final List<RTechRequestData> requests;
  TechRequestsLoaded({required this.requests});
}
