import 'package:repairo_provider/data/models/account_status_model.dart';

abstract class AccountStatusStates {}

class AccountStatusInitial extends AccountStatusStates {}

class AccountStatusLoading extends AccountStatusStates {}

class AccountStatusSuccess extends AccountStatusStates {
  final AccountStatusData techstatus;
  AccountStatusSuccess(this.techstatus);
}

class AccountStatusError extends AccountStatusStates {
  final String message;
  AccountStatusError(this.message);
}
