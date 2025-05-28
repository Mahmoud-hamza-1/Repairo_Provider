import 'package:repairo_provider/data/web_services/login_webservice.dart';

import '../models/userlog_model.dart';

class AuthRepository {
  final AuthWebService authWebService;

  AuthRepository(this.authWebService);

  Future<UserLog> login(String phone) async {
    final data = await authWebService.login(phone);
    return UserLog.fromJson(data);
  }
}
