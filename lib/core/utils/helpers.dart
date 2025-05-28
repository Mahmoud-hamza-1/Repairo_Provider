
class Helpers {



  // تحويل تاريخ لصيغة مقروءة
  // static String formatDate(DateTime date) {
  //   return DateFormat('yyyy/MM/dd').format(date);
  // }



  // أول حرف كابتال
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // حساب العمر
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
