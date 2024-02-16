/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.pick.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.widget.FrameLayout
import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule
import io.flutter.plugin.platform.PlatformView

@SuppressLint("ViewConstructor")
class FlutterBarcodePickView(
    context: Context,
    jsonString: String,
    private val barcodePickModule: BarcodePickModule
) : FlutterBasePlatformView(context) {

    init {
        barcodePickModule.addViewToContainer(this, jsonString, FlutterLogInsteadOfResult())
    }

    override fun getView(): View = this

    override fun dispose() {
        super.dispose()
        barcodePickModule.viewDisposed()
        removeAllViews()
    }

    override fun onCurrentTopViewVisibleChanged(topViewId: String?) {
        if (topViewId == viewId) {
            dispatchWindowVisibilityChanged(visibility)
        }
    }
}
