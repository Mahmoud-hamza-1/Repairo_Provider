// abstract class ShowChatStates {}

import 'package:repairo_provider/data/models/chatting_model.dart';

abstract class ChatStates {}

class ShowChatInitial extends ChatStates {}

class ShowChatLoading extends ChatStates {}

class ShowChatSuccess extends ChatStates {
  final RChatData chat;
  ShowChatSuccess(this.chat);
}

class ShowChatError extends ChatStates {
  final String message;
  ShowChatError(this.message);
}

// abstract class SendChatMessageStates {}

class SendChatMessageInitial extends ChatStates {}

class SendChatMessageLoading extends ChatStates {}

class SendChatMessageSuccess extends ChatStates {}

class SendChatMessageError extends ChatStates {
  final String message;
  SendChatMessageError(this.message);
}
