import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_states.dart';
import 'package:repairo_provider/business_logic/PlansCubit/plans_cubit.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:repairo_provider/business_logic/TechLocationsCubit/tech_locations_cubit.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/data/models/userprofile_model.dart';
import 'package:repairo_provider/data/repository/all_locations_repository.dart';
import 'package:repairo_provider/data/repository/plans_repository.dart';
import 'package:repairo_provider/data/repository/profile_repository.dart';
import 'package:repairo_provider/data/repository/subscription_plan_repository.dart';
import 'package:repairo_provider/data/web_services/all_locations_webservice.dart';
import 'package:repairo_provider/data/web_services/plans_webservice.dart';
import 'package:repairo_provider/data/web_services/profile_webservices.dart';
import 'package:repairo_provider/data/web_services/subscription_plan_webservice.dart';
import 'package:repairo_provider/presentation/screens/edit_profile.dart';
import 'package:repairo_provider/presentation/screens/subscriptions_screen.dart';
import 'package:repairo_provider/presentation/screens/tech_locations.dart';
import 'package:repairo_provider/presentation/screens/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  late PData userdata;
  //late String? uname;
  late String? uphone;
  //late String? uaddress;
  late String? uimage;

  @override
  void initState() {
    print("iiiiiiiiiiiiii");
    BlocProvider.of<ProfileCubit>(context).getUserData('any');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildprofileWidget());
  }

  Widget buildprofileWidget() {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          print("buildddd succeeed");
          userdata = state.userdata;

          uimage = userdata.account?.image;

          print(uimage);
          return buildLoadedListWidget();
        } else {
          return showloadingindicator();
        }
      },
    );
  }

  Widget showloadingindicator() {
    return const Center(child: CircularProgressIndicator(color: Colors.teal));
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Stack(
              children: [
                Image.asset("assets/images/jpg/profile.jpg"),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Row(
                            children: [
                              Text(
                                "حسابي",
                                style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          (userdata.account?.image != null &&
                                  userdata.account!.image!.isNotEmpty)
                              ? CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                  userdata.account!.image!,
                                ),
                              )
                              : CircleAvatar(
                                radius: 35,
                                backgroundImage: AssetImage(
                                  "assets/images/jpg/default_profile.png",
                                ),
                              ),
                          SizedBox(height: 10),
                          Text(
                            userdata.account?.name ?? "verified tech",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        userdata.account?.place ?? "",
                        style: TextStyle(
                          fontFamily: "Cairo",
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          sectionTitle("عام"),
          settingsTile(
            Icons.dark_mode,
            "الوضع الليلي",
            trailing: Switch(
              activeThumbColor: Colors.teal,
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  isDarkMode = val;
                });
              },
            ),
          ),
          settingsTile(
            Icons.person,
            "الملف الشخصي",
            onTap: () {
              Get.to(
                () => EditProfileScreen(
                  phone: userdata.phone ?? "",
                  name: userdata.account?.name ?? "",
                  address: userdata.account?.place ?? "",
                  image: userdata.account?.image ?? "",
                ),
              );
            },
          ),
          settingsTile(
            Icons.language,
            "الاشتراكات",
            onTap: () {
              Get.to(
                () => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create:
                          (context) => AllplansCubit(
                            PlansRepository(plansWebservice: PlansWebservice()),
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
          ),
          settingsTile(
            Icons.location_on_outlined,
            "العناوين",
            onTap: () {
              Get.to(
                () => BlocProvider(
                  create:
                      (_) => TechLocationsCubit(
                        AllLocationsRepository(
                          allLocationsWebservice: AllLocationsWebservice(),
                        ),
                      ),
                  child: TechLocationsScreen(id: userdata.id ?? ""),
                ),
              );
            },
          ),
          settingsTile(
            Icons.favorite_border,
            "محفظتي",
            onTap: () {
              Get.to(
                () => BlocProvider(
                  create:
                      (_) =>
                          ProfileCubit(ProfileRepository(ProfileWebservices())),
                  child: WalletPage(),
                ),
              );
            },
          ),
          settingsTile(Icons.attach_money_outlined, "المدفوعات", onTap: () {}),
          sectionTitle("حول التطبيق"),
          settingsTile(Icons.privacy_tip_outlined, "سياسة الخصوصية"),
          settingsTile(Icons.money, "طرق الدفع"),
          settingsTile(Icons.article_outlined, "الشروط والأحكام"),
          settingsTile(Icons.help_outline, "فريق الدعم"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () async {
                Get.defaultDialog(
                  title: "...جاري التحميل ",
                  titleStyle: TextStyle(fontFamily: "Cairo"),
                  content: const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.teal),
                      SizedBox(height: 10),
                      Text(
                        "الرجاء الانتظار.",
                        style: TextStyle(fontFamily: "Cairo"),
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                );
                final prefs = await SharedPreferences.getInstance();
                final url = Uri.parse(
                  '${AppConstants.baseUrl}/technician/authentication/logout',
                );
                var token = prefs.getString('auth_token');
                final response = await http.post(
                  url,
                  headers: {
                    'Authorization': 'Bearer $token',
                    'Content-Type': 'application/json',
                  },
                );

                if (response.statusCode == 200) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('is_loggedin');
                  Get.back();
                  Get.toNamed('login');
                  final data = jsonDecode(response.body);
                  print(data.toString());
                  return data;
                } else {
                  print('Failed to get user info: ${response.statusCode}');
                  throw Exception('logout failed');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "تسجيل الخروج",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Cairo",
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text("version 1.45(3)", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        color: Colors.white30,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: "Cairo",
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget settingsTile(
    IconData icon,
    String title, {
    Widget? trailing,
    void Function()? onTap,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: TextStyle(fontFamily: "Cairo")),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
