class RequestDetails {
  bool? success;
  String? message;
  RRequestDetailsData? data;

  RequestDetails({this.success, this.message, this.data});

  RequestDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? RRequestDetailsData.fromJson(json['data'])
            : null;
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

class RRequestDetailsData {
  String? id;
  String? scheduledDate;
  String? scheduledTime;
  String? lat;
  String? lng;
  String? location;
  String? details;
  String? status;
  String? createdAt;
  String? statusCancellation;

  Map<String, String>? bookingHistory; // 👈 مفتاح - قيمة

  User? user;
  User? technicianAccount;
  List<Services>? services;
  List<Services>? customServices;
  List<String>? image;

  dynamic review;
  dynamic report;

  RRequestDetailsData({
    this.id,
    this.scheduledDate,
    this.scheduledTime,
    this.lat,
    this.lng,
    this.location,
    this.details,
    this.status,
    this.createdAt,
    this.statusCancellation,
    this.bookingHistory,
    this.user,
    this.technicianAccount,
    this.services,
    this.customServices,
    this.image,
    this.review,
    this.report,
  });

  RRequestDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduledDate = json['scheduled_date'];
    scheduledTime = json['scheduled_time'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    statusCancellation = json['status_cancellation'];

    // 👇 booking_history
    if (json['booking_history'] != null) {
      bookingHistory = Map<String, String>.from(json['booking_history']);
    }

    user = json['user'] != null ? User.fromJson(json['user']) : null;
    technicianAccount =
        json['technician_account'] != null
            ? User.fromJson(json['technician_account'])
            : null;

    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }

    if (json['custom_services'] != null) {
      customServices = <Services>[];
      json['custom_services'].forEach((v) {
        customServices!.add(Services.fromJson(v));
      });
    }

    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }

    review = json['review'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['scheduled_date'] = scheduledDate;
    data['scheduled_time'] = scheduledTime;
    data['lat'] = lat;
    data['lng'] = lng;
    data['location'] = location;
    data['details'] = details;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['status_cancellation'] = statusCancellation;

    if (bookingHistory != null) {
      data['booking_history'] = bookingHistory;
    }

    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (technicianAccount != null) {
      data['technician_account'] = technicianAccount!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (customServices != null) {
      data['custom_services'] = customServices!.map((v) => v.toJson()).toList();
    }
    if (image != null) {
      data['image'] = image;
    }

    data['review'] = review;
    data['report'] = report;

    return data;
  }
}

class User {
  String? id;
  String? name;
  String? image;

  User({this.id, this.name, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Services {
  String? id;
  String? displayName;
  String? price;
  int? quantity;
  String? image;

  Services({this.id, this.displayName, this.price, this.quantity, this.image});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['display_name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['display_name'] = displayName;
    data['price'] = price;
    data['quantity'] = quantity;
    data['image'] = image;
    return data;
  }
}
