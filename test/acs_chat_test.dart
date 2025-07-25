import 'package:flutter_test/flutter_test.dart';
import 'package:acs_chat/acs_chat.dart';
import 'package:acs_chat/acs_chat_platform_interface.dart';
import 'package:acs_chat/acs_chat_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAcsChatPlatform
    with MockPlatformInterfaceMixin
    implements AcsChatPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AcsChatPlatform initialPlatform = AcsChatPlatform.instance;

  test('$MethodChannelAcsChat is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAcsChat>());
  });

  test('getPlatformVersion', () async {
    AcsChat acsChatPlugin = AcsChat();
    MockAcsChatPlatform fakePlatform = MockAcsChatPlatform();
    AcsChatPlatform.instance = fakePlatform;

    expect(await acsChatPlugin.getPlatformVersion(), '42');
  });
}
