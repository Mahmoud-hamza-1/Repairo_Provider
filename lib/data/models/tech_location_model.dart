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
        data!.add(RUserLocationData.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['type'] = type;
    return data;
  }
}
