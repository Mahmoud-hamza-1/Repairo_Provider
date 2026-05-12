class NotificationResponse {
  bool? success;
  String? message;
  List<RNotificationData>? data;

  NotificationResponse({this.success, this.message, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RNotificationData>[];
      json['data'].forEach((v) {
        data!.add(RNotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['success'] = success;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class RNotificationData {
  int? id;
  String? title;
  String? body;
  NotificationExtraData? data;
  String? notifiableType;
  String? notifiableId;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  RNotificationData({
    this.id,
    this.title,
    this.body,
    this.data,
    this.notifiableType,
    this.notifiableId,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  RNotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    data =
        json['data'] != null
            ? NotificationExtraData.fromJson(json['data'])
            : null;
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['title'] = title;
    result['body'] = body;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    result['notifiable_type'] = notifiableType;
    result['notifiable_id'] = notifiableId;
    result['read_at'] = readAt;
    result['created_at'] = createdAt;
    result['updated_at'] = updatedAt;
    return result;
  }
}

class NotificationExtraData {
  String? type;
  String? serviceRequestId;

  NotificationExtraData({this.type, this.serviceRequestId});

  NotificationExtraData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    serviceRequestId = json['service_request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['type'] = type;
    result['service_request_id'] = serviceRequestId;
    return result;
  }
}
