import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/core/constants/app_constants.dart';
import 'status_check_event.dart';
import 'status_check_state.dart';

class SubscriptionStatusBloc extends Bloc<StatusCheckEvent, StatusCheckState> {
  // هذا هو المتغير الذي سنفحص قيمته
  // في التطبيق الحقيقي، يجب جلب هذه القيمة من الـ API أو SharedPreferences
  static var subscription_status = " ${AppConstants.subscription_status}";

  SubscriptionStatusBloc() : super(StatusInitial()) {
    on<CheckSubscriptionStatus>((event, emit) async {
      emit(StatusLoading());

      // --- هنا تضع منطق جلب قيمة subscription_status ---
      // على سبيل المثال، من API أو من مخزن محلي
      // للتجربة الآن، سنضع قيمة يدوية:
      // subscription_status = 'inactive'; // جرب تغييرها إلى 'in_active' أو 'active'

      await Future.delayed(const Duration(seconds: 1)); // محاكاة لطلب الشبكة

      if (subscription_status == 'inactive') {
        emit(NavigateToSubscriptionPlans());
      } else if (subscription_status == 'in_active') {
        emit(SubscriptionIsExpired());
      } else {
        // لأي حالة أخرى (مثل 'active')، ننتقل للتطبيق الرئيسي
        emit(NavigateToMainApp());
      }
    });
  }
}
