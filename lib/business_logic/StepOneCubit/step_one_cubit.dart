import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_states.dart';
import 'package:repairo_provider/data/repository/step_one_repository.dart';

class StepOneCubit extends Cubit<StepOneStates> {
  final StepOneRepository stepOneRepository;
  StepOneCubit(this.stepOneRepository) : super(StepOneInitial());
  void stepone(String name, File image, String address) async {
    emit(StepOneLoading());
    try {
      final step1 = await stepOneRepository.stepone(name, image, address);
      emit(StepOneSuccess());
    } catch (e) {
      emit(StepOneError(e.toString()));
    }
  }
}
