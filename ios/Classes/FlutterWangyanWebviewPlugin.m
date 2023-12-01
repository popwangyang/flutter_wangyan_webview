#import "FlutterWangyanWebviewPlugin.h"
#if __has_include(<flutter_wangyan_webview/flutter_wangyan_webview-Swift.h>)
#import <flutter_wangyan_webview/flutter_wangyan_webview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_wangyan_webview-Swift.h"
#endif

@implementation FlutterWangyanWebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterWangyanWebviewPlugin registerWithRegistrar:registrar];
}
@end
