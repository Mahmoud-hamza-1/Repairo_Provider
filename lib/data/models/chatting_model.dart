class Chat {
  bool? success;
  String? message;
  RChatData? data;

  Chat({this.success, this.message, this.data});

  Chat.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? RChatData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RChatData {
  String? chatId;
  String? userName;
  String? userImage;
  List<Messages>? messages;

  RChatData({this.chatId, this.userName, this.userImage, this.messages});

  RChatData.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    userName = json['user_name'];
    userImage = json['user_image'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['user_name'] = userName;
    data['user_image'] = userImage;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? id;
  String? content;
  String? sender;
  String? createdAt;

  Messages({this.id, this.content, this.sender, this.createdAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    sender = json['sender'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['sender'] = sender;
    data['created_at'] = createdAt;
    return data;
  }
}
