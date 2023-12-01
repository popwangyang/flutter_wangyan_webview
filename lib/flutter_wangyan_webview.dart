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
      return const AndroidView(
        viewType: 'plugins.flutter.io/flutter_wangyan_webview_box',
        creationParams: {'text': "Flutter传给AndroidTextView的参数"},
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter"),
        ),
        body: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       platform.invokeMethod("setText", {'name': "张三", 'age': 18});
            //     },
            //     child: const Text("传递参数给原生view")),
            Expanded(
                child: Center(
              child: platformView(),
            )),
          ],
        ),
      ),
    );
  }
}
