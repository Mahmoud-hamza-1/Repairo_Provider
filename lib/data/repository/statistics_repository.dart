import 'package:repairo_provider/data/models/statistics_model.dart';
import 'package:repairo_provider/data/web_services/statistics_webservice.dart';

class StatisticsRepository {
  StatisticsRepository(this.statisticsWebservice);

  final StatisticsWebservice statisticsWebservice;

  Future<RStatisticsData> getStatistics({
    String? fromdate,
    String? todate,
  }) async {
    final response = await statisticsWebservice.fetchStatistics(
      fromDate: fromdate,
      toDate: todate,
    );

    if (response['success'] != true) {
      final message = response['message']?.toString();
      throw Exception(message ?? 'فشل جلب الإحصائيات');
    }

    final raw = response['data'];
    if (raw == null) {
      return RStatisticsData.empty();
    }
    if (raw is! Map<String, dynamic>) {
      throw Exception('شكل بيانات الإحصائيات غير صحيح');
    }

    return RStatisticsData.fromJson(raw);
  }
}
