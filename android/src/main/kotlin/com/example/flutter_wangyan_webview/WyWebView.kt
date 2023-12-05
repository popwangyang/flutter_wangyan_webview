package com.example.flutter_wangyan_webview

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.util.Log
import android.view.View
import android.webkit.WebSettings
import android.webkit.WebView
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
        Log.d(TAG, "flutter.wangyanWebView.webSettings.create")
        BasicMessageChannel(
            messenger,
            "flutter.wangyanWebView.webSettings.create",
            StandardMessageCodec()
        ).setMessageHandler{ message, reply ->
            val wrapped: MutableMap<String, Any?> = HashMap()
            try {
                val args = message as ArrayList<*>
                val settingsId = (args[0] as Long?) ?: throw NullPointerException("instanceIdArg unexpectedly null.")
                val webViewId = (args[1] as Long?) ?: throw NullPointerException("instanceIdArg unexpectedly null.")
                InstanceManager.addInstance(this.settings, settingsId)
                InstanceManager.addInstance(this, webViewId)
                wrapped["result"] = null
            } catch (exception: Error) {
                wrapped["error"] = wrapError(exception)
            } catch (exception: RuntimeException) {
                wrapped["error"] = wrapError(exception)
            }
            reply.reply(wrapped)
        }

        BasicMessageChannel(
            messenger,
            "flutter.wangyanWebView.webSettings.setJavaScriptEnabled",
            StandardMessageCodec()
        ).setMessageHandler{ message, reply ->
            val wrapped: MutableMap<String, Any?> = HashMap()
            try {
                val args = message as ArrayList<*>
                val settingsId = (args[0] as Long?) ?: throw NullPointerException("instanceIdArg unexpectedly null.")
                val flag = (args[0] as Boolean?) ?: throw NullPointerException("javaScriptEnabledArg unexpectedly null.")
                val settings = InstanceManager.getInstance(settingsId) as WebSettings
                Log.d(TAG, flag.toString())
                settings.javaScriptEnabled = flag
                wrapped["result"] = null
            } catch (exception: Error) {
                wrapped["error"] = wrapError(exception)
            } catch (exception: RuntimeException) {
                wrapped["error"] = wrapError(exception)
            }
            reply.reply(wrapped)
        }
    }

    private fun wrapError(exception: Throwable): Map<String, Any>? {
        val errorMap: MutableMap<String, Any> = HashMap()
        errorMap["message"] = exception.toString()
        errorMap["code"] = exception.javaClass.simpleName
        errorMap["details"] =
            "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
        return errorMap
    }

}


