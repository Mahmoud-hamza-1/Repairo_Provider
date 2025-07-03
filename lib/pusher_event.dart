// import 'package:flutter/material.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

// class PusherTestPage extends StatefulWidget {
//   @override
//   _PusherTestPageState createState() => _PusherTestPageState();
// }

// class _PusherTestPageState extends State<PusherTestPage> {
//   late PusherChannelsFlutter pusher;
//   String message = "لا توجد رسائل بعد";

//   @override
//   void initState() {
//     super.initState();
//     initPusher();
//   }

//   Future<void> initPusher() async {
//     pusher = PusherChannelsFlutter();

//     try {
//       await pusher.init(
//         apiKey: "f5fb1d31069130234a9f",
//         cluster: "mt1",
//         onConnectionStateChange: (String previousState, String currentState) {
//           print("Connection changed from $previousState to $currentState");
//         },
//         onError: (String message, int? code, dynamic e) {
//           print("Error message: $message");
//           print("Error code: $code");
//           print("Extra info: $e");
//         },
//       );

//       await pusher.subscribe(
//         channelName: "repairo-channel", // اسم القناة
//         onEvent: (event) {
//           print("حدث وصل: ${event.eventName}");
//           print("بيانات الحدث: ${event.data}");
//           setState(() {
//             message = event.data ?? "حدث بدون بيانات";
//           });
//         },
//       );

//       await pusher.connect();
//     } catch (e) {
//       print("فشل الاتصال بـ Pusher: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Pusher Event Listener")),
//       body: Center(child: Text(message)),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:repairo_provider/business_logic/NotificationCubit/notification_cubit.dart';
import 'package:repairo_provider/data/models/notifiation_model.dart';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;

  late PusherChannelsFlutter _pusher;
  NotificationCubit? _notificationCubit;
  GlobalKey<NavigatorState>? _navigatorKey;

  PusherService._internal();

  Future<void> init({
    required NotificationCubit notificationCubit,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    _notificationCubit = notificationCubit;
    _navigatorKey = navigatorKey;

    _pusher = PusherChannelsFlutter();

    await _pusher.init(
      apiKey: "f5fb1d31069130234a9f",
      cluster: "mt1",
      onConnectionStateChange: (prev, current) {
        print("Pusher: $prev -> $current");
      },
      onError: (message, code, e) {
        print("Pusher Error: $message");
      },
    );

    await _pusher.subscribe(
      channelName: "repairo-channel",
      onEvent: (dynamic event) {
        _handleEvent(event as PusherEvent); // 👈 نعمل cast هنا
      },
    );

    await _pusher.connect();
  }

  void _handleEvent(PusherEvent event) {
    if (event.eventName == "new-notification") {
      final data = jsonDecode(event.data ?? "{}");
      final notification = NotificationModel(
        id: data["id"] ?? "",
        title: data["title"] ?? "تنبيه",
        body: data["body"] ?? "",
        dateTime: DateTime.tryParse(data["timestamp"] ?? "") ?? DateTime.now(),
        type:
            data["type"] == "interactive"
                ? NotificationType.interactive
                : NotificationType.passive,
        metadata: data["metadata"],
      );

      // 1️⃣ إضافة الإشعار إلى Bloc
      _notificationCubit?.addNotification(notification);

      // 2️⃣ عرض Snackbar في الأعلى
      final context = _navigatorKey?.currentContext;
      if (context != null) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text("${notification.title} - ${notification.body}"),
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 60, left: 16, right: 16),
          ),
        );
      }
    }
  }
}
