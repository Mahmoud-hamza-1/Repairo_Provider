import 'package:repairo_provider/data/models/plan_details_model.dart';
import 'package:repairo_provider/data/web_services/plan_details_webservice.dart';

class PlanDataRepository {
  final PlanDataWebservices planDataWebservices;

  PlanDataRepository({required this.planDataWebservices});

  Future<RPlanDetailsData> getPlanData(String id) async {
    final item = await planDataWebservices.getPlanData(id);
    return RPlanDetailsData.fromJson(item);
  }
}
