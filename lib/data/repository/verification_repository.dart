import 'package:repairo_provider/data/models/user_model.dart';
import 'package:repairo_provider/data/web_services/verification_webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationRepository {
  final VerificationWebservices verificationWebservices;

  VerificationRepository(this.verificationWebservices);

  Future<User> verifyNumber(String phone, String code, String fcm) async {
    final prefs = await SharedPreferences.getInstance();
    final String? fcmm = await prefs.getString('fcm');
    final data = await verificationWebservices.verifyNumber(
      phone,
      code,
      fcmm ??
          "fBZMOVInSWWF9OzKvtgqXJ:APA91bEweaX8C-ZOml5wCyIRWPnDlvtaQXR_D-GQMOD_isSNpRVbtznpkEv8j83HKObTbHaj_Q8djNyGZtV8seHsHPj4iUjtIvLcQBCuAzRf8L8nmeVm7Yo",
    );

    final token = data['data']['access_token'];
    // final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setBool('is_loggedin', true);

    return User.fromJson(data);
  }
}
