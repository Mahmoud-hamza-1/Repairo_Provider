import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/data/repository/subscription_repository.dart';

import 'subscribe_event.dart';
import 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  final SubscriptionRepository _repository;

  SubscribeBloc(this._repository) : super(SubscribeInitial()) {
    on<SubscribeRequested>((event, emit) async {
      emit(SubscribeInProgress());
      try {
        await _repository.subscribeToPlan(
          planId: event.planId,
          paymentMethod: event.paymentMethod,
        );
        emit(SubscribeSuccess());
      } catch (e) {
        emit(SubscribeFailure(e.toString()));
      }
    });
  }
}