import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/NotifficationsCubit/notiffications_states.dart';
import 'package:repairo_provider/data/models/notiffications_model.dart';
import 'package:repairo_provider/data/repository/notiffications_repository.dart';

class NotifficationsCubit extends Cubit<NotifficationsStates> {
  NotifficationsCubit(this.allNotifficationsRepository)
    : super(NotifficationsInitial());

  final AllNotifficationsRepository allNotifficationsRepository;
  late List<RNotificationData> notiffications = [];

  Future<void> getNotiffications() async {
    emit(NotifficationsLoading());

    try {
      final thenotiffications =
          await allNotifficationsRepository.getNotiffications();
      notiffications = thenotiffications;

      print("sssssssss");
      emit(NotifficationsLoaded(notiffications: thenotiffications));
    } catch (e) {
      emit(NotifficationsFailed(e.toString()));
    }
  }

  Future<void> readNotiffication({required String notiffication_id}) async {
    try {
      await allNotifficationsRepository.readNotiffication(
        notiffication_id: notiffication_id,
      );

      if (state is NotifficationsLoaded) {
        final currentState = state as NotifficationsLoaded;
        final updatedList =
            currentState.notiffications.map((n) {
              if (n.id.toString() == notiffication_id) {
                return n..readAt = DateTime.now().toString(); // عدّل نسخة
              }
              return n;
            }).toList();

        emit(NotifficationsLoaded(notiffications: updatedList));
      }
    } catch (e) {
      emit(NotifficationsFailed(e.toString()));
    }
  }

  Future<void> readAllNotiffications() async {
    // يمكنك هنا إرسال حالة تحميل لتحسين تجربة المستخدم
    // emit(NotifficationsLoading());

    try {
      // إرسال الطلب للسيرفر لتحديد كل الإشعارات كمقروءة
      final response =
          await allNotifficationsRepository.readAllNotiffications();

      // التحقق من أن الاستجابة من السيرفر كانت ناجحة (يمكنك تعديل هذا الشرط بناءً على الـ API)
      if (response['success'] == true) {
        // إذا كانت الحالة الحالية للكيوبيت هي AllNotifficationsLoaded
        if (state is NotifficationsLoaded) {
          final currentState = state as NotifficationsLoaded;
          final updatedList =
              currentState.notiffications.map((n) {
                return RNotificationData(
                  id: n.id,
                  title: n.title,
                  body: n.body,
                  createdAt: n.createdAt,
                  readAt:
                      DateTime.now()
                          .toString(), // تعيين تاريخ القراءة لجميع الإشعارات
                );
              }).toList();

          // إرسال حالة جديدة للقائمة المحدثة
          emit(NotifficationsLoaded(notiffications: updatedList));
        }
      } else {
        emit(NotifficationsFailed("فشل في تحديد الإشعارات كمقروءة"));
      }
    } catch (e) {
      emit(NotifficationsFailed(e.toString()));
    }
  }
}
