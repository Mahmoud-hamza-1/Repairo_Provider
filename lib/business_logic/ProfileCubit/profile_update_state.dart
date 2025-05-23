import '../../data/models/account_status_model.dart';

abstract class ProfileUpdateState {}

class ProfileInitial extends ProfileUpdateState {}

class ProfileLoading extends ProfileUpdateState {}

class ProfileStepSuccess extends ProfileUpdateState {}

class ProfileError extends ProfileUpdateState {
  final String message;
  ProfileError(this.message);
}

class AccountStatusLoaded extends ProfileUpdateState {
  final AccountStatus status;
  AccountStatusLoaded(this.status);
}
