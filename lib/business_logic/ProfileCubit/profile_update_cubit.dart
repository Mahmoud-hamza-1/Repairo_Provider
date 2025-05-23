import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/data/repository/profile_repository2.dart';
import '../../data/models/profile_step1_request.dart';
import '../../data/models/profile_step2_request.dart';
import '../../data/models/profile_step3_request.dart';
import '../../data/repository/profile_repository1.dart';
import 'profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final ProfileRepository repository;

  ProfileUpdateCubit(this.repository) : super(ProfileInitial());

  // Future<void> submitStep1(Step1Request request) async {
  //   emit(ProfileLoading());
  //   try {
  //     await repository.updateStep1(request);
  //     emit(ProfileStepSuccess());
  //   } catch (e) {
  //     emit(ProfileError(e.toString()));
  //   }
  // }

  Future<void> submitStep1({
    required String name,
    required String address,
    required image,
  }) async {
    emit(ProfileLoading());
    try {
      print('Step1--- 3');
      // final request = Step1Request(name: name, place: address, image: image);
      await repository.updateStep1(name, address, image);
      print('Step1--- 4');
      emit(ProfileStepSuccess());
    } catch (e) {
      print('Step1--- 5');
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> submitStep2(Step2Request request) async {
    emit(ProfileLoading());
    try {
      await repository.updateStep2(request);
      emit(ProfileStepSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> submitStep3(Step3Request request) async {
    emit(ProfileLoading());
    try {
      await repository.updateStep3(request);
      emit(ProfileStepSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> loadAccountStatus() async {
    emit(ProfileLoading());
    try {
      final status = await repository.getAccountStatus();
      emit(AccountStatusLoaded(status));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
