import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_cubit.dart';
import 'package:repairo_provider/data/repository/update_request_repository.dart';
import 'package:repairo_provider/data/web_services/update_request_webservice.dart';
import 'package:repairo_provider/presentation/screens/request_from_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("title ${message.notification?.title}");
  print("body ${message.notification?.body}");
  print("payload ${message.data}");
  //  await LocalNotifications.showNotification(message);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    //the directed page should recieva a message paramete
    Get.toNamed("mainscreen");
  }

  Future initPushNotiffications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    //responsible for performing an action when app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotiffications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("token $fcmToken");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm', fcmToken!);

    initPushNotiffications();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // لما يكون التطبيق مفتوح (foreground)
    FirebaseMessaging.onMessage.listen((message) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data['type'] == 'technician_accept') {
          final reqid = message.data['service_request_id'];

          // روح عالسكرين واحمل الداتا
          // Get.to(() => BlocProvider(
          //    create: (context) =>
          //   child: NewRequestScreen(requestId: reqid,)));

          Get.to(
            () => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (context) => UpdateRequestCubit(
                        UpdateRequestRepository(UpdateRequestWebservice()),
                      ),
                ),
              ],
              child: NewRequestScreen(requestId: reqid),
            ),
          );
        }
      });

      print("Foreground message: ${message.notification?.title}");
      //LocalNotifications.showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("User tapped notification: ${message.data}");
    });
  }
}
