import 'dart:developer';
import 'package:acs_chat/acs_chat.dart';
import 'package:acs_chat_example/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final String accessToken;
  final String threadId;
  final String userId;
  final String endpoint;

  ChatController({
    required this.accessToken,
    required this.threadId,
    required this.userId,
    required this.endpoint,
  });

  @override
  void onInit() {
    super.onInit();
    AcsChat.setOnMessageReceived(_handleNativeMessage);
    _joinChat();
  }

  Future<void> _joinChat() async {
    await AcsChat.initChat(
      token: accessToken,
      threadId: threadId,
      userId: userId,
      endpoint: endpoint,
    );
  }

  Future<void> sendMessage() async {
    final message = textController.text.trim();
    if (message.isEmpty) return;

    textController.clear();

    final sendingMessage = ChatMessage(
      sender: "You",
      content: message,
      isSending: true,
    );

    messages.add(sendingMessage);
    _scrollToBottom();

    try {
      log("🟢 Sending message to native: $message");
      final result = await AcsChat.sendMessage(message);
      log("🟢 Received result from native: $result");

      if (result == "sent") {
        log("✅ Message sent");
        final index = messages.indexOf(sendingMessage);
        if (index != -1) {
          messages[index] = sendingMessage.copyWith(isSending: false);
        }
      }
    } on PlatformException catch (e) {
      log("❌ Error sending message: ${e.message}");
      final index = messages.indexOf(sendingMessage);
      if (index != -1) {
        messages[index] =
            sendingMessage.copyWith(isSending: false, isFailed: true);
      }
    }
  }

  void _handleNativeMessage(String sender, String message) {
    log("🟢 Received message from native: $sender: $message");
    final chatMessage = ChatMessage(
      sender: sender,
      content: message,
    );
    messages.add(chatMessage);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 60,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void resendMessage(ChatMessage failedMessage) async {
    final index = messages.indexOf(failedMessage);
    final updated = failedMessage.copyWith(isFailed: false, isSending: true);
    if (index != -1) messages[index] = updated;

    try {
      final result = await AcsChat.sendMessage(failedMessage.content);
      log("🟢 Resend result: $result");
      if (result == "sent") {
        messages[index] = updated.copyWith(isSending: false, isFailed: false);
      }
    } on PlatformException catch (_) {
      messages[index] =
          failedMessage.copyWith(isSending: false, isFailed: true);
    }
  }
}
