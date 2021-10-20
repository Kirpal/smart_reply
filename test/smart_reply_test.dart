import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_reply/smart_reply.dart';

void main() {
  const MethodChannel channel = MethodChannel('smart_reply');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('SmartReply', () {
    group('constructor', () {
      test('returns normally', () {
        expect(SmartReply(), isNotNull);
      });
    });

    group('suggestReplies', () {
      setUp(() {
        channel.setMockMethodCallHandler((MethodCall methodCall) async {
          if (methodCall.method == 'suggestReplies') {
            return ['Suggestion 1', 'Suggestion 2', 'Suggestion 3'];
          }
        });
      });

      tearDown(() {
        channel.setMockMethodCallHandler(null);
      });

      test('returns an empty list when given no context', () async {
        expect(await SmartReply().suggestReplies([]), []);
      });

      test(
          'returns an empty list when the last message was from the local user',
          () async {
        expect(
          await SmartReply().suggestReplies([
            TextMessage(
              text: 'text',
              timestamp: DateTime.now(),
              userId: 'a',
              isLocalUser: true,
            ),
          ]),
          [],
        );
      });

      test('returns suggestions when the last message was from the remote user',
          () async {
        expect(
          await SmartReply().suggestReplies([
            TextMessage(
              text: 'text',
              timestamp: DateTime.now(),
              userId: 'a',
              isLocalUser: false,
            ),
          ]),
          ['Suggestion 1', 'Suggestion 2', 'Suggestion 3'],
        );
      });
    });
  });
}
