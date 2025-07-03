// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:repairo_provider/app_router.dart';

// void main() {
//   runApp(BreakingBadApp(appRouter: AppRouter()));
// }

// class BreakingBadApp extends StatelessWidget {
//   final AppRouter appRouter;

//   const BreakingBadApp({super.key, required this.appRouter});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       theme: ThemeData(
//         textSelectionTheme: const TextSelectionThemeData(
//           selectionColor: Color.fromARGB(255, 124, 155, 207),
//           selectionHandleColor: Color.fromARGB(255, 124, 155, 207),
//           cursorColor: Color.fromARGB(255, 124, 155, 207),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       onGenerateRoute: appRouter.generateRoute,
//       initialRoute: 'pusher',
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:repairo_provider/app_router.dart';
import 'package:repairo_provider/business_logic/NotificationCubit/notification_cubit.dart';
import 'package:repairo_provider/data/repository/notificcation_repository.dart';
import 'package:repairo_provider/pusher_event.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  final notificationRepo = NotificationRepository();
  final notificationCubit = NotificationCubit(notificationRepo);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NotificationCubit>(
          create: (_) => notificationCubit..loadNotifications(),
        ),
      ],
      child: BreakingBadApp(appRouter: AppRouter(), navigatorKey: navigatorKey),
    ),
  );

  // ربط Pusher بالخدمة بعد تشغيل التطبيق
  PusherService().init(
    notificationCubit: notificationCubit,
    navigatorKey: navigatorKey,
  );
}

// class BreakingBadApp extends StatelessWidget {
//   final AppRouter appRouter;
//   final GlobalKey<NavigatorState> navigatorKey;

//   const BreakingBadApp({
//     super.key,
//     required this.appRouter,
//     required this.navigatorKey,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       navigatorKey: navigatorKey, // لعرض Snackbar العلوية
//       theme: ThemeData(
//         textSelectionTheme: const TextSelectionThemeData(
//           selectionColor: Color.fromARGB(255, 124, 155, 207),
//           selectionHandleColor: Color.fromARGB(255, 124, 155, 207),
//           cursorColor: Color.fromARGB(255, 124, 155, 207),
//         ),
//       ),
//       debugShowCheckedModeBanner: false,
//       onGenerateRoute: appRouter.generateRoute,
//       initialRoute: 'login', // يمكنك تغييره إلى 'home' أو غيره لاحقاً
//     );
//   }
// }

class BreakingBadApp extends StatelessWidget {
  final AppRouter appRouter;
  final GlobalKey<NavigatorState> navigatorKey;

  const BreakingBadApp({
    super.key,
    required this.appRouter,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey, // 👈 مهم لعرض Snackbar
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color.fromARGB(255, 124, 155, 207),
          selectionHandleColor: Color.fromARGB(255, 124, 155, 207),
          cursorColor: Color.fromARGB(255, 124, 155, 207),
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: 'login',
    );
  }
}
