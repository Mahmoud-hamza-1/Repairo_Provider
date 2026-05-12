import 'package:repairo_provider/data/models/statistics_model.dart';

abstract class AllstatisticsStates {}

class AllstatisticsInitial extends AllstatisticsStates {}

class AllstatisticsFailed extends AllstatisticsStates {
  final String message;
  AllstatisticsFailed(this.message);
}

class AllstatisticsLoading extends AllstatisticsStates {}

class AllstatisticsLoaded extends AllstatisticsStates {
  final RStatisticsData statistics;
  AllstatisticsLoaded({required this.statistics});
}
