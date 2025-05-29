import 'package:repairo_provider/data/models/user_requests_model.dart';
import 'package:repairo_provider/data/web_services/user_requests_webservices.dart';

class TechRequestsRepository {
  final TechRequestsWebservices techRequestsWebservices;

  TechRequestsRepository({required this.techRequestsWebservices});

  Future<List<RTechRequestData>> getAllRequests({String? status}) async {
    final items = await techRequestsWebservices.getAllRequests(status: status);
    return items.map((item) => RTechRequestData.fromJson(item)).toList();
  }
}
