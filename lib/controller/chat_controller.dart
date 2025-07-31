import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/chat_model.dart';
import '../model/inbox_model.dart';
import '../model/user_model.dart';
import '../utils/fire_store_utils.dart';
import '../utils/notification_service.dart';
import '../utils/constant.dart';

class ChatController extends GetxController {
  final messageTextEditorController = TextEditingController().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  changeStatus() async {
    await FireStoreUtils.firestore
        .collection(Constant.chat)
        .doc(senderUserModel.value.id.toString())
        .collection(receiverUserModel.value.id.toString())
        .where("seen", isEqualTo: false)
        .get()
        .then((documentSnapshot) {
      for (int i = 0; i < documentSnapshot.docs.length; i++) {
        log("----->${senderUserModel.value.id.toString()}");
        log("----->${receiverUserModel.value.id.toString()}");
        if (documentSnapshot.docs[i]['receiverId'] == senderUserModel.value.id.toString()) {
          FireStoreUtils.firestore
              .collection(Constant.chat)
              .doc(documentSnapshot.docs[i]['senderId'])
              .collection(documentSnapshot.docs[i]['receiverId'])
              .doc(documentSnapshot.docs[i]['chatID'])
              .update({'seen': true}).catchError((error) {
            log("Failed : $error");
          });

          FireStoreUtils.firestore
              .collection(Constant.chat)
              .doc(documentSnapshot.docs[i]['receiverId'])
              .collection(documentSnapshot.docs[i]['senderId'])
              .doc(documentSnapshot.docs[i]['chatID'])
              .update({'seen': true}).catchError((error) {
            log("Failed : $error");
          });

          FireStoreUtils.firestore
              .collection(Constant.chat)
              .doc(documentSnapshot.docs[i]['senderId'])
              .collection("inbox")
              .doc(documentSnapshot.docs[i]['receiverId'])
              .update({
            'seen': true,
          }).catchError((error) {
            log("Failed to add: $error");
          });

          FireStoreUtils.firestore
              .collection(Constant.chat)
              .doc(documentSnapshot.docs[i]['receiverId'])
              .collection("inbox")
              .doc(documentSnapshot.docs[i]['senderId'])
              .update({
            'seen': true,
          }).catchError((error) {
            log("Failed to add: $error");
          });
        }
      }
    });
  }

  RxBool isLoading = true.obs;
  Rx<UserModel> receiverUserModel = UserModel().obs;
  Rx<UserModel> senderUserModel = UserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      receiverUserModel.value = argumentData['receiverModel'];
    }
    await FireStoreUtils.getCurrentUser().then((value) {
      if (value != null) {
        senderUserModel.value = value;
      }
    });
    changeStatus();
    isLoading.value = false;
  }

  sendMessage(String msg) async {
    messageTextEditorController.value.clear();
    InboxModel inboxModel = InboxModel(
        archive: false,
        lastMessage: msg,
        mediaUrl: "",
        receiverId: receiverUserModel.value.id.toString(),
        seen: false,
        senderId: senderUserModel.value.id.toString(),
        timestamp: Timestamp.now(),
        type: "text");

    InboxModel senderInboxModel = InboxModel(
        archive: false,
        lastMessage: msg,
        mediaUrl: "",
        receiverId: receiverUserModel.value.id.toString(),
        seen: true,
        senderId: senderUserModel.value.id.toString(),
        timestamp: Timestamp.now(),
        type: "text");

    await FireStoreUtils.firestore
        .collection(Constant.chat)
        .doc(senderUserModel.value.id.toString())
        .collection("inbox")
        .doc(receiverUserModel.value.id.toString())
        .set(senderInboxModel.toJson());

    await FireStoreUtils.firestore
        .collection(Constant.chat)
        .doc(receiverUserModel.value.id.toString())
        .collection("inbox")
        .doc(senderUserModel.value.id.toString())
        .set(inboxModel.toJson());

    ChatModel chatModel = ChatModel(
        type: "text",
        timestamp: Timestamp.now(),
        senderId: senderUserModel.value.id.toString(),
        seen: false,
        receiverId: receiverUserModel.value.id.toString(),
        mediaUrl: "",
        chatID: Constant.getUuid(),
        message: msg);

    await FireStoreUtils.firestore
        .collection(Constant.chat)
        .doc(senderUserModel.value.id.toString())
        .collection(receiverUserModel.value.id.toString())
        .doc(chatModel.chatID)
        .set(chatModel.toJson());
    await FireStoreUtils.firestore
        .collection(Constant.chat)
        .doc(receiverUserModel.value.id.toString())
        .collection(senderUserModel.value.id.toString())
        .doc(chatModel.chatID)
        .set(chatModel.toJson());

    Map<String, dynamic> playLoad = <String, dynamic>{
      "type": "chat",
      "senderId": senderUserModel.value.id.toString(),
      "receiverId": receiverUserModel.value.id.toString(),
    };

    if (receiverUserModel.value.fcmToken != null) {
      await NotificationService.sendChatNotification(
          token: receiverUserModel.value.fcmToken.toString(),
          title: receiverUserModel.value.getDisplayName(),
          body: msg,
          payload: playLoad);
    }
  }

  @override
  void dispose() {
    messageTextEditorController.value.dispose();
    super.dispose();
  }
} 