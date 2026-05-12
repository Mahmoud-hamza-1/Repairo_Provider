import 'package:repairo_provider/data/models/statistics_model.dart';
import 'package:repairo_provider/data/web_services/statistics_webservice.dart';

class StatisticsRepository {
  final StatisticsWebservice statisticsWebservice;
  StatisticsRepository(this.statisticsWebservice);

  Future<RStatisticsData> getStatistics({
    String? fromdate,
    String? todate,
  }) async {
    print("dddddddddddddddddddddddd");
    final data = await statisticsWebservice.fetchStatistics(
      fromDate: fromdate,
      toDate: todate,
    );
    print("//////////////////////////");

    print(data);

    if (data == null) {
      throw Exception("No data received from API");
    }
    return RStatisticsData.fromJson(data['data']);
  }
}
