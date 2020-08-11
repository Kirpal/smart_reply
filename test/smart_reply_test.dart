import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reply/smart_reply.dart';

void main() {
  const MethodChannel channel = MethodChannel('smart_reply');

  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('suggestReplies', () async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'suggestReplies') {
        return ['Suggestion 1', 'Suggestion 2', 'Suggestion 3'];
      }
    });

    expect(await SmartReply.suggestReplies([]), []);
    expect(
        await SmartReply.suggestReplies([
          TextMessage(
              text: 'text',
              timestamp: DateTime.now(),
              userId: 'a',
              isLocalUser: true)
        ]),
        []);
    expect(
        await SmartReply.suggestReplies([
          TextMessage(
              text: 'text',
              timestamp: DateTime.now(),
              userId: 'a',
              isLocalUser: false)
        ]),
        ['Suggestion 1', 'Suggestion 2', 'Suggestion 3']);
  });
}
