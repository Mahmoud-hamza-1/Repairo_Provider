import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/StatisticsCubit/statistics_states.dart';
import 'package:repairo_provider/data/models/statistics_model.dart';
import 'package:repairo_provider/data/repository/statistics_repository.dart';

class AllstatisticsCubit extends Cubit<AllstatisticsStates> {
  AllstatisticsCubit(this.statisticsRepository) : super(AllstatisticsInitial());

  final StatisticsRepository statisticsRepository;
  RStatisticsData? statistics;

  Future<void> getAllstatistics({String? fromDate, String? toDate}) async {
    emit(AllstatisticsLoading());

    try {
      final thestatistics = await statisticsRepository.getStatistics(
        fromdate: fromDate,
        todate: toDate,
      );
      print("Repository returned: $thestatistics"); // <--- تأكد من القيم

      statistics = thestatistics;
      print("${statistics!.totalRequests}");
      print("//////////////////////////");
      print("//////////////////////////");
      print("//////////////////////////");
      print(statistics);
      emit(AllstatisticsLoaded(statistics: statistics!));
    } catch (e) {
      print("Fffffffffffffffffffffffffffffffffff");
      emit(AllstatisticsFailed(e.toString()));
    }
  }
}
