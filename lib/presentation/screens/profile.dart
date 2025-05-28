import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_states.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/data/models/userprofile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  late PData userdata;
  late String? uname;
  late String? uaddress;
  late String? uimage;

  @override
  void initState() {
    BlocProvider.of<ProfileCubit>(context).getUserData('any');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(
              //   () => EditProfileScreen(
              //     name: uname ?? "",
              //     address: uaddress ?? "",
              //     image: uimage ?? "",
              //   ),
              // );

              // Get.toNamed('editprofile');
            },
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
        backgroundColor: const Color(0xFF6F4EC9),
        elevation: 0,
        //leading: Icon(Icons.arrow_back_ios, color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: buildprofileWidget(),
    );
  }

  Widget buildprofileWidget() {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        if (state is ProfileSuccess) {
          print("buildddd succeeed");
          userdata = (state).userdata;
          uname = userdata.name;
          uaddress = userdata.address;
          uimage = userdata.image!.replaceFirst(
            '127.0.0.1',
            AppConstants.baseaddress,
          );
          print(uname);
          print(uaddress);
          print(uimage);
          return buildLoadedListWidget();
        } else {
          return showloadingindicator();
        }
      },
    );
  }

  Widget showloadingindicator() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.blueAccent),
    );
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            //color: Color(0xFF6F4EC9),
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      userdata.image!.isNotEmpty
                          ? NetworkImage(
                            userdata.image!.replaceFirst(
                              '127.0.0.1',
                              AppConstants.baseaddress,
                            ),
                          )
                          : const AssetImage('assets/images/jpg/hamdan.jpg'),
                ),
                const SizedBox(height: 10),
                // userdata.name!.contains('null')
                uname.isNull
                    ? const Text(
                      "User Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : Text(
                      "${userdata.name}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                uaddress.isNull
                    ? const Text(
                      "user address",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )
                    : Text(
                      "${userdata.address}",
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                Text(
                  "${userdata.phone}",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
          ),
          sectionTitle("GENERAL"),
          settingsTile(
            Icons.dark_mode,
            "Dark Mode",
            trailing: Switch(
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  isDarkMode = val;
                });
              },
            ),
          ),
          settingsTile(Icons.lock, "Change Password"),
          settingsTile(Icons.language, "App Language"),
          settingsTile(Icons.favorite_border, "Favourite Service"),
          settingsTile(Icons.star_border, "Rate Us"),
          sectionTitle("ABOUT APP"),
          settingsTile(Icons.privacy_tip_outlined, "Privacy Policy"),
          settingsTile(Icons.article_outlined, "Terms & Conditions"),
          settingsTile(Icons.help_outline, "Help Support"),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () async {
                Get.defaultDialog(
                  title: "Loading...",
                  content: const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.blueAccent),
                      SizedBox(height: 10),
                      Text("Please wait..."),
                    ],
                  ),
                  barrierDismissible: false,
                );
                final prefs = await SharedPreferences.getInstance();
                final url = Uri.parse(
                  '${AppConstants.baseUrl}/user/authentication/logout',
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
              child: const Text(
                "Log out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F4EC9),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

Widget sectionTitle(String title) {
  return Container(
    width: double.infinity,
    color: Colors.grey.shade100,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget settingsTile(IconData icon, String title, {Widget? trailing}) {
  return ListTile(
    leading: Icon(icon, color: Colors.black),
    title: Text(title),
    trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
  );
}
