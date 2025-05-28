abstract class StepTwoStates {}

class StepTwoInitial extends StepTwoStates {}

class StepTwoLoading extends StepTwoStates {}

class StepTwoSuccess extends StepTwoStates {}

class StepTwoError extends StepTwoStates {
  final String message;
  StepTwoError(this.message);
}
