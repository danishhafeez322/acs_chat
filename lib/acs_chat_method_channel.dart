import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'acs_chat_platform_interface.dart';

/// An implementation of [AcsChatPlatform] that uses method channels.
class MethodChannelAcsChat extends AcsChatPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('acs_chat');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
