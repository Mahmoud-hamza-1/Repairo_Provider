import 'package:repairo_provider/data/models/tech_services_model.dart';
import 'package:repairo_provider/data/web_services/tech_services_webservice.dart';

class TechServicesRepository {
  final TechServicesWebservice techServicesWebservice;

  TechServicesRepository({required this.techServicesWebservice});

  Future<List<RTechServicesData>> getTechServices() async {
    final items = await techServicesWebservice.getTechServices();
    // بما أن `items` تحتوي على خريطة واحدة فقط، يجب تعديل الكود
    // حتى يتوافق مع هذا، أو يتم التعامل معه كقائمة عادية
    return items.map((item) => RTechServicesData.fromJson(item)).toList();
  }

  Future<void> updateTechServices(RTechServicesData data) async {
    final Map<String, dynamic> body = {
      'category_id': data.categoryId,
      'sub_categories': data.subCategoryIds,
      'services':
          data.services
              ?.map((s) => {'service_id': s.serviceId, 'price': s.price})
              .toList(),
    };
    await techServicesWebservice.updateTechServices(body);
  }
}
