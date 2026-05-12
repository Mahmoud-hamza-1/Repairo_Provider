class PrevWorks {
  bool? success;
  String? message;
  List<RPrevWorkData>? data;

  PrevWorks({this.success, this.message, this.data});

  PrevWorks.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RPrevWorkData>[];
      json['data'].forEach((v) {
        data!.add(RPrevWorkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RPrevWorkData {
  String? id;
  String? technicianAccountId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  List<String>? images; // ✅ إضافة مصفوفة صور

  RPrevWorkData({
    this.id,
    this.technicianAccountId,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  RPrevWorkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    technicianAccountId = json['technician_account_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    // ✅ قراءة الصور كمصفوفة
    if (json['images'] != null) {
      images = List<String>.from(json['images']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['technician_account_id'] = technicianAccountId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    // ✅ إرجاع الصور إذا موجودة
    if (images != null) {
      data['images'] = images;
    }
    return data;
  }
}
