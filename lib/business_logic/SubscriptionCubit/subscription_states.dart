abstract class SubscriptionPlanStates {}

class SubscriptionPlanInitial extends SubscriptionPlanStates {}

class SubscriptionPlanLoading extends SubscriptionPlanStates {}

class SubscriptionPlanSuccess extends SubscriptionPlanStates {
  final String message;
  SubscriptionPlanSuccess(this.message);
}

class SubscriptionPlanError extends SubscriptionPlanStates {
  final String message;
  SubscriptionPlanError(this.message);
}

class SubscriptionPlanInsufficientBalance extends SubscriptionPlanStates {}
