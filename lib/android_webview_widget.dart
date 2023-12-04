import 'package:flutter/material.dart';
import 'package:flutter_wangyan_webview/flutter_wangyan_webview.dart';

class AndroidWebViewWidget extends StatefulWidget {
  const AndroidWebViewWidget(
      {Key? key,
      required this.viewType,
      this.initialUrl = "https://www.gzsle.com",
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
    controller.init().then((value) {
      controller.setJavaScriptEnabled(widget.javaScriptEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: widget.viewType,
      creationParams: {"initialUrl": widget.initialUrl},
      onPlatformViewCreated: (v) {
        if (widget.onWebViewCreated != null) {
          widget.onWebViewCreated!(controller);
        }
      },
    );
  }
}
