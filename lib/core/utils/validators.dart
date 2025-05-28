class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "البريد الإلكتروني مطلوب";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "صيغة البريد الإلكتروني غير صحيحة";
    }
    return null; // صح!
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور مطلوبة";
    }
    if (value.length < 6) {
      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    }
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "تأكيد كلمة المرور مطلوب";
    }
    if (password != confirmPassword) {
      return "كلمتا المرور غير متطابقتين";
    }
    return null;
  }

  static String? validateRequiredField(String? value, {String fieldName = "هذا الحقل"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName مطلوب";
    }
    return null;
  }
}
