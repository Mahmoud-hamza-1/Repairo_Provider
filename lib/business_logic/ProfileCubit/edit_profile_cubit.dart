// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:repairo_provider/data/repository/profile_repository2.dart';
// import 'edit_profile_state.dart';
// import 'dart:io';

// class EditProfileCubit extends Cubit<EditProfileState> {
//   final ProfileRepository repository;

//   EditProfileCubit(this.repository) : super(EditProfileInitial());

//   Future<void> updateProfile({required String name, File? image}) async {
//     emit(EditProfileLoading());
//     try {
//       final profile = await repository.updateProfile(name: name, image: image);
//       emit(EditProfileSuccess(profile));
//     } catch (e) {
//       emit(EditProfileError(e.toString()));
//     }
//   }
// }
