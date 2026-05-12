import 'package:repairo_provider/data/models/plan_details_model.dart';
import 'package:repairo_provider/data/models/tech_services_model.dart';

abstract class TechServicesStates {}

class TechServicesInitial extends TechServicesStates {}

class TechServicesFailed extends TechServicesStates {
  final String message;
  TechServicesFailed(this.message);
}

class TechServicesLoading extends TechServicesStates {}

class TechServicesSaving extends TechServicesStates {}

class TechServicesSaved extends TechServicesStates {}

class TechServicesSaveFailed extends TechServicesStates {
  final String message;
  TechServicesSaveFailed(this.message);
}

class TechServicesLoaded extends TechServicesStates {
  final RTechServicesData techservices;
  TechServicesLoaded({required this.techservices});
}
