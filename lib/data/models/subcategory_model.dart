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
        data!.add(new RSubCategoryData.fromJson(v));
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

class RSubCategoryData {
  String? id;
  String? displayName;
  String? categoryId;
  String? parentId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? image;

  RSubCategoryData(
      {this.id,
      this.displayName,
      this.categoryId,
      this.parentId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.image});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['display_name'] = this.displayName;
    data['category_id'] = this.categoryId;
    data['parent_id'] = this.parentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
