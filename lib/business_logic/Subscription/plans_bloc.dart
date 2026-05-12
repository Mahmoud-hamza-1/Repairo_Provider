import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/data/repository/subscription_repository.dart';
import 'plans_event.dart';
import 'plans_state.dart';

class PlansBloc extends Bloc<PlansEvent, PlansState> {
  final SubscriptionRepository _repository;

  PlansBloc(this._repository) : super(PlansInitial()) {
    on<FetchPlansEvent>((event, emit) async {
      emit(PlansLoading());
      try {
        final plans = await _repository.fetchSubscriptionPlans();
        emit(PlansLoaded(plans));
      } catch (e) {
        emit(PlansError(e.toString()));
      }
    });
  }
}