abstract class SubscribeState {}

class SubscribeInitial extends SubscribeState {}

class SubscribeInProgress extends SubscribeState {}

class SubscribeSuccess extends SubscribeState {}

class SubscribeFailure extends SubscribeState {
  final String message;
  SubscribeFailure(this.message);
}