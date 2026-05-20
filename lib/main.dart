import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairo_provider/app_router.dart';
import 'package:repairo_provider/core/services/firebase_api.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// أثناء انتظار Firebase تظهر شاشة تشغيل أندرويد الأصلية (اللوغو) ثم أول إطار يفتح مباشرة على تسجيل الدخول.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  await FirebaseApi().initNotiffications();
  runApp(BreakingBadApp(appRouter: AppRouter(), navigatorKey: navigatorKey));
}

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
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.teal,

            // اللون العام للخلفيات (scaffold)
            scaffoldBackgroundColor: Colors.white,

            // الخط العام
            fontFamily: GoogleFonts.cairo().fontFamily,
            textTheme: GoogleFonts.cairoTextTheme(),

            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Color.fromARGB(255, 124, 155, 207),
              selectionHandleColor: Color.fromARGB(255, 124, 155, 207),
              cursorColor: Color.fromARGB(255, 124, 155, 207),
            ),
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: 'login',

          // 👇 ضيف هدول
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en', ''), // انجليزي
            Locale('ar', ''), // عربي
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:repairo_provider/chat/core/dio_helper.dart';
// import 'package:repairo_provider/chat/core/navigator_utils.dart';
// import 'package:repairo_provider/chat/core/widgets/app_button.dart';
// import 'package:repairo_provider/chat/features/chat/chat_screen.dart';
// import 'package:repairo_provider/chat/features/chat/cubit/chat_cubit.dart';

// void main() {
//   DioHelper.init();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Full Pusher Chat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff168AFF)),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Pusher Full Features Chat'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ChatCubit(),
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 widget.title,
//                 style: const TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff168AFF),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(400),
//                   child: Image.asset("assets/images/logo.png"),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               AppButton(
//                 buttonText: "Go To Chat",
//                 onPressed: () {
//                   pushScreen(
//                     context,
//                     BlocProvider(
//                       create: (context) => ChatCubit(),
//                       child: const ChatScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:repairo_provider/chat/core/dio_helper.dart'; // تم التعليق عليه - لم نعد بحاجة له
// import 'package:repairo_provider/chat/core/navigator_utils.dart';
// import 'package:repairo_provider/chat/core/widgets/app_button.dart';
// import 'package:repairo_provider/chat/features/chat/chat_screen.dart';
// import 'package:repairo_provider/chat/features/chat/cubit/chat_cubit.dart';

// void main() {
//   // DioHelper.init(); // 1. تم حذف هذا السطر
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Full Pusher Chat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff168AFF)),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Pusher Full Features Chat'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     // توفير الـ Cubit هنا للشاشة الرئيسية
//     return BlocProvider(
//       create: (context) => ChatCubit(),
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 widget.title,
//                 style: const TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff168AFF),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // ... (باقي الواجهة كما هي)
//               AppButton(
//                 buttonText: "Go To Chat",
//                 onPressed: () {
//                   // 2. تم تعديل هذا الجزء
//                   pushScreen(
//                     context,
//                     // من الأفضل توفير Cubit جديد خاص بشاشة الدردشة
//                     BlocProvider(
//                       create: (context) => ChatCubit(),
//                       // قمنا بتمرير الـ chatId المطلوب
//                       // ملاحظة: في تطبيق حقيقي، هذا الـ ID يأتي من قائمة المحادثات
//                       // وليس ثابتًا هكذا.
//                       child: const ChatScreen(
//                         chatId: "9f7215a9-1336-4705-9f5b-bc93468dc34b",
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
