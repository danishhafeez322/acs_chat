import 'package:acs_chat_example/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Replace with your actual ACS token, thread ID, user ID, and endpoint
  final String acsToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjZDODBDMjc5MUZBMEVCODczMDI2NzlFRDhFQzFDRTE5OTNEQTAwMjMiLCJ4NXQiOiJiSURDZVItZzY0Y3dKbm50anNIT0daUGFBQ00iLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjlmNWY1MzBhLTEzMmUtNDJlZS1iMzE5LTQyNGM0Yjc1NDEyOV8wMDAwMDAyOC1hZTE5LTJmY2ItZWFmMy01NDNhMGQwMDliYTUiLCJzY3AiOjE3OTIsImNzaSI6IjE3NTM0NDQxMTUiLCJleHAiOjE3NTM1MzA1MTUsInJnbiI6ImFtZXIiLCJhY3NTY29wZSI6ImNoYXQiLCJyZXNvdXJjZUlkIjoiOWY1ZjUzMGEtMTMyZS00MmVlLWIzMTktNDI0YzRiNzU0MTI5IiwicmVzb3VyY2VMb2NhdGlvbiI6InVuaXRlZHN0YXRlcyIsImlhdCI6MTc1MzQ0NDExNX0.NU9EsxT_rybJ1esOOvVNorlW9c7GVximEqFZJdy9K0VzSf_jSwaiWZ5w84D6K_UmiqGEMNvg4pkWYivTLwvRp-SHEFCjVbyaAQraNqm5NWwy9zMGZLmnOKZV3d0dq6mEHNl7jlccr1Q3WWHNzMDXoJr21MvheiKuFpFT50gkJQREFlhiZ3faPCXaPSL2L4tWGSjTEzIukuh1nREoW3-4IsR3I2RcBxT0TJIbFhTpdXuQvE3SeKhg-62PTXobFpg4RAvexOif4KSkV6-bjGnItfiWHVje-ZJzBEuqBHgyakI-9YHRUbadEallgiQH832IQ3jaJx_VGbvZsICSXD0Wqg';
  final String chatThreadId =
      '19:acsV1_52acfbd5cb3c436db31c270172252c34@thread.v2';

  final String userId =
      "8:acs:9f5f530a-132e-42ee-b319-424c4b754129_00000028-ae19-2fcb-eaf3-543a0d009ba5";
  final String acsEndpoint =
      "https://knrchatacs.unitedstates.communication.azure.com";
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
