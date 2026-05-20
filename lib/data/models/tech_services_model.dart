class TechServices {
  bool? success;
  String? message;
  RTechServicesData? data;

  TechServices({this.success, this.message, this.data});

  TechServices.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? RTechServicesData.fromJson(json['data']) : null;
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
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['sub_category_ids'] = subCategoryIds;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['price'] = price;
    return data;
  }
}
