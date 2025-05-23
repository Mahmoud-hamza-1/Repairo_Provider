import '../../data/models/userlog_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserLog userlog;
  LoginSuccess(this.userlog);
}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

class LoginRememberMeChanged extends LoginState {
  final bool rememberMe;
  LoginRememberMeChanged(this.rememberMe);
}

class LoginPassHideChanged extends LoginState {
  final bool hide;

  LoginPassHideChanged(this.hide);
}
