import 'package:repairo_provider/data/models/tech_location_model.dart';
import 'package:repairo_provider/data/web_services/all_locations_webservice.dart';

class AllLocationsRepository {
  final AllLocationsWebservice allLocationsWebservice;

  AllLocationsRepository({required this.allLocationsWebservice});

  Future<List<RUserLocationData>> getLocations(String id) async {
    final responseData = await allLocationsWebservice.getlocations(id);

    final List<dynamic> locationsList = responseData['data'] ?? [];
    return locationsList
        .map((item) => RUserLocationData.fromJson(item))
        .toList();
  }
}
