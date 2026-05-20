class Plans {
  bool? success;
  String? message;
  List<RPLansData>? data;

  Plans({this.success, this.message, this.data});

  Plans.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RPLansData>[];
      json['data'].forEach((v) {
        data!.add(RPLansData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RPLansData {
  String? id;
  String? name;
  String? description;
  String? price;
  int? durationDays;
  String? status;
  String? createdAt;
  String? updatedAt;

  RPLansData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.durationDays,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  RPLansData.fromJson(Map<String, dynamic> json) {
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
