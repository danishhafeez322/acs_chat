import 'package:acs_chat_example/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  // Replace with your actual ACS token, thread ID, user ID, and endpoint
  final String acsToken = dotenv.env['ACS_TOKEN']!;
  final String chatThreadId = dotenv.env['CHAT_THREAD_ID']!;
  final String userId = dotenv.env['USER_ID']!;
  final String acsEndpoint = dotenv.env['ACS_ENDPOINT']!;

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ACS Chat Example',
    home: ChatScreen(
      accessToken: acsToken,
      threadId: chatThreadId,
      userId: userId,
      endpoint: acsEndpoint,
    ),
  ));
}
