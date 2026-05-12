import 'package:repairo_provider/data/models/plans_model.dart';

abstract class AllplansStates {}

class AllplansInitial extends AllplansStates {}

class AllplansFailed extends AllplansStates {
  final String message;
  AllplansFailed(this.message);
}

class AllplansLoading extends AllplansStates {}

class AllplansLoaded extends AllplansStates {
  final List<RPLansData> plans;
  AllplansLoaded({required this.plans});
}
