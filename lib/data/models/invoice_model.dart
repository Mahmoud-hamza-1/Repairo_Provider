class InvoiceDetails {
  bool? success;
  String? message;
  InvoiceRData? data;

  InvoiceDetails({this.success, this.message, this.data});

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? InvoiceRData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class InvoiceRData {
  String? id;
  String? serviceRequestId;
  String? createdDate;
  String? paymentDate;
  String? paymentType;
  String? status;
  String? discountCouponId;
  double? priceBefore;
  double? priceAfter;
  List<Services>? services;
  List<CustomService>? customServices;
  dynamic discountCoupon;

  InvoiceRData({
    this.id,
    this.serviceRequestId,
    this.createdDate,
    this.paymentDate,
    this.paymentType,
    this.status,
    this.discountCouponId,
    this.priceBefore,
    this.priceAfter,
    this.services,
    this.customServices,
    this.discountCoupon,
  });

  factory InvoiceRData.fromJson(Map<String, dynamic> json) {
    return InvoiceRData(
      id: json['id'],
      serviceRequestId: json['service_request_id'],
      createdDate: json['created_date'],
      paymentDate: json['payment_date'],
      paymentType: json['payment_type'],
      status: json['status'],
      discountCouponId: json['discount_coupon_id'],
      priceBefore: double.tryParse(json['price_before']?.toString() ?? '0'),
      priceAfter: double.tryParse(json['price_after']?.toString() ?? '0'),
      services:
          json['services'] != null
              ? List<Services>.from(
                json['services'].map((x) => Services.fromJson(x)),
              )
              : [],
      customServices:
          json['custom_services'] != null
              ? List<CustomService>.from(
                json['custom_services'].map((x) => CustomService.fromJson(x)),
              )
              : [],
      discountCoupon: json['discount_coupon'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['service_request_id'] = serviceRequestId;
    data['created_date'] = createdDate;
    data['payment_date'] = paymentDate;
    data['payment_type'] = paymentType;
    data['status'] = status;
    data['discount_coupon_id'] = discountCouponId;
    data['price_before'] = priceBefore;
    data['price_after'] = priceAfter;
    data['services'] = services?.map((v) => v.toJson()).toList();
    data['custom_services'] = customServices?.map((v) => v.toJson()).toList();
    data['discount_coupon'] = discountCoupon;
    return data;
  }
}

class Services {
  String? name;
  int? quantity;
  int? price;

  Services({this.name, this.quantity, this.price});

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'price': price};
  }
}

class CustomService {
  String? name;
  int? price;

  CustomService({this.name, this.price});

  factory CustomService.fromJson(Map<String, dynamic> json) {
    return CustomService(name: json['name'], price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price};
  }
}
