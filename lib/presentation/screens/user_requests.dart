import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:repairo_provider/business_logic/TechRequestsCubit/tech_requests_cubit.dart';
import 'package:repairo_provider/business_logic/TechRequestsCubit/tech_requests_states.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/data/models/user_requests_model.dart';

class TechRequests extends StatefulWidget {
  @override
  TechRequestsState createState() => TechRequestsState();
}

class TechRequestsState extends State<TechRequests> {
  String? status;
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TechRequestsCubit>(context).getTechRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("My Requests", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [buildFilterOptions(), Expanded(child: buildBlocWidget())],
      ),
    );
  }

  Widget buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchKeyword = value.toLowerCase();
                });
              },
            ),
          ),
          SizedBox(height: 5),
          DropdownButton<String>(
            hint: Text("Status"),
            value: status,
            items:
                [
                  null,
                  'accepted',
                  'ended',
                  'canceled',
                  'pending',
                  'rejected',
                ].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status == null ? "All" : status.toString()),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                status = value;
                print(status);
              });
              context.read<TechRequestsCubit>().getTechRequests(status: status);
            },
          ),
        ],
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<TechRequestsCubit, TechRequestsStates>(
      builder: (context, state) {
        if (state is TechRequestsLoaded) {
          final requests = state.requests;

          // فلترة حسب الاسم
          final filteredrequests =
              requests.where((requsest) {
                final name = requsest.id!.toLowerCase() ?? '';
                return name.contains(searchKeyword);
              }).toList();

          if (filteredrequests.isEmpty) {
            return Center(child: Text("No requests found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredrequests.length,
            itemBuilder:
                (ctx, index) => buildRequestCard(filteredrequests[index]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }
      },
    );
  }

  Widget buildRequestCard(RTechRequestData request) {
    return GestureDetector(
      onTap: () {
        // Get.to(() => BlocProvider(
        //       create: (context) => RequestDetailsCubit(
        //           RequsetDetailsRepository(RequestDetailsWebservices())),
        //       child: RequestDetailsScreen(
        //         id: request.id!,
        //       ),
        //     ));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الطلب
            //if (request.image != null && request.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                request.service!.image.toString().replaceFirst(
                  '127.0.0.1',
                  AppConstants.baseaddress,
                ),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, size: 40),
                    ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 6),
                      Text(
                        'الخدمة: ${request.service?.name ?? request.technicianAccount?.name ?? "غير معروف"}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 6),
                      Text(
                        'المهني: ${request.technicianAccount?.name ?? "غير معروف"}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // التاريخ والوقت
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${request.scheduledDate ?? "--"} - ${request.scheduledTime ?? "--"}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        width: 65,
                        height: 20,
                        decoration: BoxDecoration(
                          color:
                              request.status == 'Accepted'
                                  ? Colors.green
                                  : request.status == "rejected"
                                  ? Colors.red
                                  : request.status == "pending"
                                  ? Colors.grey
                                  : Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text("${request.status}", style: TextStyle()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // الموقع
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          request.location ?? "الموقع غير محدد",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  // اسم الفني أو الخدمة
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
