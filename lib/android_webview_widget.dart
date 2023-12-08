import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wangyan_webview/flutter_wangyan_webview.dart';

class AndroidWebViewWidget extends StatefulWidget {
  const AndroidWebViewWidget(
      {Key? key,
      required this.viewType,
      this.initialUrl =
          "https://testh5.gzsle.com/reportRepairFreezer?type=reportRepairFreezer&sn=dseweefef",
      this.javaScriptEnabled = true,
      this.onWebViewCreated})
      : super(key: key);

  final String viewType;
  final String initialUrl;
  final bool javaScriptEnabled;
  final WebViewCreatedCallback? onWebViewCreated;

  @override
  State<AndroidWebViewWidget> createState() => _AndroidWebViewWidgetState();
}

class _AndroidWebViewWidgetState extends State<AndroidWebViewWidget> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: widget.viewType,
      creationParams: {"initialUrl": widget.initialUrl},
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (v) {
        print("wangyanwebview:onPlatformViewCreated");
        controller.init().then((value) {
          print("wangyanwebview:初始化");
          controller.setJavaScriptEnabled(widget.javaScriptEnabled);
        });
        if (widget.onWebViewCreated != null) {
          widget.onWebViewCreated!(controller);
        }
      },
    );
  }
}
