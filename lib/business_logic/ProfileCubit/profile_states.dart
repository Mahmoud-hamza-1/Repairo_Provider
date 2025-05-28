import 'package:repairo_provider/data/models/userprofile_model.dart';

abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileSuccess extends ProfileStates {
  final PData userdata;
  ProfileSuccess(this.userdata);
}

class ProfileError extends ProfileStates {
  final String message;
  ProfileError(this.message);
}
