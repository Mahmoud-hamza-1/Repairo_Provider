// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:get/get.dart';
// // import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
// // import 'package:repairo_provider/business_logic/TechRequestsCubit/tech_requests_cubit.dart';
// // import 'package:repairo_provider/core/constants/app_constants.dart';
// // import 'package:repairo_provider/data/repository/profile_repository.dart';
// // import 'package:repairo_provider/data/repository/user_requests_repository.dart';
// // import 'package:repairo_provider/data/web_services/profile_webservices.dart';
// // import 'package:repairo_provider/data/web_services/user_requests_webservices.dart';
// // import 'package:repairo_provider/presentation/screens/profile.dart';
// // import 'package:repairo_provider/presentation/screens/tech_requests.dart';

// // class UserData {
// //   final String name;
// //   final String imageUrl;

// //   UserData({required this.name, required this.imageUrl});

// //   factory UserData.fromJson(Map<String, dynamic> json) {
// //     String imageUrl = (json['image'] as String? ?? '').replaceFirst(
// //       'localhost',
// //       '${AppConstants.baseUrl}',
// //     );

// //     return UserData(name: json['name'] ?? 'No Name', imageUrl: imageUrl);
// //   }
// // }

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   late AnimationController _animationController;

// //   // --- New Future variable to hold the API call state ---
// //   late Future<UserData> _userDataFuture;

// //   // --- New function to fetch data from your API ---
// //   Future<UserData> _fetchUserData() async {
// //     // !!! IMPORTANT: Replace with your actual, valid auth token

// //     // !!! IMPORTANT: Replace 127.0.0.1 with your computer's local IP address
// //     final url = Uri.parse(
// //       '${AppConstants.baseUrl}/technician/account/personal-info',
// //     );

// //     final response = await http.get(
// //       url,
// //       headers: {
// //         'Accept': 'application/json',
// //         'Authorization': 'Bearer ${AppConstants.globalAccessToken}',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       final decodedBody = json.decode(response.body);
// //       return UserData.fromJson(decodedBody['data']);
// //     } else {
// //       throw Exception('Failed to load user data: ${response.reasonPhrase}');
// //     }
// //   }

// //   // Your original drawer items list
// //   late final List<Map<String, dynamic>> _drawerItems = [
// //     {
// //       'icon': Icons.home_outlined,
// //       'title': 'Home',
// //       'onTap': () {
// //         _scaffoldKey.currentState?.closeDrawer();
// //       },
// //     },
// //     {
// //       'icon': Icons.account_circle_outlined,
// //       'title': 'My Profile',
// //       'onTap': () {
// //         Get.to(
// //           () => BlocProvider(
// //             create:
// //                 (context) =>
// //                     ProfileCubit(ProfileRepository(ProfileWebservices())),
// //             child: const ProfileScreen(),
// //           ),
// //         );
// //       },
// //     },
// //     {
// //       'icon': Icons.outbox_rounded,
// //       'title': 'My Requests',
// //       'onTap': () {
// //         Get.to(
// //           () => BlocProvider(
// //             create:
// //                 (context) => TechRequestsCubit(
// //                   TechRequestsRepository(
// //                     techRequestsWebservices: TechRequestsWebservices(),
// //                   ),
// //                 ),
// //             child: const TechRequests(),
// //           ),
// //         );
// //       },
// //     },
// //     {
// //       'icon': Icons.settings_outlined,
// //       'title': 'Settings',
// //       'onTap': () {
// //         print("Navigating to Settings...");
// //       },
// //     },
// //     {
// //       'icon': Icons.logout,
// //       'title': 'Logout',
// //       'onTap': () {
// //         print("Logging out...");
// //       },
// //     },
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     // --- Start fetching user data when the screen loads ---
// //     _userDataFuture = _fetchUserData();

// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 600),
// //     );
// //     _animationController.forward();
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }

// //   // Your original _buildAnimatedDrawerItem function
// //   Widget _buildAnimatedDrawerItem({
// //     required Map<String, dynamic> item,
// //     required int index,
// //   }) {
// //     final animation = Tween<Offset>(
// //       begin: const Offset(-1, 0),
// //       end: Offset.zero,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: _animationController,
// //         curve: Interval(0.1 * index, 0.5 + 0.1 * index, curve: Curves.easeOut),
// //       ),
// //     );

// //     return SlideTransition(
// //       position: animation,
// //       child: FadeTransition(
// //         opacity: _animationController,
// //         child: ListTile(
// //           leading: Icon(item['icon'], color: Colors.white70),
// //           title: Text(
// //             item['title'],
// //             style: const TextStyle(color: Colors.white, fontSize: 18),
// //           ),
// //           onTap: () {
// //             _scaffoldKey.currentState?.closeDrawer();
// //             Future.delayed(const Duration(milliseconds: 300), () {
// //               item['onTap']();
// //             });
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       drawer: ClipRRect(
// //         borderRadius: const BorderRadius.only(
// //           topRight: Radius.circular(35),
// //           bottomRight: Radius.circular(35),
// //         ),
// //         child: Drawer(
// //           width: 250,
// //           child: Container(
// //             decoration: const BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [Color(0xFF6F4EC9), Color(0xFF4A2F8C)],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //             ),
// //             child: ListView(
// //               padding: EdgeInsets.zero,
// //               children: [
// //                 DrawerHeader(
// //                   decoration: BoxDecoration(
// //                     border: Border(
// //                       bottom: BorderSide(color: Colors.white.withOpacity(0.2)),
// //                     ),
// //                   ),
// //                   // --- The DrawerHeader now uses a FutureBuilder ---
// //                   child: FutureBuilder<UserData>(
// //                     future: _userDataFuture,
// //                     builder: (context, snapshot) {
// //                       if (snapshot.connectionState == ConnectionState.waiting) {
// //                         return const Center(
// //                           child: CircularProgressIndicator(color: Colors.white),
// //                         );
// //                       }
// //                       if (snapshot.hasError) {
// //                         // Error State UI
// //                         return const Center(
// //                           child: Icon(
// //                             Icons.error,
// //                             color: Colors.white,
// //                             size: 40,
// //                           ),
// //                         );
// //                       }
// //                       if (snapshot.hasData) {
// //                         // Success State UI
// //                         final userData = snapshot.data!;
// //                         return Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             CircleAvatar(
// //                               radius: 35,
// //                               backgroundColor: Colors.white,
// //                               backgroundImage: NetworkImage(
// //                                 userData.imageUrl.replaceFirst(
// //                                   'localhost',
// //                                   '${AppConstants.baseaddress}:8000',
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 12),
// //                             Text(
// //                               userData.name, // Display fetched name
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.bold,
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       }
// //                       // Default case
// //                       return const SizedBox.shrink();
// //                     },
// //                   ),
// //                 ),
// //                 ..._drawerItems.asMap().entries.map((entry) {
// //                   int index = entry.key;
// //                   var item = entry.value;
// //                   return _buildAnimatedDrawerItem(item: item, index: index);
// //                 }).toList(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //       appBar: AppBar(title: const Text("Home Screen"), centerTitle: true),
// //       body: const Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.home, size: 80, color: Colors.black12),
// //             SizedBox(height: 20),
// //             Text(
// //               "Welcome Home!",
// //               style: TextStyle(fontSize: 24, color: Colors.black54),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:repairo_provider/business_logic/PlansCubit/plans_cubit.dart';
// import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_cubit.dart';
// import 'package:repairo_provider/data/repository/plans_repository.dart';
// import 'package:repairo_provider/data/repository/subscription_plan_repository.dart';
// import 'package:repairo_provider/data/web_services/plans_webservice.dart';
// import 'package:repairo_provider/data/web_services/subscription_plan_webservice.dart';
// import 'package:repairo_provider/presentation/screens/subscriptions_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String? techname;
//   bool? isSubscribed;

//   void _getTechName() async {
//     final prefs = await SharedPreferences.getInstance();
//     var uname = prefs.getString('tech_name');
//     if (uname != null) {
//       setState(() {
//         techname = uname;
//       });
//     }
//     print('tech name: $techname');
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadSubscription();
//   }

//   Future<void> _loadSubscription() async {
//     final prefs = await SharedPreferences.getInstance();
//     final sub = prefs.getBool('isSubscribed') ?? false;
//     setState(() {
//       isSubscribed = sub;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = TextStyle(fontFamily: "Cairo");

//     if (isSubscribed == null) {
//       return const Center(child: CircularProgressIndicator(color: Colors.teal));
//     }

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           title: Column(
//             children: [
//               Text(
//                 "الصفحة الرئيسية",
//                 style: textTheme.copyWith(color: Colors.white),
//               ),
//               Text(
//                 "أهلا بالمهني $techname ",
//                 style: textTheme.copyWith(color: Colors.grey, fontSize: 13),
//               ),
//             ],
//           ),
//           backgroundColor: Colors.teal,
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(4),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (isSubscribed == false)
//                 MaterialBanner(
//                   content: Text(
//                     "انتهى اشتراكك! يرجى تجديد الاشتراك لمتابعة استخدام التطبيق.",
//                     style: TextStyle(fontFamily: 'Cairo'),
//                   ),
//                   leading: Icon(
//                     Icons.warning_amber_rounded,
//                     color: Colors.orange,
//                   ),
//                   backgroundColor: Colors.teal.shade50,
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Get.to(
//                           () => MultiBlocProvider(
//                             providers: [
//                               BlocProvider(
//                                 create:
//                                     (context) => AllplansCubit(
//                                       PlansRepository(
//                                         plansWebservice: PlansWebservice(),
//                                       ),
//                                     ),
//                               ),
//                               BlocProvider(
//                                 create:
//                                     (context) => SubscriptionCubit(
//                                       SubscriptionPlanRepository(
//                                         SubscriptionPlanWebservice(),
//                                       ),
//                                     ),
//                               ),
//                             ],
//                             child: SubscriptionPlansScreen(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "جدد الآن",
//                         style: TextStyle(
//                           color: Colors.teal,
//                           fontFamily: "Cairo",
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               // القسم الأول: بطاقات الإحصائيات
//               GridView.count(
//                 shrinkWrap: true,
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   _StatCard(
//                     title: "الطلبات هذا الشهر",
//                     value: "24",
//                     icon: Icons.task_alt,
//                     color: Colors.teal,
//                   ),
//                   _StatCard(
//                     title: "الإيرادات",
//                     value: "450,000 ل.س",
//                     icon: Icons.attach_money,
//                     color: Colors.green,
//                   ),
//                   _StatCard(
//                     title: "الرصيد في المحفظة",
//                     value: "150,000 ل.س",
//                     icon: Icons.account_balance_wallet,
//                     color: Colors.orange,
//                   ),
//                   _StatCard(
//                     title: "الطلبات القادمة",
//                     value: "3",
//                     icon: Icons.schedule,
//                     color: Colors.blue,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // القسم الثاني: رسم بياني
//               Text("إحصائيات الطلبات", style: textTheme),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: 200,
//                 child: LineChart(
//                   LineChartData(
//                     gridData: FlGridData(show: false),
//                     borderData: FlBorderData(show: false),
//                     titlesData: FlTitlesData(
//                       leftTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: true),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: true),
//                       ),
//                       topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       rightTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                     ),
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: [
//                           FlSpot(1, 2),
//                           FlSpot(2, 4),
//                           FlSpot(3, 1.5),
//                           FlSpot(4, 5),
//                           FlSpot(5, 3),
//                           FlSpot(6, 4.5),
//                         ],
//                         isCurved: true,
//                         color: Colors.teal,
//                         barWidth: 3,
//                         dotData: FlDotData(show: true),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // القسم الثالث: الطلبات القادمة
//               Text("الطلبات القادمة", style: textTheme),
//               const SizedBox(height: 12),
//               Column(
//                 children: List.generate(3, (index) {
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.teal,
//                         child: Icon(
//                           Icons.home_repair_service,
//                           color: Colors.white,
//                         ),
//                       ),
//                       title: Text("طلب #${index + 1} - تركيب مكيف"),
//                       subtitle: Text("25 آب 2025 - الساعة 3:00 م"),
//                       trailing: Icon(Icons.arrow_forward_ios, size: 16),
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const _StatCard({
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = TextStyle(fontFamily: "Cairo");

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 8),
//           Text(title, style: textTheme.copyWith(color: Colors.grey[600])),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: textTheme.copyWith(
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/NotifficationsCubit/notiffications_cubit.dart';
import 'package:repairo_provider/business_logic/StatisticsCubit/statistics_cubit.dart';
import 'package:repairo_provider/business_logic/StatisticsCubit/statistics_states.dart';
import 'package:repairo_provider/business_logic/PlansCubit/plans_cubit.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:repairo_provider/data/repository/plans_repository.dart';
import 'package:repairo_provider/data/repository/statistics_repository.dart';
import 'package:repairo_provider/data/repository/subscription_plan_repository.dart';
import 'package:repairo_provider/data/web_services/plans_webservice.dart';
import 'package:repairo_provider/data/web_services/statistics_webservice.dart';
import 'package:repairo_provider/data/web_services/subscription_plan_webservice.dart';
import 'package:repairo_provider/presentation/screens/notiffications_screen.dart';
import 'package:repairo_provider/presentation/screens/subscriptions_screen.dart';
import 'package:repairo_provider/data/models/statistics_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? techname;
  String? techlocation;
  bool? isSubscribed;
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale("ar", "SA"), // عربي
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale("ar", "SA"),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
      });
    }
  }

  void _getTechName() async {
    final prefs = await SharedPreferences.getInstance();
    var uname = prefs.getString('tech_name');
    if (uname != null) {
      setState(() {
        techname = uname;
      });
    }
  }

  void _getTechLocation() async {
    final prefs = await SharedPreferences.getInstance();
    var ulocation = prefs.getString('user_current_location');
    if (ulocation != null) {
      setState(() {
        techlocation = ulocation;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getTechName();
    _loadSubscription();

    // جلب البيانات من الكيوبيت
    context.read<AllstatisticsCubit>().getAllstatistics();
  }

  Future<void> _loadSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final sub = prefs.getBool('isSubscribed');
    setState(() {
      isSubscribed = sub;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(fontFamily: "Cairo");

    if (isSubscribed == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الصفحة الرئيسية",
                style: textTheme.copyWith(color: Colors.white),
              ),
              Text(
                techname ?? "",

                style: textTheme.copyWith(color: Colors.white, fontSize: 13),
              ),
              Row(
                children: [
                  Text(
                    techlocation ?? "دمشق-كفرسوسة",
                    style: textTheme.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: context.read<NotifficationsCubit>(),
                          child: NotificationsScreen(),
                        ),
                  ),
                );
              },
            ),
          ],
          backgroundColor: Colors.teal,
        ),

        body: BlocBuilder<AllstatisticsCubit, AllstatisticsStates>(
          builder: (context, state) {
            if (state is AllstatisticsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            } else if (state is AllstatisticsFailed) {
              return Center(
                child: Text(
                  "حدث خطأ ما يرجى المحاولة لاحقا ",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
              );
            } else if (state is AllstatisticsLoaded) {
              final RStatisticsData stats = state.statistics;

              if (stats == null) {
                return Center(
                  child: Text(
                    " لا توجد إحصائيات لعرضها  ",
                    style: TextStyle(fontFamily: "Cairo"),
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSubscribed == false)
                      MaterialBanner(
                        content: Text(
                          "انتهى اشتراكك! يرجى تجديد الاشتراك لمتابعة استخدام التطبيق.",
                          style: TextStyle(fontFamily: 'Cairo'),
                        ),
                        leading: Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                        ),
                        backgroundColor: Colors.teal.shade50,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.to(
                                () => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create:
                                          (context) => AllplansCubit(
                                            PlansRepository(
                                              plansWebservice:
                                                  PlansWebservice(),
                                            ),
                                          ),
                                    ),
                                    BlocProvider(
                                      create:
                                          (context) => SubscriptionCubit(
                                            SubscriptionPlanRepository(
                                              SubscriptionPlanWebservice(),
                                            ),
                                          ),
                                    ),
                                  ],
                                  child: SubscriptionPlansScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "جدد الآن",
                              style: TextStyle(
                                color: Colors.teal,
                                fontFamily: "Cairo",
                              ),
                            ),
                          ),
                        ],
                      ),
                    Image.asset("assets/images/jpg/statistics.jpg"),
                    SizedBox(height: 8.h),

                    // بطاقات الإحصائيات
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectFromDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Text(
                                fromDate == null
                                    ? "من تاريخ"
                                    : "${fromDate!.year}-${fromDate!.month}-${fromDate!.day}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: "Cairo"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectToDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Text(
                                toDate == null
                                    ? "إلى تاريخ"
                                    : "${toDate!.year}-${toDate!.month}-${toDate!.day}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: "Cairo"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (fromDate != null && toDate != null) {
                              context.read<AllstatisticsCubit>().getAllstatistics(
                                fromDate:
                                    "${fromDate!.year}-${fromDate!.month}-${fromDate!.day}",
                                toDate:
                                    "${toDate!.year}-${toDate!.month}-${toDate!.day}",
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: Icon(Icons.filter_alt, color: Colors.white),
                          label: Text(
                            "فلترة",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _StatCard(
                          title: "إجمالي الطلبات",
                          value: (stats.totalRequests ?? 0).toString(),
                          icon: Icons.task_alt,
                          color: Colors.teal,
                        ),
                        _StatCard(
                          title: "الإيرادات",
                          value: "${stats.totalRevenues ?? 0} ل.س",
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        _StatCard(
                          title: "الطلبات المكتملة",
                          value: "${stats.completedRequests ?? 0}",
                          icon: Icons.check_circle,
                          color: Colors.blue,
                        ),
                        _StatCard(
                          title: "الطلبات القادمة",
                          value: "${stats.acceptedRequests ?? 0}",
                          icon: Icons.arrow_circle_down_sharp,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // رسم بياني
                    // Text("إحصائيات الطلبات", style: textTheme),
                    // const SizedBox(height: 12),
                    // SizedBox(
                    //   height: 200,
                    //   child: LineChart(
                    //     LineChartData(
                    //       gridData: FlGridData(show: false),
                    //       borderData: FlBorderData(show: false),
                    //       titlesData: FlTitlesData(
                    //         leftTitles: AxisTitles(
                    //           sideTitles: SideTitles(showTitles: true),
                    //         ),
                    //         bottomTitles: AxisTitles(
                    //           sideTitles: SideTitles(showTitles: true),
                    //         ),
                    //       ),
                    //       lineBarsData: [
                    //         LineChartBarData(
                    //           spots: [
                    //             FlSpot(
                    //               1,
                    //               (stats.pendingRequests ?? 0).toDouble(),
                    //             ),
                    //             FlSpot(
                    //               2,
                    //               (stats.acceptedRequests ?? 0).toDouble(),
                    //             ),
                    //             FlSpot(
                    //               3,
                    //               (stats.ongoingRequests ?? 0).toDouble(),
                    //             ),
                    //             FlSpot(
                    //               4,
                    //               (stats.completedRequests ?? 0).toDouble(),
                    //             ),
                    //             FlSpot(
                    //               5,
                    //               (stats.rejectedRequests ?? 0).toDouble(),
                    //             ),
                    //           ],
                    //           isCurved: true,
                    //           color: Colors.teal,
                    //           barWidth: 3,
                    //           dotData: FlDotData(show: true),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("لا توجد بيانات متاحة"));
            }
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextStyle(fontFamily: "Cairo");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: textTheme.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
