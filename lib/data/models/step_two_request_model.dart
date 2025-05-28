class ServiceData {
  final String serviceId;
  final double price;

  ServiceData({required this.serviceId, required this.price});

  Map<String, dynamic> toJson() => {"service_id": serviceId, "price": price};
}

class ServicesRequestBody {
  final String categoryId;
  final List<String> subCategories;
  final List<ServiceData> services;

  ServicesRequestBody({
    required this.categoryId,
    required this.subCategories,
    required this.services,
  });

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "sub_categories": subCategories,
    "services": services.map((e) => e.toJson()).toList(),
  };
}
