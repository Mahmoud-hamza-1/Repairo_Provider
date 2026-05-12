import 'package:repairo_provider/data/models/invoice_model.dart';
import 'package:repairo_provider/data/web_services/invoice_web_services.dart';

class InvoiceRepository {
  final InvoiceWebServices invoiceWebServices;

  InvoiceRepository(this.invoiceWebServices);

  Future<InvoiceRData> getinvoice(String id) async {
    final data = await invoiceWebServices.getinvoice(id);
    return InvoiceRData.fromJson(data);
  }
}
