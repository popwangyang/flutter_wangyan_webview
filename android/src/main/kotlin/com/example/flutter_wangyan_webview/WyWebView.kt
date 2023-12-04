package com.example.flutter_wangyan_webview

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.util.Log
import android.view.View
import android.webkit.WebView
import android.widget.TextView
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

@RequiresApi(Build.VERSION_CODES.KITKAT)
@SuppressLint("SetJavaScriptEnabled")
class WyWebView(context: Context, messenger: BinaryMessenger, viewId: Int, args: Map<String, Any>?) : PlatformView, MethodChannel.MethodCallHandler {

    private val webView: WebView = MyWebView(context, messenger)
    private lateinit var methodChannel: MethodChannel

    init {
        args?.also {
            val url = it["initialUrl"] as String
            webView.loadUrl(url)
//            webView.settings.javaScriptEnabled = true
//            webView.evaluateJavascript("lll"){
//
//            }
//            methodChannel = MethodChannel(messenger, "com.example.flutterwangyanwebview.methodchannel")
//            methodChannel.setMethodCallHandler(this)
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

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return WyWebView(context, messenger, viewId, args as Map<String, Any>?);
    }

}

class MyWebView(context: Context, messenger: BinaryMessenger): WebView(context) {

    init {
        MethodChannel(messenger, "flutter.wangyanWebView.webSettings.create").setMethodCallHandler { call, result ->
            print(call.arguments)
        }
    }

}


