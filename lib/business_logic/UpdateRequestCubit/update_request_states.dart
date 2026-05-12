abstract class UpdateRequestStates {}

class UpdateRequestInitial extends UpdateRequestStates {}

class UpdateRequestLoading extends UpdateRequestStates {}

class UpdateRequestSuccess extends UpdateRequestStates {}

class UpdateRequestError extends UpdateRequestStates {
  final String message;
  UpdateRequestError(this.message);
}
