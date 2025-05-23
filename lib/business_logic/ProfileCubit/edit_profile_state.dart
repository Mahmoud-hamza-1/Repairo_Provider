import 'package:repairo_provider/data/models/profile_model.dart';

abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final Profile profile;

  EditProfileSuccess(this.profile);
}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError(this.message);
}
