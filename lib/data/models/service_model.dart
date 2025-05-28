class Service {
  bool? success;
  String? message;
  List<RServiceData>? data;

  Service({this.success, this.message, this.data});

  Service.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RServiceData>[];
      json['data'].forEach((v) {
        data!.add(new RServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RServiceData {
  String? id;
  String? subCategoryId;
  String? displayName;
  String? minPrice;
  String? maxPrice;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? image;

  RServiceData({
    this.id,
    this.subCategoryId,
    this.displayName,
    this.minPrice,
    this.maxPrice,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.deletedAt,
  });

  RServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['sub_category_id'];
    displayName = json['display_name'];
    minPrice = json['min_price'];
    maxPrice = json['max_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_category_id'] = this.subCategoryId;
    data['display_name'] = this.displayName;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['image'] = this.image;
    return data;
  }
}
