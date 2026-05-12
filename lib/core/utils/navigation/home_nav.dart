// import 'package:breaking_project/presentation/screens/allcategories.dart';
// import 'package:breaking_project/presentation/screens/home_screen.dart';
// import 'package:flutter/material.dart';

// class HomeNavState extends StatefulWidget {
//   const HomeNavState({super.key});

//   @override
//   State<HomeNavState> createState() => _HomeNavStateState();
// }

// class _HomeNavStateState extends State<HomeNavState> {
//   GlobalKey<NavigatorState> homenavkey = GlobalKey<NavigatorState>();
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: homenavkey,
//       onGenerateRoute: (RouteSettings settings) {
//         return MaterialPageRoute(
//           settings: settings,
//           builder: (BuildContext context) {
//             if (settings.name == 'allcategories') {
//               return const Allcategories();
//             }
//             return const HomeScreen();
//           },
//         );
//       },
//     );
//   }
// }
