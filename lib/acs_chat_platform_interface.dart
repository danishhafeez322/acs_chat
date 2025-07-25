import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'acs_chat_method_channel.dart';

abstract class AcsChatPlatform extends PlatformInterface {
  /// Constructs a AcsChatPlatform.
  AcsChatPlatform() : super(token: _token);

  static final Object _token = Object();

  static AcsChatPlatform _instance = MethodChannelAcsChat();

  /// The default instance of [AcsChatPlatform] to use.
  ///
  /// Defaults to [MethodChannelAcsChat].
  static AcsChatPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AcsChatPlatform] when
  /// they register themselves.
  static set instance(AcsChatPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
