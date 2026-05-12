class TechRequestsResponse {
  bool? success;
  String? message;
  Pagination? data;

  TechRequestsResponse({this.success, this.message, this.data});

  TechRequestsResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Pagination.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

/// صفحة تحتوي عناصر + معلومات التصفح (Laravel Pagination style)
class Pagination {
  int? currentPage;
  List<RTechRequestData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<PageLink>? links;
  String? nextPageUrl; // كان Null?
  String? path;
  int? perPage;
  String? prevPageUrl; // كان Null?
  int? to;
  int? total;

  Pagination({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <RTechRequestData>[];
      for (final v in (json['data'] as List)) {
        data!.add(RTechRequestData.fromJson(v));
      }
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];

    if (json['links'] != null) {
      links = <PageLink>[];
      for (final v in (json['links'] as List)) {
        links!.add(PageLink.fromJson(v));
      }
    }

    nextPageUrl = json['next_page_url'];
    path = json['path'];
    // بعض APIs ترجع per_page كنص، نتأكد نحولها لرقم إذا لزم
    final per = json['per_page'];
    if (per is int) {
      perPage = per;
    } else if (per is String) {
      perPage = int.tryParse(per);
    }

    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    if (data != null) map['data'] = data!.map((v) => v.toJson()).toList();
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    if (links != null) map['links'] = links!.map((v) => v.toJson()).toList();
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['prev_page_url'] = prevPageUrl;
    map['to'] = to;
    map['total'] = total;
    return map;
  }
}

/// عنصر الطلب (الريكويست الواحد)
class RTechRequestData {
  String? id;
  String? scheduledDate;
  String? scheduledTime;
  String? lat;
  String? lng;
  String? location;
  String? status;
  ServiceSummary? service;
  UserSummary? user;
  List<String>? images; // بدل List<Null>

  RTechRequestData({
    this.id,
    this.scheduledDate,
    this.scheduledTime,
    this.lat,
    this.lng,
    this.location,
    this.status,
    this.service,
    this.user,
    this.images,
  });

  RTechRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString(); // لو رجع رقم نحوله لنص
    scheduledDate = json['scheduled_date'];
    scheduledTime = json['scheduled_time'];
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
    location = json['location'];
    status = json['status'];

    service =
        json['service'] != null
            ? ServiceSummary.fromJson(json['service'])
            : null;

    // إذا user نفس تركيبة service استعمل ServiceSummary،
    // وإلا استخدم UserSummary المنفصلة
    user = json['user'] != null ? UserSummary.fromJson(json['user']) : null;

    if (json['image'] != null) {
      // إذا API بترجع List<String> مباشر
      final raw = json['image'];
      if (raw is List) {
        images = raw.map((e) => e.toString()).toList();
      }
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['scheduled_date'] = scheduledDate;
    map['scheduled_time'] = scheduledTime;
    map['lat'] = lat;
    map['lng'] = lng;
    map['location'] = location;
    map['status'] = status;
    if (service != null) map['service'] = service!.toJson();
    if (user != null) map['user'] = user!.toJson();
    if (images != null) map['image'] = images;
    return map;
  }
}

/// ملخص خدمة
class ServiceSummary {
  String? id;
  String? name;
  String? image;

  ServiceSummary({this.id, this.name, this.image});

  ServiceSummary.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }
}

/// ملخص مستخدم (عدّل الحقول حسب الـ API)
class UserSummary {
  String? id;
  String? name;
  String? avatar; // أو image إذا نفس الحقل

  UserSummary({this.id, this.name, this.avatar});

  UserSummary.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'];
    // لو الـ API بتستخدم 'image' بدل 'avatar':
    avatar = json['avatar'] ?? json['image'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['avatar'] = avatar;
    return map;
  }
}

/// روابط صفحات التصفح
class PageLink {
  String? url;
  String? label;
  bool? active;

  PageLink({this.url, this.label, this.active});

  PageLink.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['label'] = label;
    map['active'] = active;
    return map;
  }
}
