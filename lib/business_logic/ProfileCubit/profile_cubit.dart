import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_states.dart';
import 'package:repairo_provider/data/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepository profileRepository;
  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  void getUserData(String token) async {
    emit(ProfileLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      var tokenn = prefs.getString('auth_token');

      final user = await profileRepository.getUserData(tokenn!);
      emit(ProfileSuccess(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
