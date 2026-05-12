import 'package:repairo_provider/data/models/notiffications_model.dart';
import 'package:repairo_provider/data/web_services/notiffications_webservice.dart';

class AllNotifficationsRepository {
  final AllNotifficationsWebservice allNotifficationsWebservice;

  AllNotifficationsRepository({required this.allNotifficationsWebservice});

  Future<List<RNotificationData>> getNotiffications() async {
    final responseData = await allNotifficationsWebservice.getNotiffications();
    print("aaaaaaaaaaaaa");

    final List<dynamic> notifficationsList = responseData['data'] ?? [];

    return notifficationsList
        .map((item) => RNotificationData.fromJson(item))
        .toList();
  }

  Future<Map<String, dynamic>> readNotiffication({
    required String notiffication_id,
  }) async {
    final data = await allNotifficationsWebservice.readNotiffication(
      notiffication_id: notiffication_id,
    );
    print(data);
    return data;
  }

  Future<Map<String, dynamic>> readAllNotiffications() async {
    final data = await allNotifficationsWebservice.readAllNotiffications();
    print(data);
    return data;
  }
}
