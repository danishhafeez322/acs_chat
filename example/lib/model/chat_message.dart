class ChatMessage {
  final String sender;
  final String content;
  final bool isFailed;
  final bool isSending;

  ChatMessage({
    required this.sender,
    required this.content,
    this.isFailed = false,
    this.isSending = false,
  });

  ChatMessage copyWith({
    String? sender,
    String? content,
    bool? isFailed,
    bool? isSending,
  }) {
    return ChatMessage(
      sender: sender ?? this.sender,
      content: content ?? this.content,
      isFailed: isFailed ?? this.isFailed,
      isSending: isSending ?? this.isSending,
    );
  }
}
