/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.spark.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule
import io.flutter.embedding.android.FlutterView
import io.flutter.plugin.platform.PlatformView

@SuppressLint("ViewConstructor")
class FlutterSparkScanView(
    context: Context,
    private val jsonString: String,
    private val sparkScanModule: SparkScanModule
) : FlutterBasePlatformView(context) {
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        val parentView = (this.parent as View)
        val flutterView = getFlutterView(this.parent as View)
        sparkScanModule.addViewToContainer(flutterView, jsonString, FlutterLogInsteadOfResult())
        sparkScanModule.sparkScanView?.layoutParams = parentView.layoutParams
        sparkScanModule.sparkScanView?.requestLayout()
    }

    private fun getFlutterView(parent: View): FlutterView {
        if (parent is FlutterView) return parent
        return getFlutterView(parent.parent as View)
    }

    override fun getView(): View = this

    override fun dispose() {
        super.dispose()
        sparkScanModule.disposeView()
    }

    override fun onCurrentTopViewVisibleChanged(topViewId: String?) {
        if (topViewId == viewId) {
            sparkScanModule.sparkScanView?.let {
                it.dispatchWindowVisibilityChanged(it.visibility)
            }
        }
    }
}
