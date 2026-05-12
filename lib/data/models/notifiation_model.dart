enum NotificationType {
  interactive, // قابل للتفاعل (مثل طلب خدمة)
  passive, // غير تفاعلي (تنبيه أو معلومة)
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime dateTime;
  final NotificationType type;
  final Map<String, dynamic>? metadata; // بيانات إضافية مثل ID الطلب

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.type,
    this.metadata,
  });
}
