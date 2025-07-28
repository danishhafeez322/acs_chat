
[![pub package](https://img.shields.io/pub/v/acs_chat.svg)](https://pub.dev/packages/acs_chat)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-flutter-blue.svg)](https://flutter.dev)


A Flutter plugin to integrate Azure Communication Services (ACS) **Chat** features using native Android/iOS SDKs.

---

## ✨ Features

- ✅ Real-time chat using ACS
- ✅ Send & receive messages
- ✅ Listen for incoming messages
- ✅ Listen for messages sent successfully
- ✅ Native implementation using platform channels
- 🔜 Coming soon: Calling support via ACS Calling SDK

---

## 🚀 Getting Started

### 1. Add dependency in `pubspec.yaml`

```yaml
dependencies:
  acs_chat: ^0.1.1
```
---
### 2. Prerequisites

To use this package, you need to have the following values from your Azure Communication Services (ACS) setup:

- `accessToken`: A valid ACS user access token generated from your backend using the Azure SDK. It must include the `chat` scope.
- `threadId`: The ID of the chat thread you want to join. You can create one using the Azure SDK.
- `userId`: The ACS user identity (e.g., `8:acs:...`) that matches the user the token was issued for.
- `endpoint`: The ACS resource endpoint, e.g., `https://<your-resource>.communication.azure.com`.

> 💡 If you're new to ACS, follow the [official quickstart](https://learn.microsoft.com/en-us/azure/communication-services/quickstarts/access-tokens) to create users, generate tokens, and create chat threads.
---

### 3. Initialize Chat

After obtaining all required values, initialize the chat session:

```dart
await AcsChat.initChat(
  token: 'YOUR_ACCESS_TOKEN',
  userId: 'YOUR_USER_ID',
  threadId: 'YOUR_THREAD_ID',
  endpoint: 'https://YOUR_RESOURCE.communication.azure.com',
);
```
---

## Maintainers

- [![LinkedIn](https://img.shields.io/badge/Danish-Hafeez-blue?logo=linkedin)](https://www.linkedin.com/in/danishhafeez)
- [![LinkedIn](https://img.shields.io/badge/Muhammad-Ahmad-blue?logo=linkedin)](https://www.linkedin.com/in/muhammad-ahmad-821963133)
