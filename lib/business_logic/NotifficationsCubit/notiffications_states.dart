import 'package:repairo_provider/data/models/notiffications_model.dart';

abstract class NotifficationsStates {}

class NotifficationsInitial extends NotifficationsStates {}

class NotifficationsFailed extends NotifficationsStates {
  final String message;
  NotifficationsFailed(this.message);
}

class NotifficationsLoading extends NotifficationsStates {}

class NotifficationsLoaded extends NotifficationsStates {
  final List<RNotificationData> notiffications;
  NotifficationsLoaded({required this.notiffications});
}
