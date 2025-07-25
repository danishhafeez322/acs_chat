package com.example.acs_chat

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.azure.android.communication.chat.*
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.*
import com.azure.android.communication.common.CommunicationTokenCredential
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.Handler
import android.os.Looper


class AcsChatPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var methodChannel: MethodChannel
    private lateinit var context: Context

    private lateinit var chatClient: ChatClient
    private lateinit var chatThreadClient: ChatThreadClient

    private var isListenerRegistered = false
    private var currentUserId: String = ""
    private val receivedMessageIds = mutableSetOf<String>()
    private var acsEndpoint: String? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "acs_chat_flutter")
        methodChannel.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initChat" -> {
                val token = call.argument<String>("token")
                val threadId = call.argument<String>("threadId")
                val userId = call.argument<String>("userId")
                acsEndpoint = call.argument<String>("endpoint") ?: ""

                if (token != null && threadId != null && userId != null) {
                   if (acsEndpoint.isNullOrEmpty()) {
                    result.error("NO_ENDPOINT", "Endpoint is required", null)
                    return
                }
                    initChatClient(token, threadId, userId,result)
                    result.success("Chat initialized")
                } else {
                    result.error("MISSING_ARGUMENTS", "token, threadId, or userId is null", null)
                }
            }
            "sendMessage" -> {
                val message = call.argument<String>("message")
                sendChatMessage(message, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun initChatClient(token: String, threadId: String, userId: String, result: MethodChannel.Result) {
       val endpoint = acsEndpoint ?: run {
            result.error("ENDPOINT_MISSING", "ACS endpoint is not set", null)
            return
        }
        currentUserId = userId

        val credential = CommunicationTokenCredential(token)
        chatClient = ChatClientBuilder()
            .credential(credential)
            .endpoint(endpoint)
            .buildClient()

        chatThreadClient = chatClient.getChatThreadClient(threadId)
        chatClient.startRealtimeNotifications(context) { error ->
            Log.e("ACSChat", "Realtime notification error", error)
        }
        Log.d("ACSChat", "Started realtime notifications")
        registerMessageListener()
    }


  private fun registerMessageListener() {
    if (isListenerRegistered) {
        Log.d("ACS_DEBUG", "Listener already registered — skipping")
        return
    }

    chatClient.addEventHandler(ChatEventType.CHAT_MESSAGE_RECEIVED) { payload ->
        try {
            val event = payload as ChatMessageReceivedEvent
            val messageId = event.id ?: return@addEventHandler
            val senderId = event.sender?.rawId ?: ""

            if (senderId == currentUserId || receivedMessageIds.contains(messageId)) return@addEventHandler

            receivedMessageIds.add(messageId)
            val sender = event.senderDisplayName ?: "Unknown"
            val content = event.getContent() ?: "[No content]"

        Handler(Looper.getMainLooper()).post {
            notifyFlutter("onMessageReceived", mapOf("sender" to sender, "message" to content))
        }

        } catch (e: Exception) {
            Log.e("ACS_DEBUG", "Error handling CHAT_MESSAGE_RECEIVED event: ${e.localizedMessage}", e)
        }
    }

    isListenerRegistered = true
}

    private fun sendChatMessage(message: String?, result: MethodChannel.Result) {
        if (!::chatThreadClient.isInitialized || message.isNullOrBlank()) {
            result.error("INVALID_STATE", "Chat client not ready or message is blank", null)
            return
        }

       Thread {
        try {
            val options = SendChatMessageOptions().setContent(message)
            val response = chatThreadClient.sendMessage(options)
            Log.d("ACS", "Message sent with id: ${response.id}")
            Handler(Looper.getMainLooper()).post {
                result.success("sent")
            }
        } catch (e: Exception) {
            Log.e("ACS", "sendChatMessage crash", e)
            Handler(Looper.getMainLooper()).post {
                result.error("SEND_FAILED", e.localizedMessage ?: "Message send failed", null)
                notifyFlutter("onSendMessageFailed", e.localizedMessage ?: "Unknown error")
            }
        }
    }.start()

    }

    private fun notifyFlutter(method: String, arguments: Any?) {
        methodChannel.invokeMethod(method, arguments)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }
}
