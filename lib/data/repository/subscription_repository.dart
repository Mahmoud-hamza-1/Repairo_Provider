import 'package:repairo_provider/data/web_services/subscription_api_service.dart';

import '../models/subscription_plan.dart';

class SubscriptionRepository {
  final SubscriptionApiService _apiService;

  SubscriptionRepository({SubscriptionApiService? apiService})
      : _apiService = apiService ?? SubscriptionApiService();

  // جلب الباقات
  Future<List<SubscriptionPlan>> fetchSubscriptionPlans() {
    return _apiService.getSubscriptionPlans();
  }

  // إنشاء اشتراك
  Future<bool> subscribeToPlan({
    required String planId,
    required String paymentMethod,
  }) {
    return _apiService.createSubscription(planId: planId, paymentMethod: paymentMethod);
  }
}