import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/VerifyCubit/verification_states.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:repairo_provider/data/repository/verification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationCubit extends Cubit<VerificationStates> {
  final VerificationRepository verificationRepository;

  VerificationCubit(this.verificationRepository) : super(VerificationInitial());

  void onSubmit() {}
  void DidnotgetCode() {}

  void verify(String phone, String code) async {
    emit(VerificationLoading());

    try {
      var user = await verificationRepository.verifyNumber(phone, code);

      emit(VerificationSuccess(user));
      Get.back();
    } catch (e) {
      emit(VerificationError(e.toString()));
    }
  }
}
