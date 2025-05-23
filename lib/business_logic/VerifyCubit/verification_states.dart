

import 'package:repairo_provider/data/models/user_model.dart';

abstract class VerificationStates {}

class VerificationInitial extends VerificationStates {}

class VerificationLoading extends VerificationStates {}

class VerificationSuccess extends VerificationStates {
  final User user;
  VerificationSuccess(this.user);
}

class VerificationError extends VerificationStates {
  final String message;
  VerificationError(this.message);
}

class LoginRememberMeChanged extends VerificationStates {
  final bool rememberMe;
  LoginRememberMeChanged(this.rememberMe);
}

class LoginPassHideChanged extends VerificationStates {
  final bool hide;

  LoginPassHideChanged(this.hide);
}
