import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/VerifyCubit/verification_states.dart';
import 'package:repairo_provider/data/repository/verification_repository.dart';

class VerificationCubit extends Cubit<VerificationStates> {
  final VerificationRepository verificationRepository;

  VerificationCubit(this.verificationRepository) : super(VerificationInitial());

  void onSubmit() {
    // hide = !hide;
    // emit(LoginPassHideChanged(hide));
  }
  void DidnotgetCode() {
    // hide = !hide;
    // emit(LoginPassHideChanged(hide));
  }

  void verify(String phone, String code) async {
    print(" ver ---1");

    emit(VerificationLoading());
    print("ver ---2");

    try {
      print("ver ---3");

      var user = await verificationRepository.verifyNumber(phone, code);
      print("ver ---4");

      emit(VerificationSuccess(user));
      Get.back();
    } catch (e) {
      print("ver ---5");

      emit(VerificationError(e.toString()));
    }
  }
}
