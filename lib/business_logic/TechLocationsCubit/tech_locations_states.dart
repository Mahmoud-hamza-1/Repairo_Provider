import 'package:repairo_provider/data/models/tech_location_model.dart';

abstract class TechLocationsStates {}

class TechLocationsInitial extends TechLocationsStates {}

class TechLocationsFailed extends TechLocationsStates {
  final String message;
  TechLocationsFailed(this.message);
}

class TechLocationsLoading extends TechLocationsStates {}

class TechLocationsLoaded extends TechLocationsStates {
  final List<RUserLocationData> locations;
  TechLocationsLoaded({required this.locations});
}
