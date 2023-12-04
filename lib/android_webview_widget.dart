import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wangyan_webview/instance.dart';

class AndroidWebViewWidget extends StatefulWidget {
  const AndroidWebViewWidget({Key? key, required this.viewType})
      : super(key: key);

  final String viewType;

  @override
  State<AndroidWebViewWidget> createState() => _AndroidWebViewWidgetState();
}

class _AndroidWebViewWidgetState extends State<AndroidWebViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class WebViewMessageChannel {
  late final MessageCodec codec;
  final BinaryMessenger binaryMessenger;
  WebViewMessageChannel({MessageCodec? codec, required this.binaryMessenger}) {
    this.codec = codec ?? const StandardMessageCodec();
  }

  Future<Map<Object?, Object?>?> send(
    String name,
    dynamic message,
  ) async {
    final BasicMessageChannel channel =
        BasicMessageChannel(name, codec, binaryMessenger: binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(message) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return replyMap;
    }
  }
}

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

  int? get _webviewId => instanceManager.tryAddInstance(this);

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

class WebSettings {
  final InstanceManager instanceManager;

  final WebViewMessageChannel channel;

  static MessageCodec<Object?> codec = const StandardMessageCodec();

  WebSettings({required this.instanceManager, required this.channel});

  Future<void> createFromInstance(WebSettings settings, WebView webView) async {
    int? settingsId = instanceManager.tryAddInstance(settings);
    int? webViewId = instanceManager.getInstanceId(webView);
    if (settingsId != null) {
      channel.send("flutter.wangyanWebView.webSettings.create",
          <Object?>[settingsId, webViewId]);
    }
  }

  // Future<void>

}

class AndroidWebViewController {}
