abstract class SubscribeEvent {}

class SubscribeRequested extends SubscribeEvent {
  final String planId;
  final String paymentMethod;
  SubscribeRequested({required this.planId, required this.paymentMethod});
}