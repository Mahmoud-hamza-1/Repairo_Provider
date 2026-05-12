abstract class StepThreeStates {}

class StepThreeInitial extends StepThreeStates {}

class StepThreeLoading extends StepThreeStates {}

class StepThreeSuccess extends StepThreeStates {}

class StepThreeError extends StepThreeStates {
  final String message;
  StepThreeError(this.message);
}
