import 'package:repairo_provider/data/models/step_two_request_model.dart';
import 'package:repairo_provider/data/web_services/step_two_webservices.dart';

class StepTwoRepository {
  final StepTwoWebservices stepTwoWebservices;

  StepTwoRepository(this.stepTwoWebservices);

  Future<void> steptwo(ServicesRequestBody body) async {
    final data = await stepTwoWebservices.steptwo(body);
  }
}
