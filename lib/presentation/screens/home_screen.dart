import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:repairo_provider/business_logic/TechRequestsCubit/tech_requests_cubit.dart';
import 'package:repairo_provider/data/repository/user_requests_repository.dart';
import 'package:repairo_provider/data/web_services/user_requests_webservices.dart';
import 'package:repairo_provider/presentation/screens/user_requests.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 170,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 70, bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.closeDrawer();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.list, color: Colors.white),
                    radius: 14,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 10,
              //     itemBuilder: (context, index) {
              //       return Text(" item[$index]");
              //     },
              //   ),
              // )
              GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.closeDrawer();

                  // Future.delayed(Duration(seconds: 1), () {
                  //   Get.toNamed('providers');
                  // });
                },
                child: Row(
                  children: [
                    Icon(Icons.person_3_outlined, size: 22),
                    SizedBox(width: 5),
                    Text(
                      "All Customers",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.closeDrawer();

                  Future.delayed(Duration(seconds: 1), () {
                    // Get.toNamed('providers');
                    Get.to(
                      () => BlocProvider(
                        create:
                            (context) => TechRequestsCubit(
                              TechRequestsRepository(
                                techRequestsWebservices:
                                    TechRequestsWebservices(),
                              ),
                            ),
                        child: TechRequests(),
                      ),
                    );
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.outbox_rounded, size: 22),
                    SizedBox(width: 5),
                    Text(
                      "My Requests",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  scaffoldKey.currentState?.closeDrawer();

                  Future.delayed(Duration(seconds: 1), () {
                    // Get.toNamed('providers');
                    // Get.to(() => BlocProvider(
                    //       create: (context) => UserRequestsCubit(
                    //           UserRequestsRepository(
                    //               userRequestsWebservices:
                    //                   UserRequestsWebservices())),
                    //       child: UserRequests(),
                    //     ));
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 22),
                    SizedBox(width: 5),
                    Text(
                      "Settings",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 4),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: Text("Home Screen Page"), centerTitle: true),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("welcome home!")],
        ),
      ),
    );
  }
}
