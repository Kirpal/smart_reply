# smart_reply

Generate relevant replies to messages using [MLKit](https://developers.google.com/ml-kit/language/smart-reply) with an on-device model so no messages are sent to a server.

*Note: this is an unofficial plugin.*

## How to Use
See `example` for a full example of usage
```dart
import 'package:smart_reply/smart_reply.dart';

var messages = [
    TextMessage(
        text: 'Message Text',
        timestamp: DateTime.now(),
        userId: 'abcd1234',
        isLocalUser: true,
    ),
    TextMessage(
        text: 'Message Reply',
        timestamp: DateTime.now(),
        userId: 'wxyz1234',
        isLocalUser: false,
    ),
];

var suggestions = await SmartReply.getSuggestions(messages);
// ['No worries', '😞', 'No problem!']
```

### Android Setup
In your `android/app/build.gradle`, disable compression of tflite files:

```
android {
    // ...
    aaptOptions {
        noCompress "tflite"
    }
}
```
Otherwise `getSuggestions` will throw a `PlatformException`

### iOS Setup
Requirements:
- Xcode 11.7 or greater.
- 64-bit architectures (x86_64 and arm64).
You must [limit your app](https://stackoverflow.com/a/33646645/14761140) to __64-bit devices only__.
> In Xcode, set the following values:
>
> Build settings > Architectures:
> - Set to arm64 only. (click Other -> + and than enter arm64)
>
> Build settings > Valid architectures:
> - Set to arm64 only.
>
> Info.plist:
> - Set UIRequiredDeviceCapabilities to arm64 only.

You also have to set the iOS Deployment Target to at least 8.0.

## Key capabilities
- The Smart Reply model generates reply suggestions based on the full context of a conversation, not just a single message. This means the suggestions are more helpful to your users.
- The on-device model generates replies quickly and doesn't require you to send users' messages to a remote server.

## Limitations
- Smart Reply is intended for casual conversations in consumer apps. Reply suggestions might not be appropriate for other contexts or audiences.
- Currently, only English is supported. The model automatically identifies the language being used and only provides suggestions when it's English.

## How the model works
- The model uses up to 10 of the most recent messages from a conversation history to generate reply suggestions.
- It detects the language of the conversation and only attempts to provide responses when the language is determined to be English.
- The model compares the messages against a list of sensitive topics and won’t provide suggestions when it detects a sensitive topic.
- If the language is determined to be English and no sensitive topics are detected, the model provides up to three suggested responses. The number of responses depends on how many meet a sufficient level of confidence based on the input to the model.

## Provide feedback
- Due to the complexity of natural language processing, the suggestions provided by the model may not be appropriate for all contexts or audiences. If you encounter inappropriate reply suggestions, reach out to [ML Kit support](https://developers.google.com/ml-kit/community). Your feedback helps to improve the model and the filters for sensitive topics.

## Example results
### Input

Timestamp|User ID|Local User?|Message
---|---|---|---
Thu Feb 21 13:13:39 PST 2019||true|are you on your way?
Thu Feb 21 13:15:03 PST 2019|FRIEND0|false|Running late, sorry!

### Suggested replies
Suggestion #1|Suggestion #2|Suggestion #3
---|---|---
No worries|😞|No problem!
