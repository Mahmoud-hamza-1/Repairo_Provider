import 'package:repairo_provider/data/web_services/update_request_webservice.dart';

class UpdateRequestRepository {
  final UpdateRequestWebservice updateRequestWebservice;

  UpdateRequestRepository(this.updateRequestWebservice);

  Future<void> updateRequest({
    required String requestId,
    String? status,
    List<ServiceUpdate> services = const [],
    List<CustomServiceUpdate> customServices = const [],
  }) async {
    final data = await updateRequestWebservice.updateRequest(
      requestId: requestId,
      status: status,
      services: services,
      customServices: customServices,
    );
    print(data);
  }
}
