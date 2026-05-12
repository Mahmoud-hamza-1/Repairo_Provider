import 'package:repairo_provider/data/web_services/subscription_plan_webservice.dart';

class SubscriptionPlanRepository {
  final SubscriptionPlanWebservice subscriptionPlanWebservice;
  SubscriptionPlanRepository(this.subscriptionPlanWebservice);

  Future<Map<String, dynamic>> subscribe({
    required String planid,
    required String paymentmethod,
  }) async {
    final data = await subscriptionPlanWebservice.subscribeplan(
      paymentmethod: paymentmethod,
      planid: planid,
    );
    print(data);
    return data;
  }
}
