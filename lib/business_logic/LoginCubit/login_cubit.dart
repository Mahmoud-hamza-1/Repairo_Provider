import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/LoginCubit/login_states.dart';
import 'package:repairo_provider/data/repository/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  bool rememberMe = false;
  bool hide = false;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  LoginCubit(this.authRepository) : super(LoginInitial());

  void toggleRememberMe(bool value) {
    rememberMe = value;
    emit(LoginRememberMeChanged(rememberMe));
  }

  void togglePassHide() {
    hide = !hide;
    emit(LoginPassHideChanged(hide));
  }

  void login(String phone) async {
    print("object--------1");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phoneController.text);

    print("object------2");
    emit(LoginLoading());
    try {
      print("object--------3");
      final userlog = await authRepository.login(phone);
      emit(LoginSuccess(userlog));
      print("object-------4");
      Get.back();
      //await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      print("object----------5");
      emit(LoginError(e.toString()));
    }
  }
}
