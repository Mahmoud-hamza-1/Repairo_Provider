// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageService {
//   static late SharedPreferences _prefs;

//   static const String _lastVisitedScreenKey = 'last_visited_screen';

//   // should call this before using LocaleStorage
//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   // Save methods
//   static Future<bool> saveString(String key, String value) async {
//     return await _prefs.setString(key, value);
//   }

//   static Future<bool> saveBool(String key, bool value) async {
//     return await _prefs.setBool(key, value);
//   }

//   static Future<bool> saveInt(String key, int value) async {
//     return await _prefs.setInt(key, value);
//   }

//   // Get methods
//   static String? getString(String key) {
//     return _prefs.getString(key);
//   }

//   static bool? getBool(String key) {
//     return _prefs.getBool(key);
//   }

//   static int? getInt(String key) {
//     return _prefs.getInt(key);
//   }

//   // Remove & Clear
//   static Future<bool> remove(String key) async {
//     return await _prefs.remove(key);
//   }

//   static Future<bool> clear() async {
//     return await _prefs.clear();
//   }

//   // --------------------------
//   // Specific Methods for Last Visited Screen
//   // --------------------------

//   static Future<void> saveLastVisitedScreen(String routeName) async {
//     await _prefs.setString(_lastVisitedScreenKey, routeName);
//   }

//   static String? getLastVisitedScreen() {
//     return _prefs.getString(_lastVisitedScreenKey);
//   }
// }
