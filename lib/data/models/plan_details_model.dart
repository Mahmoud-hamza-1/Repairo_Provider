class PlanDetails {
  bool? success;
  String? message;
  RPlanDetailsData? data;

  PlanDetails({this.success, this.message, this.data});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? RPlanDetailsData.fromJson(json['data']) : null;
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

class RPlanDetailsData {
  String? id;
  String? name;
  String? description;
  String? price;
  int? durationDays;
  String? status;
  String? createdAt;
  String? updatedAt;

  RPlanDetailsData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.durationDays,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  RPlanDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    durationDays = json['duration_days'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['duration_days'] = durationDays;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
