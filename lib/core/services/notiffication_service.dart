// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//     );

//     await _notifications.initialize(initSettings);
//   }

//   static Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'main_channel', // channel ID
//       'Main Channel', // channel name
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _notifications.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
// }
