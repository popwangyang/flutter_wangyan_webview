import 'package:flutter/services.dart';
import 'package:flutter_wangyan_webview/instance_manager.dart';
import 'package:flutter_wangyan_webview/web_setting.dart';
import 'package:flutter_wangyan_webview/web_view_channel.dart';

class WebView {
  late final InstanceManager instanceManager;
  late final WebSettings webSettings;
  final WebViewMessageChannel channel;

  static MessageCodec<Object?> codec = const StandardMessageCodec();

  WebView({InstanceManager? instanceManager, required this.channel}) {
    this.instanceManager = instanceManager ?? InstanceManager.instance;
    webSettings =
        WebSettings(instanceManager: this.instanceManager, channel: channel);
    this.instanceManager.tryAddInstance(this);
  }

  int? get _webviewId => instanceManager.getInstanceId(this);

  Future<void> create() async {
    if (_webviewId != null) {
      return await webSettings.createFromInstance(webSettings, this);
    }
  }

  Future<String?> evaluateJavascript(String javascriptString) async {
    if (_webviewId != null) {
      Map<Object?, Object?>? replyMap = await channel.send(
          "flutter.wangyanWebView.webview.evaluateJavascript",
          <Object?>[_webviewId, javascriptString]);
      if (replyMap != null) {
        return replyMap['result'] as String;
      }
    }
    return null;
  }
}
