package com.example.carfinder

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.view.View
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativePlatformWebView(context: Context, viewIdentifier: Int, creationParameters: Map<String?, Any?>?) : PlatformView {
    private val browserEngine: WebView = WebView(context).apply {
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        settings.loadWithOverviewMode = true
        settings.useWideViewPort = true
        settings.cacheMode = WebSettings.LOAD_DEFAULT
        settings.userAgentString = "Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36"
        webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, urlString: String?): Boolean {
                if (urlString != null) {
                    view?.loadUrl(urlString)
                }
                return true
            }
        }
        val targetAddress = creationParameters?.get("url") as? String ?: "https://www.copart.com"
        loadUrl(targetAddress)
    }

    override fun getView(): View = browserEngine

    override fun dispose() {
        browserEngine.destroy()
    }
}

class NativePlatformWebViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewIdentifier: Int, args: Any?): PlatformView {
        val parametersMap = args as? Map<String?, Any?>
        return NativePlatformWebView(context, viewIdentifier, parametersMap)
    }
}

class MainActivity : FlutterActivity() {
    private val channelName = "carfinder/native_bridge"
    private var callbackChannelResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        flutterEngine.platformViewsController.registry.registerViewFactory(
            "carfinder/web_platform_view",
            NativePlatformWebViewFactory()
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "openGallery" -> {
                    callbackChannelResult = result
                    val galleryIntent = Intent(Intent.ACTION_GET_CONTENT).apply {
                        type = "image/*"
                        putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("image/*", "application/pdf"))
                        addCategory(Intent.CATEGORY_OPENABLE)
                    }
                    startActivityForResult(Intent.createChooser(galleryIntent, "Виберіть фото документа"), 2001)
                }
                "openBrowser" -> {
                    val targetUrl = call.argument<String>("url") ?: ""
                    if (targetUrl.isNotEmpty()) {
                        val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse(targetUrl)).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(browserIntent)
                        result.success(true)
                    } else {
                        result.error("EMPTY_URL", "URL is empty", null)
                    }
                }
                "saveStoragePayload" -> {
                    val payloadJson = call.argument<String>("json") ?: "{}"
                    val preferencesStorage = getSharedPreferences("carfinder_prefs", Context.MODE_PRIVATE)
                    preferencesStorage.edit().putString("storage_payload", payloadJson).apply()
                    result.success(true)
                }
                "readStoragePayload" -> {
                    val preferencesStorage = getSharedPreferences("carfinder_prefs", Context.MODE_PRIVATE)
                    val payloadJson = preferencesStorage.getString("storage_payload", "{}") ?: "{}"
                    result.success(payloadJson)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intentResult: Intent?) {
        super.onActivityResult(requestCode, resultCode, intentResult)
        if (requestCode == 2001) {
            val pickedUri = intentResult?.getData()
            if (resultCode == Activity.RESULT_OK && pickedUri != null) {
                val resolvedName = pickedUri.lastPathSegment ?: "document_photo.jpg"
                callbackChannelResult?.success(resolvedName)
            } else {
                callbackChannelResult?.success(null)
            }
            callbackChannelResult = null
        }
    }
}
