import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_states.dart';
import 'package:repairo_provider/data/repository/step_three_repository.dart';

class StepThreeCubit extends Cubit<StepThreeStates> {
  final StepThreeRepository stepThreeRepository;
  StepThreeCubit(this.stepThreeRepository) : super(StepThreeInitial());
  void stepthree(File image) async {
    emit(StepThreeLoading());
    try {
      final step3 = await stepThreeRepository.stepthree(image);
      emit(StepThreeSuccess());
    } catch (e) {
      emit(StepThreeError(e.toString()));
    }
  }
}
