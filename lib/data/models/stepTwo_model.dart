class StepTwoDataModel {
  // أضف هنا جميع الحقول التي تحتاجها للخطوة الثانية
  final int categoryId;
  final int subcategoryId;
  final List<int> serviceIds;
  final double customPrice;

  StepTwoDataModel({
    required this.categoryId,
    required this.subcategoryId,
    required this.serviceIds,
    required this.customPrice,
  });

  // دالة لتحويل النموذج إلى JSON لإرساله إلى الـ API
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'service_ids': serviceIds,
      'custom_price': customPrice,
    };
  }
}
