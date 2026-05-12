class AppConstants {
  static const baseaddress = 'repairo.icu';
  static const baseUrl = 'https://$baseaddress/api';

  // For local backend, swap the two lines above with:
  // static const baseaddress = '192.168.1.9';
  // static const baseUrl = 'http://$baseaddress:8000/api';

  static bool iscompleted = false;
  static var globalAccessToken = '';
  static var subscription_status = '';
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const String defaultLanguage = "ar";
  static const int itemsPerPage = 20;
  // مفاتيح الـ APIs
  static const String googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY";
  static const String firebaseServerKey = "YOUR_FIREBASE_SERVER_KEY";

  // روابط صور افتراضية
  static const String defaultUserImage = "https://example.com/default_user.png";
}
