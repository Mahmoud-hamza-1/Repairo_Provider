// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
// import 'package:repairo_provider/data/repository/profile_repository.dart';
// import 'package:repairo_provider/data/web_services/profile_webservices.dart';
// import 'package:repairo_provider/presentation/screens/home_screen.dart';
// import 'package:repairo_provider/presentation/screens/profile.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   late final List<Widget> _pages;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _pages = [const HomeScreen(), ProfileScreen()];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => ProfileCubit(ProfileRepository(ProfileWebservices())),
//         ),
//       ],
//       child: Scaffold(
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           selectedItemColor: const Color.fromRGBO(95, 96, 185, 1),
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           ],
//         ),
//         body: IndexedStack(index: _selectedIndex, children: _pages),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/business_logic/HomeCubit/home_cubit.dart';
import 'package:repairo_provider/business_logic/NotifficationsCubit/notiffications_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/business_logic/StatisticsCubit/statistics_cubit.dart';
import 'package:repairo_provider/business_logic/TechRequestsCubit/tech_requests_cubit.dart';
import 'package:repairo_provider/business_logic/TechServicesCubit/tech_services_cubit.dart';
import 'package:repairo_provider/data/repository/categories_repository.dart';
import 'package:repairo_provider/data/repository/home_repository.dart';
import 'package:repairo_provider/data/repository/notiffications_repository.dart';
import 'package:repairo_provider/data/repository/profile_repository.dart';
import 'package:repairo_provider/data/repository/statistics_repository.dart';
import 'package:repairo_provider/data/repository/tech_services_repository.dart';
import 'package:repairo_provider/data/repository/user_requests_repository.dart';
import 'package:repairo_provider/data/web_services/categories_webservices.dart';
import 'package:repairo_provider/data/web_services/home_webservices.dart';
import 'package:repairo_provider/data/web_services/notiffications_webservice.dart';
import 'package:repairo_provider/data/web_services/profile_webservices.dart';
import 'package:repairo_provider/data/web_services/statistics_webservice.dart';
import 'package:repairo_provider/data/web_services/tech_services_webservice.dart';
import 'package:repairo_provider/data/web_services/user_requests_webservices.dart';
import 'package:repairo_provider/presentation/screens/home_screen.dart';
import 'package:repairo_provider/presentation/screens/profile.dart';
import 'package:repairo_provider/presentation/screens/tech_requests.dart';
import 'package:repairo_provider/presentation/screens/tech_services.dart';

class MainScreen extends StatefulWidget {
  final bool isSubscribed; // تم إضافة برامتر اختياري جديد

  const MainScreen({
    super.key,
    this.isSubscribed = false,
  }); // تم تعديل الـ Constructor

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late PermissionStatus _permissionGranted;
  // LocationData? currentLocation;
  // final Location location = Location();

  // Future<void> getLocation() async {
  //   bool _serviceEnabled;

  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) return;
  //   }

  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) return;
  //   }

  //   final loc = await location.getLocation();
  //   setState(() {
  //     currentLocation = loc;
  //     // final prefs = await SharedPreferences.getInstance();
  //     // await prefs.setString('lat', currentLocation!.latitude.toString());
  //     // await prefs.setString('lng', currentLocation!.longitude.toString());
  //   });
  // }

  int _selectedIndex = 0;

  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- دالة للتحقق من الحالة وإظهار الـ Dialog ---
  void _checkStatusAndShowDialog() {
    // جلب الحالة مباشرة من المتغير العام
    String status = AppConstants.subscription_status;

    // التحقق من القيمة باستخدام if/else حصراً
    if (status == 'inactive') {
      // إذا كانت القيمة 'inactive'، أظهر الـ Dialog
      showDialog(
        context: context,
        barrierDismissible: false, // لمنع إغلاق الـ Dialog بالضغط في الخارج
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('انتهاء الاشتراك'),
            content: const Text('الرجاء تجديد اشتراكك للمتابعة.'),
            actions: <Widget>[
              TextButton(
                child: const Text('موافق'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pushNamed('subscription_plans');
                },
              ),
            ],
          );
        },
      );
    } else {
      print(
        "لم تنته فترة الاشتراك",
      ); // إذا كانت القيمة أي شيء آخر، لا تفعل شيئاً
    }
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(),
      // const SearchScreen(),
      //MapScreen(),
      ProfileScreen(),
      TechRequests(),
      TechServicesScreen(),
    ];

    // if (widget.isSubscribed == false) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text("تنبيه"),
    //           content: const Text(
    //             "عليك الاشتراك في خطة للوصول إلى كافة الميزات.",
    //           ),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text("حسناً"),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AllcategoriesCubit(
                CategoriesRepository(
                  categoriesWebservices: CategoriesWebservices(),
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) =>
                  HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(ProfileRepository(ProfileWebservices())),
        ),
        BlocProvider(
          create:
              (_) => TechRequestsCubit(
                TechRequestsRepository(
                  techRequestsWebservices: TechRequestsWebservices(),
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => AllstatisticsCubit(
                StatisticsRepository(StatisticsWebservice()),
              ),
        ),
        BlocProvider(
          create:
              (_) => NotifficationsCubit(
                AllNotifficationsRepository(
                  allNotifficationsWebservice: AllNotifficationsWebservice(),
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => TechServicesCubit(
                TechServicesRepository(
                  techServicesWebservice: TechServicesWebservice(),
                ),
              ),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0), // زاوية علوية يسار
              topRight: Radius.circular(16.0), // زاوية علوية يمين
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withValues(alpha: .1),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: GNav(
                style: GnavStyle.google,
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.teal,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: [
                  GButton(
                    hoverColor: Colors.tealAccent,
                    icon: LineIcons.home,
                    text: 'الرئيسية',
                    textStyle: TextStyle(
                      fontFamily: "Cairo",
                      color: Colors.teal,
                    ),
                  ),

                  GButton(
                    icon: LineIcons.user,
                    text: 'حسابي',
                    textStyle: TextStyle(
                      fontFamily: "Cairo",
                      color: Colors.teal,
                    ),
                  ),
                  GButton(
                    icon: LineIcons.book,
                    text: 'الحجوزات',
                    textStyle: TextStyle(
                      fontFamily: "Cairo",
                      color: Colors.teal,
                    ),
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'خدماتي',
                    textStyle: TextStyle(
                      fontFamily: "Cairo",
                      color: Colors.teal,
                    ),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        body: IndexedStack(index: _selectedIndex, children: _pages),
      ),
    );
  }
}
