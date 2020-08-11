import Flutter
import UIKit
import MLKitSmartReply

public class SwiftSmartReplyPlugin: NSObject, FlutterPlugin {
    private let smartReply = SmartReply.smartReply()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "smart_reply", binaryMessenger: registrar.messenger())
    let instance = SwiftSmartReplyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "suggestReplies") {
        let args = (call.arguments as! Array<Dictionary<String, Any>>)
        let conversation = args.map({
            (m) -> TextMessage in
                return TextMessage(
                    text: m["text"] as! String,
                    timestamp: m["timestamp"] as! TimeInterval,
                    userID: m["userId"] as! String,
                isLocalUser: m["isLocalUser"] as! Bool)
        })
        smartReply.suggestReplies(for: conversation) { (suggestionResult: SmartReplySuggestionResult?, err: Error?) in
            if (err != nil) {
                result(FlutterError.init(
                    code: "SUGGESTION_FAILURE",
                    message: err.debugDescription,
                    details: nil))
            } else if (suggestionResult?.status == SmartReplyResultStatus.success) {
                result(suggestionResult?.suggestions.map({$0.text}))
            } else {
                result(Array<String>())
            }
        }
    } else {
        result([])
    }
  }
}
