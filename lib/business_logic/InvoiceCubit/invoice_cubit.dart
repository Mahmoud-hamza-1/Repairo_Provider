import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/InvoiceCubit/invoice_states.dart';
import 'package:repairo_provider/data/repository/invoice_repository.dart';

class InvoiceCubit extends Cubit<InvoiceStates> {
  final InvoiceRepository invoiceRepository;

  InvoiceCubit(this.invoiceRepository) : super(InvoiceInitial());

  void getinvoice(String id) async {
    emit(InvoiceLoading());
    try {
      final invoicedetails = await invoiceRepository.getinvoice(id);
      emit(InvoiceSuccess(invoicedetails));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }
}
