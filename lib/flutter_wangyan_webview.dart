import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wangyan_webview/android_webview_widget.dart';
import 'package:flutter_wangyan_webview/web_view.dart';
import 'package:flutter_wangyan_webview/web_view_channel.dart';

typedef WebViewCreatedCallback = void Function(WebViewController controller);

class WebViewController {
  final WebView _webView = WebView(channel: WebViewMessageChannel());

  WebViewController();

  Future<void> init() async {
    return await _webView.create();
  }

  Future<void> setJavaScriptEnabled(bool flag) async {
    return await _webView.webSettings.setJavaScriptEnabled(flag);
  }

  Future<String?> evaluateJavascript(String javascriptString) async {
    return _webView.evaluateJavascript(javascriptString);
  }
}

class FlutterWangyanWebview extends StatelessWidget {
  static const MethodChannel _channel =
      MethodChannel('flutter_wangyan_webview');

  final bool? javaScriptEnabled;

  final WebViewCreatedCallback? onWebViewCreated;

  const FlutterWangyanWebview(
      {Key? key, this.javaScriptEnabled, this.onWebViewCreated})
      : super(key: key);

  static const platform =
      MethodChannel('com.example.flutterwangyanwebview.methodchannel');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Widget platformView() {
    if (Platform.isIOS) {
      return Container();
    } else {
      return AndroidWebViewWidget(
        viewType: "plugins.flutter.io/flutter_wangyan_webview_box",
        javaScriptEnabled: javaScriptEnabled ?? false,
        onWebViewCreated: onWebViewCreated,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: platformView(),
        ),
      ),
    );
  }
}
