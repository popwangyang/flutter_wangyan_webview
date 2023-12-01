package com.example.flutter_wangyan_webview

import android.content.Context
import android.util.Log
import android.view.View
import android.webkit.WebView
import android.widget.TextView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class WyWebView(context: Context, messenger: BinaryMessenger, viewId: Int, args: Map<String, Any>?) : PlatformView, MethodChannel.MethodCallHandler {

    private val webView: WebView = WebView(context)
    private lateinit var methodChannel: MethodChannel

    init {
        args?.also {
            val url = it["url"] as String
            webView.loadUrl(url)
            webView.settings.javaScriptEnabled = true
            methodChannel = MethodChannel(messenger, "com.example.flutterwangyanwebview.methodchannel")
            methodChannel.setMethodCallHandler(this)
        }
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {
        Log.d(TAG, "dispose")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
         if(call.method == "setUrl") {
            var url = call.argument<String>("url") as String
            webView.loadUrl(url)
        } else{
            result.notImplemented()
        }
    }
}

class WyWebViewFactory(private val messenger: BinaryMessenger): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return WyWebView(context, messenger, viewId, args as Map<String, Any>?);
    }

}