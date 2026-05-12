import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/ChatCubit/chat_states.dart';
import 'package:repairo_provider/data/repository/chat_repository.dart';

class ChatCubit extends Cubit<ChatStates> {
  final ChatRepository chatRepository;

  ChatCubit(this.chatRepository) : super(ShowChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  void showChat(String requestid) async {
    emit(ShowChatLoading());
    try {
      final chat = await chatRepository.showChat(requestid);
      emit(ShowChatSuccess(chat));
    } catch (e) {
      emit(ShowChatError(e.toString()));
    }
  }

  void sendmessage(String chatid, String? message, File? image) async {
    emit(SendChatMessageLoading());
    try {
      await chatRepository.sendmessage(chatid, message, image);
      emit(SendChatMessageSuccess());
    } catch (e) {
      print("here is the occuring error");
      emit(SendChatMessageError(e.toString()));
    }
  }
}
