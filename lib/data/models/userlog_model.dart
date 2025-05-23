class UserLog {
  final String success;
  final String message;
  final String data;

  UserLog({required this.success, required this.message, required this.data});

  factory UserLog.fromJson(Map<String, dynamic> json) {
    return UserLog(
      success: json['success'].toString(),
      message: json['message'],
      data: json['data'].toString(),
    );
  }
}
