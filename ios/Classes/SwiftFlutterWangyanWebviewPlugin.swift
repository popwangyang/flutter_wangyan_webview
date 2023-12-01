import Flutter
import UIKit

public class SwiftFlutterWangyanWebviewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_wangyan_webview", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterWangyanWebviewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
