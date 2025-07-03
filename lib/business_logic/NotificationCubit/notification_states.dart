// notification_state.dart

import 'package:repairo_provider/data/models/notifiation_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded({required this.notifications});
}
