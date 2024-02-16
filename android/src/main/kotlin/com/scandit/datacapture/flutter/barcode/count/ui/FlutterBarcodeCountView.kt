package com.scandit.datacapture.flutter.barcode.count.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule
import io.flutter.plugin.platform.PlatformView
import java.util.UUID

@SuppressLint("ViewConstructor")
class FlutterBarcodeCountView(
    context: Context,
    jsonString: String,
    private val barcodeModule: BarcodeCountModule
) : FlutterBasePlatformView(context) {

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

    override fun onCurrentTopViewVisibleChanged(topViewId: String?) {
        if (topViewId == viewId) {
            dispatchWindowVisibilityChanged(visibility)
        }
    }
}
