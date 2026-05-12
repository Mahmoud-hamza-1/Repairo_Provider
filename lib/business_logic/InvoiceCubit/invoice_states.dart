import 'package:repairo_provider/data/models/invoice_model.dart';

abstract class InvoiceStates {}

class InvoiceInitial extends InvoiceStates {}

class InvoiceLoading extends InvoiceStates {}

class InvoiceSuccess extends InvoiceStates {
  final InvoiceRData invoiceData;
  InvoiceSuccess(this.invoiceData);
}

class InvoiceError extends InvoiceStates {
  final String message;
  InvoiceError(this.message);
}
