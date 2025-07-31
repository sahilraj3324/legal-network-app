import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? type;
  Timestamp? timestamp;
  String? senderId;
  bool? seen;
  String? receiverId;
  String? mediaUrl;
  String? chatID;
  String? message;

  ChatModel({
    this.type,
    this.timestamp,
    this.senderId,
    this.seen,
    this.receiverId,
    this.mediaUrl,
    this.chatID,
    this.message,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    timestamp = json['timestamp'];
    senderId = json['senderId'];
    seen = json['seen'];
    receiverId = json['receiverId'];
    mediaUrl = json['mediaUrl'];
    chatID = json['chatID'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['timestamp'] = timestamp;
    data['senderId'] = senderId;
    data['seen'] = seen;
    data['receiverId'] = receiverId;
    data['mediaUrl'] = mediaUrl;
    data['chatID'] = chatID;
    data['message'] = message;
    return data;
  }
} 