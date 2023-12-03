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

class WebView {}

class WebSettings {
  late final InstanceManager instanceManager;
  final BinaryMessenger? binaryMessenger;

  static MessageCodec<Object?> codec = const StandardMessageCodec();

  WebSettings({InstanceManager? instanceManager, this.binaryMessenger}) {
    this.instanceManager = instanceManager ?? InstanceManager.instance;
  }

  Future<void> createFromInstance(WebSettings settings, WebView webView) async {
    int? settingsId = instanceManager.tryAddInstance(settings);
    int? webViewId = instanceManager.getInstanceId(webView);
    if (settingsId != null) {
      final BasicMessageChannel channel = BasicMessageChannel(
          "flutter.wangyanWebView.webSettings.create", codec,
          binaryMessenger: binaryMessenger);
      final Map<Object?, Object?>? replyMap = await channel
          .send(<Object?>[settingsId, webViewId]) as Map<Object?, Object?>?;
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
        return;
      }
    }
  }
}

class AndroidWebViewController {}
