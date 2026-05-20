import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/InvoiceCubit/invoice_cubit.dart';
import 'package:repairo_provider/business_logic/InvoiceCubit/invoice_states.dart';
import 'package:repairo_provider/data/models/invoice_model.dart';

class InvoiceDetailsPage extends StatefulWidget {
  final String id;

  const InvoiceDetailsPage({super.key, required this.id});

  @override
  State<InvoiceDetailsPage> createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage> {
  @override
  void initState() {
    context.read<InvoiceCubit>().getinvoice(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // عربي
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "تفاصيل الفاتورة",
            style: TextStyle(fontFamily: "Cairo"),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: BlocBuilder<InvoiceCubit, InvoiceStates>(
          builder: (context, state) {
            if (state is InvoiceSuccess) {
              final invoicedetails = state.invoiceData;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildInvoiceHeader(invoicedetails),
                  const SizedBox(height: 20),
                  _buildSectionTitle("🛠️ الخدمات"),
                  const SizedBox(height: 8),
                  ...?invoicedetails.services?.map(_buildServiceCard),

                  if ((invoicedetails.customServices?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle("✨ خدمات مخصصة"),
                    const SizedBox(height: 8),
                    ...invoicedetails.customServices!.map(
                      _buildCustomServiceCard,
                    ),
                  ],

                  const SizedBox(height: 30),
                  _buildTotalCard(invoicedetails.priceAfter ?? 0),
                ],
              );
            } else if (state is InvoiceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text("حدث خطأ"));
          },
        ),
      ),
    );
  }

  // 📌 رأس الفاتورة
  Widget _buildInvoiceHeader(InvoiceRData data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.teal.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoRow(
              Icons.confirmation_number,
              "رقم الطلب",
              data.serviceRequestId ?? "-",
            ),
            _infoRow(
              Icons.date_range,
              "تاريخ الإنشاء",
              data.createdDate ?? "-",
            ),
            _infoRow(Icons.payment, "تاريخ الدفع", data.paymentDate ?? "-"),
            _infoRow(Icons.credit_card, "طريقة الدفع", data.paymentType ?? "-"),
            _infoRow(
              Icons.info,
              "الحالة",
              data.status == "paid"
                  ? "مدفوعة"
                  : data.status == "rejected"
                  ? "مرفوض"
                  : data.status == "ongoing"
                  ? "جاري"
                  : data.status == "pending"
                  ? "غير مدفوعة"
                  : data.status == "cancelled"
                  ? "ملغي"
                  : "${data.status}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo",
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontFamily: "Cairo"),
            ),
          ),
        ],
      ),
    );
  }

  // 🛠️ بطاقة خدمة
  Widget _buildServiceCard(Services service) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.build_circle, color: Colors.teal),
        title: Text(
          service.name ?? "خدمة غير معروفة",
          style: const TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "الكمية: ${service.quantity} | السعر: ${service.price} ل.س",
          style: const TextStyle(fontFamily: "Cairo"),
        ),
      ),
    );
  }

  // ✨ بطاقة خدمة مخصصة
  Widget _buildCustomServiceCard(CustomService service) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.design_services, color: Colors.teal),
        title: Text(
          service.name ?? "خدمة مخصصة",
          style: const TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "الكلفة: ${service.price} ل.س",
          style: const TextStyle(fontFamily: "Cairo"),
        ),
      ),
    );
  }

  // 📌 عنوان قسم
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: "Cairo",
        color: Colors.teal,
      ),
    );
  }

  // 💰 بطاقة المجموع النهائي
  Widget _buildTotalCard(num total) {
    return Card(
      color: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            "المجموع الكلي: $total ل.س",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "Cairo",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
