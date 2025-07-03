import 'package:repairo_provider/data/models/notifiation_model.dart';

class NotificationRepository {
  final List<NotificationModel> _mockData = [];

  Future<List<NotificationModel>> fetchNotifications() async {
    // مؤقتًا: ترجع بيانات وهمية
    return Future.delayed(
      Duration(seconds: 1),
      () => _mockData.reversed.toList(),
    );
  }

  void addNotification(NotificationModel notification) {
    _mockData.add(notification);
  }
}
