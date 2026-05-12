import 'package:repairo_provider/data/models/prev_work_model.dart';

abstract class PrevWorksStates {}

class PrevWorksInitial extends PrevWorksStates {}

class PrevWorksFailed extends PrevWorksStates {
  final String message;
  PrevWorksFailed(this.message);
}

class PrevWorksLoading extends PrevWorksStates {}

class PrevWorksLoaded extends PrevWorksStates {
  final List<RPrevWorkData> prevworks;
  PrevWorksLoaded({required this.prevworks});
}
