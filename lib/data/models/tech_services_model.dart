class TechServices {
  bool? success;
  String? message;
  RTechServicesData? data;

  TechServices({this.success, this.message, this.data});

  TechServices.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new RTechServicesData.fromJson(json['data'])
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

class RTechServicesData {
  String? categoryId;
  List<String>? subCategoryIds;
  List<Services>? services;

  RTechServicesData({this.categoryId, this.subCategoryIds, this.services});

  RTechServicesData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    subCategoryIds = json['sub_category_ids'].cast<String>();
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['sub_category_ids'] = this.subCategoryIds;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? serviceId;
  int? price;

  Services({this.serviceId, this.price});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['price'] = this.price;
    return data;
  }
}
