import 'package:repairo_provider/data/models/userprofile_model.dart';
import 'package:repairo_provider/data/web_services/profile_webservices.dart';

class ProfileRepository {
  final ProfileWebservices profileWebservices;

  ProfileRepository(this.profileWebservices);

  Future<PData> getUserData(String token) async {
    final data = await profileWebservices.getUserInfo(token);
    return PData.fromJson(data);
  }
}
