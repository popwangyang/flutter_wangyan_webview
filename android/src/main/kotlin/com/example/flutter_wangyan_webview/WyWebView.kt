package com.example.flutter_wangyan_webview

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.util.AttributeSet
import android.util.Log
import android.view.View
import android.webkit.WebSettings
import android.webkit.WebView
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.*
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

@RequiresApi(Build.VERSION_CODES.O)
@SuppressLint("SetJavaScriptEnabled")
class WyWebView(context: Context, messenger: BinaryMessenger, viewId: Int, args: Map<String, Any>?) : PlatformView, MethodChannel.MethodCallHandler {

    private val webView: WebView = WebView(context)
    private lateinit var methodChannel: MethodChannel

    init {
        args?.also {
            val url = it["initialUrl"] as String
            setup(messenger)
            Log.d(TAG, url)
            webView.loadUrl(url)
            webView.id = viewId
            webView.settings.javaScriptEnabled = true
            webView.isFocusable = true
            webView.isFocusableInTouchMode = true
//            webView.settings.javaScriptEnabled = true
//            webView.evaluateJavascript("lll"){
//
//            }
//            methodChannel = MethodChannel(messenger, "com.example.flutterwangyanwebview.methodchannel")
//            methodChannel.setMethodCallHandler(this)
        }
    }

    private fun setup(messenger: BinaryMessenger) {
        Log.d(TAG, "setup")
        BasicMessageChannel(
            messenger,
            "flutter.wangyanWebView.webSettings.create",
            StandardMessageCodec()
        ).setMessageHandler{ message, reply ->
            val wrapped: MutableMap<String, Any?> = HashMap()
            Log.d(TAG, "flutter.wangyanWebView.webSettings.create")
            try {
                val args = message as ArrayList<*>
                val settingsId = (args[0] as Int?)?.toLong()  ?: throw NullPointerException("instanceIdArg unexpectedly null.")
                val webViewId = (args[1] as Int?)?.toLong()  ?: throw NullPointerException("instanceIdArg unexpectedly null.")
                InstanceManager.addInstance(webView.settings, settingsId)
                InstanceManager.addInstance(webView, webViewId)
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
            Log.d(TAG, "flutter.wangyanWebView.webSettings.setJavaScriptEnabled")
            try {
                val args = message as ArrayList<*>

                val settingsId = (args[0] as Int?)?.toLong() ?: throw NullPointerException("instanceIdArg unexpectedly null.")
                val flag = (args[1] as Boolean?) ?: throw NullPointerException("javaScriptEnabledArg unexpectedly null.")
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

    private fun wrapError(exception: Throwable): Map<String, Any>? {
        val errorMap: MutableMap<String, Any> = HashMap()
        errorMap["message"] = exception.toString()
        errorMap["code"] = exception.javaClass.simpleName
        errorMap["details"] =
            "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
        return errorMap
    }

}

class WyWebViewFactory(private val messenger: BinaryMessenger): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return WyWebView(context, messenger, viewId, args as Map<String, Any>?);
    }

}

