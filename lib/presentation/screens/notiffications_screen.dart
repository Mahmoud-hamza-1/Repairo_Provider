import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/business_logic/NotifficationsCubit/notiffications_cubit.dart';
import 'package:repairo_provider/business_logic/NotifficationsCubit/notiffications_states.dart';
import 'package:repairo_provider/business_logic/RequestDetailsCubit/request_details_cubit.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_cubit.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/data/repository/requset_details_repository.dart';
import 'package:repairo_provider/data/repository/update_request_repository.dart';
import 'package:repairo_provider/data/web_services/request_details_webservices.dart';
import 'package:repairo_provider/data/web_services/update_request_webservice.dart';
import 'package:repairo_provider/presentation/screens/request_from_user.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotifficationsCubit>().getNotiffications();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الإشعارات"),
          backgroundColor: Colors.teal,
          actions: [
            BlocBuilder<NotifficationsCubit, NotifficationsStates>(
              builder: (context, state) {
                if (state is NotifficationsLoaded) {
                  return IconButton(
                    onPressed: () {
                      context
                          .read<NotifficationsCubit>()
                          .readAllNotiffications();
                    },
                    icon: Icon(
                      Icons.chrome_reader_mode_rounded,
                      color: Colors.white,
                    ),
                  );
                }
                return IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chrome_reader_mode_rounded,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotifficationsCubit, NotifficationsStates>(
          builder: (context, state) {
            if (state is NotifficationsLoaded) {
              if (state.notiffications.isEmpty) {
                return Center(child: Text("لا توجد إشعارات"));
              }
              return ListView.builder(
                itemCount: state.notiffications.length,
                itemBuilder: (context, index) {
                  final n = state.notiffications[index];
                  return GestureDetector(
                    onTap: () {
                      n.data != null
                          ? () {}
                          : Get.to(
                            () => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create:
                                      (context) => UpdateRequestCubit(
                                        UpdateRequestRepository(
                                          UpdateRequestWebservice(),
                                        ),
                                      ),
                                ),
                              ],
                              child: NewRequestScreen(
                                requestId: n.data!.serviceRequestId!,
                              ),
                            ),
                          );
                    },
                    child: ListTile(
                      trailing: CircleAvatar(
                        backgroundColor: Colors.teal.shade200,
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            Get.defaultDialog(
                              title: "...جاري الحذف ",
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
                              '${AppConstants.baseUrl}/technician/notification/${n.id}',
                            );
                            var token = prefs.getString('auth_token');
                            final response = await http.delete(
                              url,
                              headers: {
                                'Authorization': 'Bearer $token',
                                'Content-Type': 'application/json',
                              },
                            );

                            if (response.statusCode == 200) {
                              Get.back();
                              Get.defaultDialog(
                                title: '',
                                titlePadding: EdgeInsets.zero,
                                content: Column(
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Image.asset(
                                        "assets/images/png/delete.png",
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "تم حذف الإشعار بنجاح",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                confirm: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                    vertical: 12,
                                  ),
                                  child: CustomElevatedButton(
                                    text: 'موافق',
                                    onpressed:
                                        () => Get.offAllNamed("mainscreen"),
                                  ),
                                ),
                                barrierDismissible: false,
                              );
                            } else {
                              Get.back();
                              Get.defaultDialog(
                                title: '',
                                titlePadding: EdgeInsets.zero,
                                content: Column(
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Image.asset(
                                        "assets/images/png/deleteerror.png",
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "عذراً, لم يتم حذف الإشعار \n  حصلت مشكلة",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                confirm: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 60,
                                    vertical: 12,
                                  ),
                                  child: CustomElevatedButton(
                                    text: 'موافق',
                                    onpressed: () {
                                      Get.back();
                                    },
                                  ),
                                ),
                                barrierDismissible: false,
                              );

                              print(
                                'Failed to get user info: ${response.statusCode}',
                              );
                              throw Exception('logout failed');
                            }
                          },
                        ),
                      ),
                      leading: Icon(
                        n.readAt != null
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread,
                        color: n.readAt != null ? Colors.teal : Colors.grey,
                      ),
                      title: Text(
                        n.title!,
                        style: TextStyle(
                          fontWeight:
                              n.readAt != null
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(n.body!),
                      onTap: () {
                        Get.to(
                          () => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (context) => UpdateRequestCubit(
                                      UpdateRequestRepository(
                                        UpdateRequestWebservice(),
                                      ),
                                    ),
                              ),
                              BlocProvider(
                                create:
                                    (context) => RequestDetailsCubit(
                                      RequsetDetailsRepository(
                                        RequestDetailsWebservices(),
                                      ),
                                    ),
                              ),
                            ],
                            child: NewRequestScreen(
                              requestId: n.data!.serviceRequestId!,
                            ),
                          ),
                        );

                        // context.read<NotifficationsCubit>().readNotiffication(
                        //   notiffication_id: "${n.id}",
                        // );
                      },
                    ),
                  );
                },
              );
            } else if (state is NotifficationsLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            } else {
              return Center(
                child: Text(
                  "حدث خطأ ما ",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
