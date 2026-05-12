class AccountStatus {
  bool? success;
  String? message;
  AccountStatusData? data;

  AccountStatus({this.success, this.message, this.data});

  AccountStatus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? AccountStatusData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AccountStatusData {
  String? step;
  String? status;
  String? subscriptionStatus; // New property added

  AccountStatusData({
    this.step,
    this.status,
    this.subscriptionStatus,
  }); // Updated constructor

  AccountStatusData.fromJson(Map<String, dynamic> json) {
    step = json['step'];
    status = json['status'];
    subscriptionStatus =
        json['subscription_status']; // Adjusted fromJson method
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['step'] = this.step;
    data['status'] = this.status;
    data['subscription_status'] =
        this.subscriptionStatus; // Adjusted toJson method
    return data;
  }
}
