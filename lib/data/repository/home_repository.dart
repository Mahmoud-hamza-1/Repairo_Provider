import 'package:repairo_provider/data/web_services/home_webservices.dart';

class HomeRepository {
  final HomeWebservices homeWebservices;

  HomeRepository({required this.homeWebservices});

  // Future<List<RBannerImageData>> getBannerImages() async {
  //   final items = await homeWebservices.getBannerImages();
  //   return items.map((item) => RBannerImageData.fromJson(item)).toList();
  // }

  // Future<List<RSearchedTechsData>> searchTechHome(
  //     String word, String type) async {
  //   print("Techs Searching Starteddd");
  //   final items = await homeWebservices.searchHome(word, type);
  //   print("this inside repooooo");
  //   final result =
  //       items.map((item) => RSearchedTechsData.fromJson(item)).toList();
  //   print("result in repo ===> $result");
  //   return result;
  // }

  // Future<List<RSearchesServiceProvidersData>> getServicesProviders(
  //     List<String> services) async {
  //   print("service providers Searching Starteddd");
  //   final items = await homeWebservices.getServicesProviders(services);
  //   print("this inside repooooo");
  //   final result = items
  //       .map((item) => RSearchesServiceProvidersData.fromJson(item))
  //       .toList();
  //   print("result in repo of services providerss ===> $result");
  //   return result;
  // }

  // Future<List<RSearchedServiceData>> searchServiceHome(
  //     String word, String type) async {
  //   print("Services Searching Starteddd");
  //   final items = await homeWebservices.searchHome(word, type);
  //   print("this inside repooooo of servicesearch");
  //   final result =
  //       items.map((item) => RSearchedServiceData.fromJson(item)).toList();
  //   print("result of searched services in repo ===> $result");
  //   return result;
  // }

  // Future<List<RSearchedServiceData>> searchServiceHome(
  //     String word, String type) async {
  //   final items = await homeWebservices.searchHome(word, type);
  //   return items.map((item) => RSearchedServiceData.fromJson(item)).toList();
  // }
}
