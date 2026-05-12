import 'package:repairo_provider/data/models/service_model.dart';
import 'package:repairo_provider/data/web_services/services_webservices.dart';

class ServiceRepository {
  final ServiceWebservices serviceWebservices;

  ServiceRepository({required this.serviceWebservices});

  Future<List<RServiceData>> getServices(String id) async {
    final items = await serviceWebservices.getServices(id);
    return items.map((item) => RServiceData.fromJson(item)).toList();
  }
}
