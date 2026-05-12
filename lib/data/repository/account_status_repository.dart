import 'package:repairo_provider/data/models/account_status_model.dart';
import 'package:repairo_provider/data/web_services/account_status_webservice.dart';

class AccountStatusRepository {
  final AccountStatusWebservice accountStatusWebservice;

  AccountStatusRepository(this.accountStatusWebservice);

  Future<AccountStatusData> getAccountStatus() async {
    final data = await accountStatusWebservice.getAccountStatus();
    return AccountStatusData.fromJson(data);
  }
}
