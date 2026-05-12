class UserProfile {
  bool? success;
  String? message;
  PData? data;

  UserProfile({this.success, this.message, this.data});

  UserProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class PData {
  String? id;
  String? phone;
  String? accountId;
  String? fcmToken;
  Account? account;

  PData({this.id, this.phone, this.accountId, this.fcmToken, this.account});

  PData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    accountId = json['account_id'];
    fcmToken = json['fcm_token'];
    account =
        json['account'] != null ? Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['phone'] = phone;
    map['account_id'] = accountId;
    map['fcm_token'] = fcmToken;
    if (account != null) {
      map['account'] = account!.toJson();
    }
    return map;
  }
}

class Account {
  String? id;
  String? name;
  String? place;
  String? jobCategoryId;
  String? status;
  String? subscriptionStatus;
  String? step;
  String? rating;
  String? wallet;
  String? lat;
  String? lng;
  int? isAvailable;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? image;

  Account({
    this.id,
    this.name,
    this.place,
    this.jobCategoryId,
    this.status,
    this.subscriptionStatus,
    this.step,
    this.rating,
    this.wallet,
    this.lat,
    this.lng,
    this.isAvailable,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
  });

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    place = json['place'];
    jobCategoryId = json['job_category_id'];
    status = json['status'];
    subscriptionStatus = json['subscription_status'];
    step = json['step'];
    rating = json['rating'];
    wallet = json['wallet'];
    lat = json['lat'];
    lng = json['lng'];
    isAvailable = json['is_available'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['place'] = place;
    map['job_category_id'] = jobCategoryId;
    map['status'] = status;
    map['subscription_status'] = subscriptionStatus;
    map['step'] = step;
    map['rating'] = rating;
    map['wallet'] = wallet;
    map['lat'] = lat;
    map['lng'] = lng;
    map['is_available'] = isAvailable;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['image'] = image;
    return map;
  }
}
