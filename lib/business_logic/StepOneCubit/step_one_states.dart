abstract class StepOneStates {}

class StepOneInitial extends StepOneStates {}

class StepOneLoading extends StepOneStates {}

class StepOneSuccess extends StepOneStates {}

class StepOneError extends StepOneStates {
  final String message;
  StepOneError(this.message);
}
