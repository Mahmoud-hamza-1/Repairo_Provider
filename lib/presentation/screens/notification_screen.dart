import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/NotificationCubit/notification_cubit.dart';
import 'package:repairo_provider/business_logic/NotificationCubit/notification_states.dart';
import 'package:repairo_provider/presentation/widgets/notifiation_widget.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الإشعارات")),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: NotificationWidget(
                    item: item,
                    onAccept: () {
                      // تنفيذ قبول
                      print("قبول ${item.id}");
                    },
                    onReject: () {
                      // تنفيذ رفض
                      print("رفض ${item.id}");
                    },
                    onDetails: () {
                      // الانتقال إلى التفاصيل
                      print("تفاصيل ${item.id}");
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("لا توجد إشعارات حالياً."));
          }
        },
      ),
    );
  }
}
