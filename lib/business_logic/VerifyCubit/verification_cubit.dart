import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/VerifyCubit/verification_states.dart';
import 'package:repairo_provider/data/repository/verification_repository.dart';

class VerificationCubit extends Cubit<VerificationStates> {
  final VerificationRepository verificationRepository;

  VerificationCubit(this.verificationRepository) : super(VerificationInitial());

  void onSubmit() {}
  void DidnotgetCode() {}

  void verify(String phone, String code, String fcm) async {
    emit(VerificationLoading());

    try {
      var user = await verificationRepository.verifyNumber(phone, code, fcm);

      emit(VerificationSuccess(user));
      Get.back();
    } catch (e) {
      emit(VerificationError(e.toString()));
    }
  }
}
