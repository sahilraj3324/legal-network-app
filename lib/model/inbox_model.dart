import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  bool? archive;
  String? lastMessage;
  String? mediaUrl;
  String? receiverId;
  bool? seen;
  String? senderId;
  Timestamp? timestamp;
  String? type;

  InboxModel({
    this.archive,
    this.lastMessage,
    this.mediaUrl,
    this.receiverId,
    this.seen,
    this.senderId,
    this.timestamp,
    this.type,
  });

  InboxModel.fromJson(Map<String, dynamic> json) {
    archive = json['archive'];
    lastMessage = json['lastMessage'];
    mediaUrl = json['mediaUrl'];
    receiverId = json['receiverId'];
    seen = json['seen'];
    senderId = json['senderId'];
    timestamp = json['timestamp'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['archive'] = archive;
    data['lastMessage'] = lastMessage;
    data['mediaUrl'] = mediaUrl;
    data['receiverId'] = receiverId;
    data['seen'] = seen;
    data['senderId'] = senderId;
    data['timestamp'] = timestamp;
    data['type'] = type;
    return data;
  }
} 