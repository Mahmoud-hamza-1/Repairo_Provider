class TechRequestss {
  bool? success;
  String? message;
  List<RTechRequestData>? data;

  TechRequestss({this.success, this.message, this.data});

  TechRequestss.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RTechRequestData>[];
      json['data'].forEach((v) {
        data!.add(RTechRequestData.fromJson(v));
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

class RTechRequestData {
  String? id;
  String? scheduledDate;
  String? scheduledTime;
  String? lat;
  String? lng;
  String? location;
  String? status;
  Service? service;
  Service? technicianAccount;
  List<String>? image;

  RTechRequestData({
    this.id,
    this.scheduledDate,
    this.scheduledTime,
    this.lat,
    this.lng,
    this.location,
    this.status,
    this.service,
    this.technicianAccount,
    this.image,
  });

  RTechRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduledDate = json['scheduled_date'];
    scheduledTime = json['scheduled_time'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
    status = json['status'];
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
    technicianAccount =
        json['technician_account'] != null
            ? Service.fromJson(json['technician_account'])
            : null;

    if (json['image'] != null) {
      image = List<String>.from(json['image']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['scheduled_date'] = scheduledDate;
    data['scheduled_time'] = scheduledTime;
    data['lat'] = lat;
    data['lng'] = lng;
    data['location'] = location;
    data['status'] = status;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (technicianAccount != null) {
      data['technician_account'] = technicianAccount!.toJson();
    }
    if (image != null) {
      data['image'] = image;
    }
    return data;
  }
}

class Service {
  String? id;
  String? name;
  String? image;

  Service({this.id, this.name, this.image});

  Service.fromJson(Map<String, dynamic> json) {
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
