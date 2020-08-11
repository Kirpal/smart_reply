import 'dart:async';

import 'package:flutter/services.dart';

/// Represents a text message from a certain user in a conversation
class TextMessage {
  /// The message content
  final String text;

  /// Timestamp of the message
  final DateTime timestamp;

  /// A unique user ID representing a remote user if the local user is having a
  /// conversation with more than one remote user. It's only used to distinguish
  /// participants in the conversation.
  ///
  /// There is no need to guarantee consistent user IDs across different API calls
  final String userId;

  /// Was this message sent by the local user?
  final bool isLocalUser;

  TextMessage({this.text, this.timestamp, this.userId, this.isLocalUser});

  Map<String, dynamic> _toJson() => {
        'text': text,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'userId': userId,
        'isLocalUser': isLocalUser,
      };
}

/// Automatically generate relevant replies to messages using
/// [Google MLKit API](https://developers.google.com/ml-kit/language/smart-reply)
///
/// The Smart Reply model generates reply suggestions based on the full context
/// of a conversation, not just a single message. This means the suggestions are
/// more helpful to your users.
///
/// The on-device model generates replies quickly and doesn't require you to
/// send users' messages to a remote server.
class SmartReply {
  static const MethodChannel _channel = const MethodChannel('smart_reply');

  /// Gets the suggested meaningful replies to a text message
  ///
  /// [textMessages] - a list of messages from which the API generates smart
  /// replies.
  ///
  /// The messages list should contain most recent conversation context for all
  /// users participating in the conversation in ascending chronological order
  /// (i.e. from oldest to newest). Internally, SmartReply considers the last 10
  /// messages to generate reply suggestions.
  static Future<List<String>> suggestReplies(List<TextMessage> textMessages) {
    if (textMessages.isEmpty || textMessages.last.isLocalUser) {
      return Future.value([]);
    }

    return _channel.invokeListMethod<String>(
        'suggestReplies', textMessages.map((m) => m._toJson()).toList());
  }
}
