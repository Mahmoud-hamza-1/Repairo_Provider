class UserLocation {
  bool? success;
  String? message;
  List<RUserLocationData>? data;

  UserLocation({this.success, this.message, this.data});

  UserLocation.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RUserLocationData>[];
      json['data'].forEach((v) {
        data!.add(new RUserLocationData.fromJson(v));
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

class RUserLocationData {
  String? id;
  String? address;
  String? lat;
  String? lng;
  String? type;

  RUserLocationData({this.id, this.address, this.lat, this.lng, this.type});

  RUserLocationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['type'] = this.type;
    return data;
  }
}
