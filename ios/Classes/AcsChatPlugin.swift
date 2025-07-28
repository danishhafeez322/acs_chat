import Flutter
import UIKit
import AzureCommunicationChat
import AzureCommunicationCommon

public class AcsChatPlugin: NSObject, FlutterPlugin {
  private var methodChannel: FlutterMethodChannel?
  private var chatClient: ChatClient?
  private var chatThreadClient: ChatThreadClient?
  private var currentUserId: String = ""
  private var receivedMessageIds = Set<String>()
  private var isListenerRegistered = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "acs_chat", binaryMessenger: registrar.messenger())
    let instance = AcsChatPlugin()
    instance.methodChannel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initChat":
      guard let args = call.arguments as? [String: Any],
            let token = args["token"] as? String,
            let threadId = args["threadId"] as? String,
            let userId = args["userId"] as? String,
            let endpoint = args["endpoint"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required parameters", details: nil))
        return
      }
      initChatClient(token: token, threadId: threadId, userId: userId, endpoint: endpoint, result: result)

    case "sendMessage":
      guard let args = call.arguments as? [String: Any], let message = args["message"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Message is required", details: nil))
        return
      }
      sendChatMessage(message: message, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
 private func initChatClient(token: String, threadId: String, userId: String, endpoint: String, result: @escaping FlutterResult) {
    do {
      currentUserId = userId
      let credential = try CommunicationTokenCredential(token: token)
      chatClient = try ChatClient(endpoint: endpoint, credential: credential)
      chatThreadClient = try chatClient?.getChatThreadClient(threadId: threadId).chatThreadClient

      chatClient?.startRealTimeNotifications { [weak self] result in
        switch result {
        case .success:
          self?.registerMessageListener()
          result.success("Chat initialized")
        case .failure(let error):
          result.error("NOTIFICATION_ERROR", error.localizedDescription, nil)
        }
      }
    } catch {
      result(FlutterError(code: "INIT_FAILED", message: error.localizedDescription, details: nil))
    }
  }

  private func registerMessageListener() {
    guard let client = chatClient, !isListenerRegistered else {
      return
    }

    client.register(event: .chatMessageReceived) { [weak self] payload, _ in
      guard let event = payload as? ChatMessageReceived else { return }
      guard let messageId = event.id, let senderId = event.sender?.identifier else { return }

      if senderId == self?.currentUserId || self?.receivedMessageIds.contains(messageId) == true {
        return
      }

      self?.receivedMessageIds.insert(messageId)
      let sender = event.senderDisplayName ?? "Unknown"
      let content = event.message.content?.message ?? "[No content]"

      DispatchQueue.main.async {
        self?.methodChannel?.invokeMethod("onMessageReceived", arguments: ["sender": sender, "message": content])
      }
    }

    isListenerRegistered = true
  }

  private func sendChatMessage(message: String, result: @escaping FlutterResult) {
    guard let threadClient = chatThreadClient else {
      result(FlutterError(code: "INVALID_STATE", message: "Chat client not initialized", details: nil))
      return
    }

    Task {
      do {
        let options = SendChatMessageOptions(content: message)
        let response = try await threadClient.send(messageOptions: options)
        DispatchQueue.main.async {
          result("sent")
        }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "SEND_FAILED", message: error.localizedDescription, details: nil))
          self.methodChannel?.invokeMethod("onSendMessageFailed", arguments: error.localizedDescription)
        }
      }
    }
  }
}
