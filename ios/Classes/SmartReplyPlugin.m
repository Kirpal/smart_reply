#import "SmartReplyPlugin.h"
#if __has_include(<smart_reply/smart_reply-Swift.h>)
#import <smart_reply/smart_reply-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "smart_reply-Swift.h"
#endif

@implementation SmartReplyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmartReplyPlugin registerWithRegistrar:registrar];
}
@end
