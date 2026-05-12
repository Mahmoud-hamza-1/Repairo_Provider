import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/RequestDetailsCubit/request_details_cubit.dart';
import 'package:repairo_provider/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_cubit.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_states.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';

class NewRequestScreen extends StatefulWidget {
  final String requestId;
  const NewRequestScreen({super.key, required this.requestId});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestDetailsCubit>().getRequestDetails(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "طلب خدمة جديد",
            style: TextStyle(fontFamily: "Cairo"),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: BlocListener<UpdateRequestCubit, UpdateRequestStates>(
          listener: (context, state) {
            if (state is UpdateRequestLoading) {
              if (Get.isDialogOpen != true) {
                Get.defaultDialog(
                  title: "جاري التحميل...",
                  content: const CircularProgressIndicator(color: Colors.teal),
                  barrierDismissible: false,
                );
              }
            } else if (state is UpdateRequestSuccess) {
              if (Get.isDialogOpen == true) Get.back();
              Get.snackbar(
                "تم بنجاح ✅",
                "تم قبول الطلب",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
              Get.back(); // رجوع لواجهة رئيسية مثلاً بعد القبول
            } else if (state is UpdateRequestError) {
              if (Get.isDialogOpen == true) Get.back();
              Get.snackbar(
                "خطأ",
                state.message,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          },
          child: BlocBuilder<RequestDetailsCubit, RequestDetailsStates>(
            builder: (context, state) {
              if (state is RequestDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                );
              }

              if (state is RequestDetailsSuccess) {
                final request = state.requestdata;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                request.user?.image != null
                                    ? NetworkImage(
                                      request.user!.image!.replaceFirst(
                                        "127.0.0.1",
                                        AppConstants.baseaddress,
                                      ),
                                    )
                                    : null,
                            child:
                                request.user?.image == null
                                    ? const Icon(Icons.person)
                                    : null,
                          ),
                          title: Text(
                            request.user?.name ?? "-",
                            style: const TextStyle(fontFamily: "Cairo"),
                          ),
                          subtitle: Text("العميل"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "📍 الموقع: ${request.location ?? '-'}",
                        style: const TextStyle(fontFamily: "Cairo"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "📅 التاريخ: ${request.scheduledDate ?? '-'}",
                        style: const TextStyle(fontFamily: "Cairo"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "⏰ الوقت: ${request.scheduledTime ?? '-'}",
                        style: const TextStyle(fontFamily: "Cairo"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "📝 تفاصيل: ${request.details ?? '-'}",
                        style: const TextStyle(fontFamily: "Cairo"),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<UpdateRequestCubit>().updaterequest(
                              requestId: widget.requestId,
                              status: "accepted",
                            );
                          },
                          child: const Text(
                            "قبول الطلب",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: Text("حدث خطأ في تحميل البيانات"));
            },
          ),
        ),
      ),
    );
  }
}
