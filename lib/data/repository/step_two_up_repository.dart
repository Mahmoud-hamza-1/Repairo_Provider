

import 'package:repairo_provider/data/web_services/step_two_up_webservices.dart';

class StepTwoRepository {
  final StepTwoWebservices stepTwoWebservices;

  StepTwoRepository(this.stepTwoWebservices);

  // دالة تستدعي خدمة الويب وتمرر البيانات
  Future<void> submitStepTwo(Map<String, dynamic> data) async {
    // يمكنك إضافة منطق هنا قبل إرسال البيانات إذا لزم الأمر
    // مثل التحقق من صحة البيانات أو معالجتها
    await stepTwoWebservices.submitStepTwoData(data);
  }
}