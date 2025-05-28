import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_states.dart';
import 'package:repairo_provider/data/models/step_two_request_model.dart';
import 'package:repairo_provider/data/repository/step_two_repository.dart';

class StepTwoCubit extends Cubit<StepTwoStates> {
  final StepTwoRepository stepTwoRepository;
  StepTwoCubit(this.stepTwoRepository) : super(StepTwoInitial());
  void steptwo(ServicesRequestBody body) async {
    emit(StepTwoLoading());
    try {
      final step2 = await stepTwoRepository.steptwo(body);
      emit(StepTwoSuccess());
    } catch (e) {
      emit(StepTwoError(e.toString()));
    }
  }
}
