class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is NetworkException) {
      return "خطأ في الاتصال بالشبكة. تأكد من اتصالك بالإنترنت.";
    } else if (error is ServerException) {
      return "خطأ من الخادم. حاول لاحقاً.";
    } else if (error is UnauthorizedException) {
      return "انتهت صلاحية الجلسة. الرجاء تسجيل الدخول مجدداً.";
    } else {
      return "حدث خطأ غير متوقع. الرجاء المحاولة لاحقاً.";
    }
  }
}

// أنواع الأخطاء
class NetworkException implements Exception {}
class ServerException implements Exception {}
class UnauthorizedException implements Exception {}
