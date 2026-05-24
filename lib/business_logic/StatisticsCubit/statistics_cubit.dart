import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/StatisticsCubit/statistics_states.dart';
import 'package:repairo_provider/data/models/statistics_model.dart';
import 'package:repairo_provider/data/repository/statistics_repository.dart';
import 'package:repairo_provider/data/web_services/statistics_webservice.dart';

class AllstatisticsCubit extends Cubit<AllstatisticsStates> {
  AllstatisticsCubit(this.statisticsRepository) : super(AllstatisticsInitial());

  final StatisticsRepository statisticsRepository;
  RStatisticsData? statistics;
  String? lastErrorMessage;

  Future<void> getAllstatistics({String? fromDate, String? toDate}) async {
    emit(AllstatisticsLoading());
    lastErrorMessage = null;

    try {
      final thestatistics = await statisticsRepository.getStatistics(
        fromdate: fromDate,
        todate: toDate,
      );
      statistics = thestatistics;
      emit(AllstatisticsLoaded(statistics: thestatistics));
    } on StatisticsApiException catch (e) {
      lastErrorMessage = e.toString();
      if (kDebugMode) {
        debugPrint('Statistics API error: $e');
      }
      statistics = RStatisticsData.empty();
      emit(
        AllstatisticsLoaded(
          statistics: statistics!,
          warningMessage: lastErrorMessage,
        ),
      );
    } catch (e) {
      lastErrorMessage = e.toString();
      if (kDebugMode) {
        debugPrint('Statistics error: $e');
      }
      statistics = RStatisticsData.empty();
      emit(
        AllstatisticsLoaded(
          statistics: statistics!,
          warningMessage: 'تعذر تحميل الإحصائيات',
        ),
      );
    }
  }
}
