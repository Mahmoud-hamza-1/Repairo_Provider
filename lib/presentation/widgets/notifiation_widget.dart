import 'package:flutter/material.dart';
import 'package:repairo_provider/data/models/notifiation_model.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onDetails;

  const NotificationWidget({
    Key? key,
    required this.item,
    this.onAccept,
    this.onReject,
    this.onDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 4),
            Text(item.body),
            SizedBox(height: 6),
            Text(
              _formatDateTime(item.dateTime),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (item.type == NotificationType.interactive)
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(onPressed: onAccept, child: Text("قبول")),
                  TextButton(onPressed: onReject, child: Text("رفض")),
                  TextButton(onPressed: onDetails, child: Text("تفاصيل")),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.year}/${dt.month}/${dt.day} - ${dt.hour}:${dt.minute}";
  }
}
