import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمات قديمة من تطبيق المستخدم — مسارات `/user/*` لا تناسب تطبيق الفني.
/// الاستخدام الفعلي للشاشة الرئيسية عبر [StatisticsWebservice] وغيره من `/technician/*`.
class HomeWebservices {
  final Location _location = Location();

  /// يحفظ إحداثيات الفني في SharedPreferences. يُرجع false عند رفض الصلاحية أو تعطيل GPS.
  Future<bool> saveCurrentLocationToPrefs() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }

    final loc = await _location.getLocation();
    if (loc.latitude == null || loc.longitude == null) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lat', loc.latitude!.toString());
    await prefs.setString('lng', loc.longitude!.toString());
    return true;
  }

  Future<String?> _authToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _authHeaders(String? token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  /// @deprecated مسار تطبيق المستخدم — لا يُستدعى في تطبيق الفني حالياً.
  @Deprecated('Use technician APIs. This endpoint is for the user app only.')
  Future<List<Map<String, dynamic>>> getBannerImages() async {
    final token = await _authToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated: missing auth_token');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/user/home-page/banner');
    final response = await http
        .get(url, headers: _authHeaders(token))
        .timeout(AppConstants.connectionTimeout);

    if (response.statusCode != 200) {
      if (kDebugMode) {
        debugPrint(
          'getBannerImages failed: ${response.statusCode} ${response.body}',
        );
      }
      throw Exception('banner failed (${response.statusCode})');
    }

    await saveCurrentLocationToPrefs();

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final raw = decoded['data'];
    if (raw is! List) {
      throw Exception('banner failed: invalid response shape');
    }
    return List<Map<String, dynamic>>.from(raw);
  }

  @Deprecated('Use technician APIs. This endpoint is for the user app only.')
  Future<List<Map<String, dynamic>>> searchHome(
    String word,
    String type,
  ) async {
    final token = await _authToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated: missing auth_token');
    }

    final url = Uri.parse('${AppConstants.baseUrl}/user/home-page/search').replace(
      queryParameters: {'word_search': word, 'type_search': type},
    );

    final response = await http
        .get(url, headers: _authHeaders(token))
        .timeout(AppConstants.connectionTimeout);

    if (response.statusCode != 200) {
      throw Exception('search failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final raw = decoded['data'];
    if (raw is! List) {
      throw Exception('search failed: invalid response shape');
    }
    return List<Map<String, dynamic>>.from(raw);
  }

  static Uri technicianUrl(List<String> serviceIds) {
    final query = <String, String>{};
    for (var i = 0; i < serviceIds.length; i++) {
      query['services[$i]'] = serviceIds[i];
    }
    return Uri.parse('${AppConstants.baseUrl}/user/technician')
        .replace(queryParameters: query);
  }

  @Deprecated('Use technician APIs. This endpoint is for the user app only.')
  Future<List<Map<String, dynamic>>> getServicesProviders(
    List<String> services,
  ) async {
    final token = await _authToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated: missing auth_token');
    }

    final url = technicianUrl(services);
    final response = await http
        .get(url, headers: _authHeaders(token))
        .timeout(AppConstants.connectionTimeout);

    if (response.statusCode != 200) {
      throw Exception('services providers failed (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final raw = decoded['data'];
    if (raw is! List) {
      throw Exception('services providers failed: invalid response shape');
    }
    return List<Map<String, dynamic>>.from(raw);
  }
}
