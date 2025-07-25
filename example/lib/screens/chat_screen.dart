import 'package:acs_chat_example/controller/chat_controller.dart';
import 'package:acs_chat_example/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final String accessToken;
  final String threadId;
  final String userId;
  final String endpoint;

  const ChatScreen({
    super.key,
    required this.accessToken,
    required this.threadId,
    required this.userId,
    required this.endpoint,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController(
      accessToken: accessToken,
      threadId: threadId,
      userId: userId,
      endpoint: endpoint, // Replace with your actual endpoint
    ));

    return Scaffold(
      appBar: AppBar(title: const Text("ACS Chat")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (_, index) {
                    return _buildMessage(
                        controller.messages[index], controller);
                  },
                )),
          ),
          _buildInputField(controller),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, ChatController controller) {
    final isMine = message.sender == "You";

    return Column(
      crossAxisAlignment:
          isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMine ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: isMine ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (isMine) const SizedBox(width: 6),
              if (isMine)
                if (message.isSending)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else if (!message.isFailed)
                  const Icon(Icons.check, size: 16, color: Colors.white),
            ],
          ),
        ),
        if (message.isFailed && isMine)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Not sent",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.blue,
                    size: 20,
                  ),
                  onTap: () => controller.resendMessage(message),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInputField(ChatController controller) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: controller.sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
