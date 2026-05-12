import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/ChatCubit/chat_cubit.dart';
import 'package:repairo_provider/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:repairo_provider/business_logic/RequestDetailsCubit/request_details_cubit.dart';
import 'package:repairo_provider/business_logic/RequestDetailsCubit/request_details_states.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_cubit.dart';
import 'package:repairo_provider/business_logic/UpdateRequestCubit/update_request_states.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/data/repository/chat_repository.dart';
import 'package:repairo_provider/data/repository/invoice_repository.dart';
import 'package:repairo_provider/data/web_services/chat_webservice.dart';
import 'package:repairo_provider/data/web_services/invoice_web_services.dart';
import 'package:repairo_provider/presentation/screens/chatting_screen%20copy.dart';
import 'package:repairo_provider/presentation/screens/chatting_screen.dart';
import 'package:repairo_provider/presentation/screens/invoice_details.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String id;
  const RequestDetailsScreen({super.key, required this.id});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    context.read<RequestDetailsCubit>().getRequestDetails(widget.id);
    super.initState();
  }

  // يستقبل الـ bookingHistory كـ Map<String, dynamic> (أو Map<String, String>)
  Widget _buildBookingHistoryList(Map<String, dynamic>? bookingHistory) {
    if (bookingHistory == null || bookingHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "لا يوجد سجل للحجوزات",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // نجهز لستة من العناصر مع محاولة تحويل التاريخ إلى DateTime
    final entries =
        bookingHistory.entries.map((e) {
          final key = e.key.toString();
          final raw = e.value?.toString() ?? '';

          DateTime? dt;
          try {
            // بعض APIs يرجّع "2025-08-30 00:57:25" -> نحول المسافة لـ T حتى يقبل DateTime.parse
            final iso = raw.replaceFirst(' ', 'T');
            dt = DateTime.parse(iso);
          } catch (_) {
            dt = null;
          }

          return {'status': key, 'raw': raw, 'dt': dt};
        }).toList();

    // نرتب حسب التاريخ إذا متوفر (من الأقدم للأحدث)
    entries.sort((a, b) {
      final da = a['dt'] as DateTime?;
      final db = b['dt'] as DateTime?;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });

    // نعرض داخل ListView مقيد الارتفاع حتى الـ BottomSheet يظل قابلاً للتمرير
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = entries[index];
          final status = (item['status'] as String);
          final raw = (item['raw'] as String);
          final dt = item['dt'] as DateTime?;

          // عرض تاريخ ووقت بصيغة بسيطة (fallback إلى النص الخام إن لم نستطع التحويل)
          final displayDate =
              dt != null
                  ? "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}"
                  : (raw.split(' ').isNotEmpty ? raw.split(' ').first : raw);
          final displayTime =
              dt != null
                  ? "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}"
                  : (raw.split(' ').length > 1
                      ? raw.split(' ').sublist(1).join(' ')
                      : '');

          final color = _statusColor(status);
          final title = _statusTitle(status);
          final desc = _statusDescription(status, raw);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العمود الصغير: الوقت - التاريخ - خط عمودي
              Column(
                children: [
                  Text(
                    displayTime,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(displayDate),
                  const SizedBox(height: 6),
                  // خط عمودي يصل للأحداث التالية (لا نطوّله عند آخر عنصر)
                  if (index != entries.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: color.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    )
                  else
                    const SizedBox(height: 4),
                ],
              ),

              const SizedBox(width: 12),

              // الدائرة الملونة
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),

              const SizedBox(width: 12),

              // العنوان والوصف
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(desc),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ترجمة اسم الحالة إلى عنوان عرضي (تقدر تضيف حالات أخرى هنا)
  String _statusTitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'مُعلّق';
      case 'accepted':
        return 'مقبول';
      case 'assigned':
        return 'تم التعيين';
      case 'ongoing':
        return 'جاري التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'rejected':
        return 'مرفوض';
      case 'canceled':
        return 'ملغي';
      default:
        // إذا الحالة غير معروفة نعرضها كما هي (بدون تعديل)
        return status;
    }
  }

  // لون لكل حالة (تقدر تغيّر الألوان هنا)
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.teal;
      case 'assigned':
        return Colors.blue;
      case 'ongoing':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'canceled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // وصف مبسّط لكل حالة؛ إذا كنت عندك وصفات مفصّلة في الـ API استبدل raw بها
  String _statusDescription(String status, String rawDate) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'تم إنشاء الطلب';
      case 'accepted':
        return 'تم قبول الطلب';
      case 'assigned':
        return 'تم تعيين الفني للطلب';
      case 'ongoing':
        return 'تم بدء التنفيذ';
      case 'completed':
        return 'انتهى التنفيذ';
      case 'rejected':
        return 'تم رفض الطلب';
      case 'canceled':
        return 'تم إلغاء الطلب';
      default:
        return rawDate; // fallback: نعرض التاريخ/البيانات الخام لو ما في وصف
    }
  }

  Color _getColorFromString(String color) {
    switch (color) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // 🔹 مهم للـ RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل الطلب',
            style: TextStyle(fontFamily: "Cairo"),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     tooltip: 'الدردشة',
          //     onPressed: () {
          //       Get.to(ChattingScreen());
          //     },
          //     icon: const Icon(Icons.chat_rounded, color: Colors.white),
          //   ),
          // ],
        ),

        body: BlocListener<UpdateRequestCubit, UpdateRequestStates>(
          listener: (context, state) {
            if (state is UpdateRequestLoading) {
              if (Get.isDialogOpen != true) {
                Get.defaultDialog(
                  title: "جاري التحميل...",
                  content: const Column(
                    children: [
                      CircularProgressIndicator(color: Colors.teal),
                      SizedBox(height: 10),
                      Text("الرجاء الانتظار"),
                    ],
                  ),
                  barrierDismissible: false,
                );
              }
            } else if (state is UpdateRequestSuccess) {
              if (Get.isDialogOpen == true) Get.back();

              Get.snackbar(
                "تم بنجاح ✅",
                "تم تحديث حالة الطلب",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
              context.read<RequestDetailsCubit>().getRequestDetails(widget.id);
            } else if (state is UpdateRequestError) {
              if (Get.isDialogOpen == true) Get.back();
              Get.snackbar(
                "خطأ",
                state.message,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            } else {
              if (Get.isDialogOpen == true) Get.back();
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

                Widget buildUserCard(String? image, String? name, String role) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            (image != null && image.isNotEmpty)
                                ? NetworkImage(
                                  image.replaceFirst(
                                    "127.0.0.1",
                                    AppConstants.baseaddress,
                                  ),
                                )
                                : null,
                        backgroundColor: Colors.teal.shade100,
                        child:
                            (image == null || image.isEmpty)
                                ? const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name ?? "-",
                        style: const TextStyle(
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        role,
                        style: const TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }

                Widget buildInfoTile(
                  String title,
                  String value,
                  IconData icon,
                ) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(icon, color: Colors.teal),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 🔹 قسم العميل والمهني
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildUserCard(
                                request.user?.image,
                                request.user?.name,
                                "العميل",
                              ),
                              const Icon(
                                Icons.swap_horiz,
                                color: Colors.teal,
                                size: 32,
                              ),
                              buildUserCard(
                                request.technicianAccount?.image,
                                request.technicianAccount?.name,
                                "المهني",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Visibility(
                        visible: request.status == "accepted",
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => BlocProvider(
                                create:
                                    (context) => ChatCubit(
                                      ChatRepository(ChatWebservice()),
                                    ),
                                child: ChattingScreen(
                                  tech_id: request.technicianAccount!.id!,
                                  requestId: request.id!,
                                  currentUser: "technician",
                                  username: request.user!.name!,
                                  userimage: request.user!.image!,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 1.5,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Icon(Icons.chat, color: Colors.teal),
                              title: Text(
                                "الذهاب إلى المحادثة",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                "إبدأ محادثتك مع المهني",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ), // هون الإضافة
                            ),
                          ),
                        ),
                      ),

                      // 🔹 تفاصيل الطلب
                      buildInfoTile(
                        " موقع التنفيذ",
                        request.location ?? "-",
                        Icons.location_on,
                      ),
                      buildInfoTile(
                        "التاريخ",
                        request.scheduledDate ?? "-",
                        Icons.date_range,
                      ),
                      buildInfoTile(
                        "الوقت",
                        request.scheduledTime ?? "-",
                        Icons.access_time,
                      ),
                      buildInfoTile(
                        " حالة الطلب",
                        request.status == "accepted"
                            ? "مقبول"
                            : request.status == "rejected"
                            ? "مرفوض"
                            : request.status == "ongoing"
                            ? "جاري"
                            : request.status == "pending"
                            ? "معلّق"
                            : request.status == "cancelled"
                            ? "ملغي"
                            : "${request.status}",

                        Icons.info,
                      ),
                      buildInfoTile(
                        "التفاصيل",
                        request.details ?? "-",
                        Icons.description,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // لتوفير مساحة أكبر إذا كان المحتوى طويلاً
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // رأس الـ BottomSheet
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "سجل عملية طلب الخدمة",
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          // Text(
                                          //   "ID : ${request.id}",
                                          //   style: TextStyle(
                                          //     fontFamily: 'Cairo',
                                          //     fontWeight: FontWeight.bold,
                                          //     fontSize: 18,
                                          //     color: Colors.deepPurple,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      // هنا تضاف قائمة تاريخ الطلبات
                                      // استخدمنا List of Maps لتسهيل عرض البيانات
                                      _buildBookingHistoryList(
                                        request.bookingHistory!,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 1.5,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(Icons.history, color: Colors.teal),
                            title: Text(
                              "تاريخ الطلب",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              "رؤية حالات طلب الخدمة",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ), // هون الإضافة
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 الأزرار حسب الحالة
                      if (request.status == "pending")
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<UpdateRequestCubit>()
                                      .updaterequest(
                                        requestId: widget.id,
                                        status: "accepted",
                                      );
                                },
                                child: const Text(
                                  "قبول",
                                  style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<UpdateRequestCubit>()
                                      .updaterequest(
                                        requestId: widget.id,
                                        status: "rejected",
                                      );
                                },
                                child: const Text(
                                  "رفض",
                                  style: TextStyle(
                                    fontFamily: "Cairo",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      if (request.status == "accepted") ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<UpdateRequestCubit>().updaterequest(
                              requestId: widget.id,
                              status: "ongoing",
                            );
                          },
                          child: const Text(
                            "بدء التنفيذ",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // OutlinedButton(
                        //   style: OutlinedButton.styleFrom(
                        //     side: const BorderSide(color: Colors.red),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     context.read<UpdateRequestCubit>().updaterequest(
                        //       requestId: widget.id,
                        //       status: "cancelled",
                        //     );
                        //   },
                        //   child: const Text(
                        //     "إلغاء الطلب",
                        //     style: TextStyle(
                        //       fontFamily: "Cairo",
                        //       color: Colors.red,
                        //     ),
                        //   ),
                        // ),
                      ],

                      if (request.status == "ongoing")
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<UpdateRequestCubit>().updaterequest(
                              requestId: widget.id,
                              status: "ended",
                            );
                          },
                          child: const Text(
                            "إنهاء الطلب",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                            ),
                          ),
                        ),

                      if (request.status == "ended")
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => BlocProvider(
                                create:
                                    (context) => InvoiceCubit(
                                      InvoiceRepository(InvoiceWebServices()),
                                    ),
                                child: InvoiceDetailsPage(id: widget.id),
                              ),
                            );
                          },
                          child: const Text(
                            "عرض الفاتورة",
                            style: TextStyle(
                              fontFamily: "Cairo",
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return const Center(child: Text("حدث خطأ"));
            },
          ),
        ),
      ),
    );
  }
}
