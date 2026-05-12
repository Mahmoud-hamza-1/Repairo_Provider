import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_states.dart';
import 'package:repairo_provider/data/repository/subscription_plan_repository.dart';

class SubscriptionCubit extends Cubit<SubscriptionPlanStates> {
  final SubscriptionPlanRepository subscriptionPlanRepository;

  SubscriptionCubit(this.subscriptionPlanRepository)
    : super(SubscriptionPlanInitial());

  void subscribeplan({
    required String planid,
    required String paymenttype,
  }) async {
    emit(SubscriptionPlanLoading());
    try {
      final result = await subscriptionPlanRepository.subscribe(
        planid: planid,
        paymentmethod: paymenttype,
      );

      print("4444444444 - result: $result");

      emit(SubscriptionPlanSuccess(result['message']));
    } catch (e) {
      emit(SubscriptionPlanError(e.toString()));
    }
  }
}
