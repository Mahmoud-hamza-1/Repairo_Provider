import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/app_router.dart';

void main() {
  runApp(BreakingBadApp(appRouter: AppRouter()));
}

class BreakingBadApp extends StatelessWidget {
  final AppRouter appRouter;

  const BreakingBadApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
