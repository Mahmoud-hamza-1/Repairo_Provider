class SubCategory {
  bool? success;
  String? message;
  List<RSubCategoryData>? data;

  SubCategory({this.success, this.message, this.data});

  SubCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RSubCategoryData>[];
      json['data'].forEach((v) {
        data!.add(RSubCategoryData.fromJson(v));
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

class RSubCategoryData {
  String? id;
  String? displayName;
  String? categoryId;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? image;

  RSubCategoryData({
    this.id,
    this.displayName,
    this.categoryId,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
  });

  RSubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    categoryId = json['category_id'];
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['display_name'] = displayName;
    data['category_id'] = categoryId;
    data['parent_id'] = parentId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
