import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/AccountStatusCubit/account_status_states.dart';
import 'package:repairo_provider/data/repository/account_status_repository.dart';

class AccountStatusCubit extends Cubit<AccountStatusStates> {
  final AccountStatusRepository accountStatusRepository;
  AccountStatusCubit(this.accountStatusRepository)
    : super(AccountStatusInitial());

  void getAccountStatus() async {
    emit(AccountStatusLoading());
    try {
      // final prefs = await SharedPreferences.getInstance();
      // var tokenn = prefs.getString('auth_token');

      final techstatue = await accountStatusRepository.getAccountStatus();
      emit(AccountStatusSuccess(techstatue));
    } catch (e) {
      emit(AccountStatusError(e.toString()));
    }
  }
}
