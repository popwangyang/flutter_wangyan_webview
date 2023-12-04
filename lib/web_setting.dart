import 'package:flutter/services.dart';
import 'package:flutter_wangyan_webview/instance_manager.dart';
import 'package:flutter_wangyan_webview/web_view.dart';
import 'package:flutter_wangyan_webview/web_view_channel.dart';

class WebSettings {
  final InstanceManager instanceManager;

  final WebViewMessageChannel channel;

  static MessageCodec<Object?> codec = const StandardMessageCodec();

  WebSettings({required this.instanceManager, required this.channel});

  int? get _settingsId => instanceManager.getInstanceId(this);

  Future<void> createFromInstance(WebSettings settings, WebView webView) async {
    int? settingsId = instanceManager.tryAddInstance(settings);
    int? webViewId = instanceManager.getInstanceId(webView);
    if (settingsId != null) {
      channel.send("flutter.wangyanWebView.webSettings.create",
          <Object?>[settingsId, webViewId]);
    }
  }

  Future<void> setJavaScriptEnabled(bool flag) async {
    if (_settingsId != null) {
      await channel.send(
          "flutter.wangyanWebView.webSettings.setJavaScriptEnabled",
          <Object?>[_settingsId, flag]);
    }
  }
}
