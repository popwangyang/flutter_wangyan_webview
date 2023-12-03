import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterWangyanWebview extends StatelessWidget {
  static const MethodChannel _channel =
      MethodChannel('flutter_wangyan_webview');

  const FlutterWangyanWebview({Key? key}) : super(key: key);

  static const platform =
      MethodChannel('com.example.flutterwangyanwebview.methodchannel');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Widget platformView() {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'plugins.flutter.io/flutter_wangyan_webview_box',
        creationParams: const {'url': "https://www.baidu.com/"},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {},
      );
    } else {
      return Container();
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
