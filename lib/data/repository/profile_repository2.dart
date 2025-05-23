import 'package:repairo_provider/data/models/account_status_model.dart';
import 'package:repairo_provider/data/models/profile_step2_request.dart';
import 'package:repairo_provider/data/models/profile_step3_request.dart';
import 'package:repairo_provider/data/web_services/profile_remote_data_source2.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepository(this.remote);

  Future<void> updateStep1(name, address, image) =>
      remote.updateStep1(name, address, image);
  Future<void> updateStep2(Step2Request request) => remote.updateStep2(request);
  Future<void> updateStep3(Step3Request request) => remote.updateStep3(request);
  Future<AccountStatus> getAccountStatus() => remote.getAccountStatus();
}
