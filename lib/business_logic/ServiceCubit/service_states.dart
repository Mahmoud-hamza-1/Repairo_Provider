import 'package:repairo_provider/data/models/service_model.dart';

abstract class ServiceStates {}

class ServiceInitial extends ServiceStates {}

class ServiceFailed extends ServiceStates {
  final String message;
  ServiceFailed(this.message);
}

class ServiceLoading extends ServiceStates {}

class ServiceLoaded extends ServiceStates {
  final List<RServiceData> services;
  ServiceLoaded({required this.services});
}
