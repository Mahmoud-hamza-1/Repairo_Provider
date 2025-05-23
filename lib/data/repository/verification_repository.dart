
import 'package:repairo_provider/data/models/user_model.dart';
import 'package:repairo_provider/data/web_services/verification_webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationRepository {
  final VerificationWebservices verificationWebservices;

  VerificationRepository(this.verificationWebservices);

  Future<User> verifyNumber(String phone, String code) async {
    final data = await verificationWebservices.verifyNumber(phone, code);

    final token = data['data']['access_token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    return User.fromJson(data);
  }
}
