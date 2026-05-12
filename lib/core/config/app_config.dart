enum Environment { dev, staging, production }

class AppConfig {
  static late final Environment environment;

  static late final String baseUrl;
  static late final String apiKey;
  static late final bool enableLogs;

  static void init(Environment env) {
    environment = env;

    switch (env) {
      case Environment.dev:
        baseUrl = "https://dev.api.example.com";
        apiKey = "dev-123456";
        enableLogs = true;
        break;

      case Environment.staging:
        baseUrl = "https://staging.api.example.com";
        apiKey = "staging-abcdef";
        enableLogs = true;
        break;

      case Environment.production:
        baseUrl = "https://api.example.com";
        apiKey = "prod-xyz123";
        enableLogs = false;
        break;
    }
  }
}




// ملف app_config.dart غالباً بكون فيه الإعدادات العامة للتطبيق يلي بتتغير حسب بيئة التشغيل (Development, Staging, Production).

// يعني بدل ما تغيّر إيدوياً الـ baseUrl أو الـ apiKey كل مرة، بتحطهم بـ AppConfig وبتغير البيئة بس 

//  شو ممكن يحتوي app_config.dart؟

// النوع	شو بيكون فيه
// API URLs	مثل baseUrl, authUrl, imageBaseUrl
// مفاتيح	apiKey, firebaseKey, إلخ...
// بيئة التطبيق	dev / staging / production
// flags	هل نعرض logs؟ هل نفعّل debug؟
// إعدادات عامة	timeout، retries، appVersion، ...

