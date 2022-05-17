package com.kirpal.smart_reply

import androidx.annotation.NonNull
import com.google.mlkit.nl.smartreply.SmartReply
import com.google.mlkit.nl.smartreply.SmartReplySuggestionResult
import com.google.mlkit.nl.smartreply.TextMessage

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** SmartReplyPlugin */
class SmartReplyPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private val smartReply = SmartReply.getClient()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "smart_reply")
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "smart_reply")
      channel.setMethodCallHandler(SmartReplyPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "suggestReplies") {
      val conversation = call.arguments<List<Map<String, Any>>?>().map { m ->
        if(m["isLocalUser"] as Boolean) {
          return@map TextMessage.createForLocalUser(m["text"] as String, m["timestamp"] as Long)
        } else {
          return@map TextMessage.createForRemoteUser(m["text"] as String, m["timestamp"] as Long, m["userId"] as String)
        }
      }
      smartReply.suggestReplies(conversation)
              .addOnSuccessListener { suggestionResult ->
                when (suggestionResult.status) {
                    SmartReplySuggestionResult.STATUS_SUCCESS -> {
                      result.success(suggestionResult.suggestions.map { r -> r.text })
                    }
                    else -> {
                      result.success(listOf<String>())
                    }
                }
              }
              .addOnFailureListener { err ->
                result.error("SUGGESTION_FAILURE", err.message, null)
              }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
