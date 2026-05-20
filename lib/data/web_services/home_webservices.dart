import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

class HomeWebservices {
  late PermissionStatus _permissionGranted;
  LocationData? currentLocation;
  final Location location = Location();

  Future<void> getLocation() async {
    bool serviceEnabled;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    final loc = await location.getLocation();

    currentLocation = loc;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lat', currentLocation!.latitude.toString());
    await prefs.setString('lng', currentLocation!.longitude.toString());
  }

  Future<List<Map<String, dynamic>>> getBannerImages() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/user/home-page/banner');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await getLocation();
      var lat = prefs.getString('lat');
      print(lat);

      print('Banner info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data'],
      );
      print(data.toString());
      return data;
    } else {
      print('Failed to get banner info: ${response.statusCode}');
      throw Exception('banner failed');
    }
  }

  Future<List<Map<String, dynamic>>> searchHome(
    String word,
    String type,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    final url = Uri.parse(
      '${AppConstants.baseUrl}/user/home-page/search?word_search=$word&type_search=$type',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('search info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data'],
      );
      print(data.toString());
      return data;
    } else {
      print('Failed to get search info: ${response.statusCode}');
      throw Exception('search failed');
    }
  }

  // static String technicianUrl(List<String> serviceIds) {
  //   final buffer = StringBuffer('${AppConstants.baseUrl}/user/technician?');
  //   for (int i = 0; i < serviceIds.length; i++) {
  //     buffer.write('services[$i]=${serviceIds[i]}');
  //     if (i != serviceIds.length - 1) {
  //       buffer.write('&');
  //     }
  //   }
  //   return buffer.toString();
  // }

  static String technicianUrl(List<String> serviceIds) {
    final buffer = StringBuffer('${AppConstants.baseUrl}/user/technician?');

    for (int i = 0; i < serviceIds.length; i++) {
      buffer.write('services[$i]=${serviceIds[i]}');
      if (i != serviceIds.length - 1) buffer.write('&');
    }

    return buffer.toString();
  }

  Future<List<Map<String, dynamic>>> getServicesProviders(
    List<String> services,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    final url = Uri.parse(technicianUrl(services));
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('services providers info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        dataa['data'],
      );
      print(data.toString());
      return data;
    } else {
      print('Failed to get search info: ${response.statusCode}');
      throw Exception('services providers failed');
    }
  }
}
