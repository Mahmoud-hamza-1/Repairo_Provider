// class UserProfile {
//   bool? success;
//   String? message;
//   PData? data;

//   UserProfile({this.success, this.message, this.data});

//   UserProfile.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new PData.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class PData {
//   String? id;
//   String? name;
//   String? phone;
//   String? address;
//   String? image;

//   PData({this.id, this.name, this.phone, this.address, this.image});

//   PData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     phone = json['phone'];
//     address = json['address'];
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['phone'] = this.phone;
//     data['address'] = this.address;
//     data['image'] = this.image;
//     return data;
//   }
// }

class UserProfile {
  bool? success;
  String? message;
  PData? data;

  UserProfile({this.success, this.message, this.data});

  UserProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new PData.fromJson(json['data']) : null;
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

class PData {
  String? id;
  String? name;
  String? place;
  String? image;
  //List<Media>? media;

  PData({this.id, this.name, this.place, this.image});

  PData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    place = json['place'];
    image = json['image'];
    // if (json['media'] != null) {
    //   media = <Media>[];
    //   json['media'].forEach((v) {
    //     media!.add(new Media.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['place'] = this.place;
    data['image'] = this.image;
    // if (this.media != null) {
    //   data['media'] = this.media!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

// class Media {
//   int? id;
//   String? modelType;
//   String? modelId;
//   String? uuid;
//   String? collectionName;
//   String? name;
//   String? fileName;
//   String? mimeType;
//   String? disk;
//   String? conversionsDisk;
//   int? size;
//   List<Null>? manipulations;
//   List<Null>? customProperties;
//   List<Null>? generatedConversions;
//   List<Null>? responsiveImages;
//   int? orderColumn;
//   String? createdAt;
//   String? updatedAt;
//   String? originalUrl;
//   String? previewUrl;

//   Media(
//       {this.id,
//       this.modelType,
//       this.modelId,
//       this.uuid,
//       this.collectionName,
//       this.name,
//       this.fileName,
//       this.mimeType,
//       this.disk,
//       this.conversionsDisk,
//       this.size,
//       this.manipulations,
//       this.customProperties,
//       this.generatedConversions,
//       this.responsiveImages,
//       this.orderColumn,
//       this.createdAt,
//       this.updatedAt,
//       this.originalUrl,
//       this.previewUrl});

//   Media.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modelType = json['model_type'];
//     modelId = json['model_id'];
//     uuid = json['uuid'];
//     collectionName = json['collection_name'];
//     name = json['name'];
//     fileName = json['file_name'];
//     mimeType = json['mime_type'];
//     disk = json['disk'];
//     conversionsDisk = json['conversions_disk'];
//     size = json['size'];
//     if (json['manipulations'] != null) {
//       manipulations = <Null>[];
//       json['manipulations'].forEach((v) {
//         manipulations!.add(new Null.fromJson(v));
//       });
//     }
//     if (json['custom_properties'] != null) {
//       customProperties = <Null>[];
//       json['custom_properties'].forEach((v) {
//         customProperties!.add(new Null.fromJson(v));
//       });
//     }
//     if (json['generated_conversions'] != null) {
//       generatedConversions = <Null>[];
//       json['generated_conversions'].forEach((v) {
//         generatedConversions!.add(new Null.fromJson(v));
//       });
//     }
//     if (json['responsive_images'] != null) {
//       responsiveImages = <Null>[];
//       json['responsive_images'].forEach((v) {
//         responsiveImages!.add(new Null.fromJson(v));
//       });
//     }
//     orderColumn = json['order_column'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     originalUrl = json['original_url'];
//     previewUrl = json['preview_url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['model_type'] = this.modelType;
//     data['model_id'] = this.modelId;
//     data['uuid'] = this.uuid;
//     data['collection_name'] = this.collectionName;
//     data['name'] = this.name;
//     data['file_name'] = this.fileName;
//     data['mime_type'] = this.mimeType;
//     data['disk'] = this.disk;
//     data['conversions_disk'] = this.conversionsDisk;
//     data['size'] = this.size;
//     if (this.manipulations != null) {
//       data['manipulations'] =
//           this.manipulations!.map((v) => v.toJson()).toList();
//     }
//     if (this.customProperties != null) {
//       data['custom_properties'] =
//           this.customProperties!.map((v) => v.toJson()).toList();
//     }
//     if (this.generatedConversions != null) {
//       data['generated_conversions'] =
//           this.generatedConversions!.map((v) => v.toJson()).toList();
//     }
//     if (this.responsiveImages != null) {
//       data['responsive_images'] =
//           this.responsiveImages!.map((v) => v.toJson()).toList();
//     }
//     data['order_column'] = this.orderColumn;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['original_url'] = this.originalUrl;
//     data['preview_url'] = this.previewUrl;
//     return data;
//   }
// }
