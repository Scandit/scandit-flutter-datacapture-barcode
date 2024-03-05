package com.scandit.datacapture.flutter.barcode.count.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule
import io.flutter.plugin.platform.PlatformView

@SuppressLint("ViewConstructor")
class FlutterBarcodeCountView(
    context: Context,
    jsonString: String,
    private val barcodeModule: BarcodeCountModule
) : FrameLayout(context), PlatformView {

    init {
        barcodeModule.getViewFromJson(jsonString)?.let {
            addView(it, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        }
    }

    override fun getView(): View = this

    override fun dispose() {
        removeAllViews()
        barcodeModule.disposeBarcodeCountView()
    }
}
