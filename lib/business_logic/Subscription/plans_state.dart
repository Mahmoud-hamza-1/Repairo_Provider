
import 'package:repairo_provider/data/models/subscription_plan.dart';

abstract class PlansState {}

class PlansInitial extends PlansState {}

class PlansLoading extends PlansState {}

class PlansLoaded extends PlansState {
  final List<SubscriptionPlan> plans;
  PlansLoaded(this.plans);
}

class PlansError extends PlansState {
  final String message;
  PlansError(this.message);
}