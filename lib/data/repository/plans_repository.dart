import 'package:repairo_provider/data/models/plans_model.dart';
import 'package:repairo_provider/data/web_services/plans_webservice.dart';

class PlansRepository {
  final PlansWebservice plansWebservice;

  PlansRepository({required this.plansWebservice});

  Future<List<RPLansData>> getAllPlans() async {
    final items = await plansWebservice.getAllPlans();
    return items.map((item) => RPLansData.fromJson(item)).toList();
  }
}
