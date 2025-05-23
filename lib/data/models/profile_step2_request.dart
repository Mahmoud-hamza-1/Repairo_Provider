class Step2Request {
  final String categoryId;
  final List<String> subCategories;
  final List<ServiceItem> services;

  Step2Request({
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

class ServiceItem {
  final String serviceId;
  final double price;

  ServiceItem({required this.serviceId, required this.price});

  Map<String, dynamic> toJson() => {"service_id": serviceId, "price": price};
}
