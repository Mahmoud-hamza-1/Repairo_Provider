import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/NotificationCubit/notification_states.dart';
import 'package:repairo_provider/data/models/notifiation_model.dart';
import 'package:repairo_provider/data/repository/notificcation_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    final data = await repository.fetchNotifications();
    emit(NotificationLoaded(notifications: data));
  }

  void addNotification(NotificationModel notification) {
    repository.addNotification(notification);
    loadNotifications();
  }
}
