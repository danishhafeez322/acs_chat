import 'package:flutter/services.dart';

import 'acs_chat_platform_interface.dart';

class AcsChat {
  static const MethodChannel _channel = MethodChannel('acs_chat_flutter');

  static Future<void> initChat({
    required String token,
    required String threadId,
    required String userId,
    required String endpoint,
  }) async {
    await _channel.invokeMethod('initChat', {
      'token': token,
      'threadId': threadId,
      'userId': userId,
      'endpoint': endpoint,
    });
  }

  static Future<String> sendMessage(String message) async {
    final result = await _channel.invokeMethod('sendMessage', {
      'message': message,
    });
    return result;
  }

  static void setOnMessageReceived(
      Function(String sender, String message) handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onMessageReceived') {
        final sender = call.arguments['sender'];
        final message = call.arguments['message'];
        handler(sender, message);
      }
    });
  }

  static void setOnSendFailed(Function(String error) handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onSendMessageFailed') {
        final error = call.arguments;
        handler(error);
      }
    });
  }

  Future<String?> getPlatformVersion() {
    return AcsChatPlatform.instance.getPlatformVersion();
  }
}
