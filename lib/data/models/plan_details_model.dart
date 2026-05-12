class PlanDetails {
  bool? success;
  String? message;
  RPlanDetailsData? data;

  PlanDetails({this.success, this.message, this.data});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new RPlanDetailsData.fromJson(json['data'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['duration_days'] = this.durationDays;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
