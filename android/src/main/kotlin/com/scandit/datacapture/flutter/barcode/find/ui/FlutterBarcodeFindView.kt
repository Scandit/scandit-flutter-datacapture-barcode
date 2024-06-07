/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.find.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import com.scandit.datacapture.flutter.core.ui.FlutterBasePlatformView
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule

@SuppressLint("ViewConstructor")
class FlutterBarcodeFindView(
    context: Context,
    jsonString: String,
    private val barcodeFindModule: BarcodeFindModule
) : FlutterBasePlatformView(context) {

    init {
        barcodeFindModule.addViewToContainer(this, jsonString, FlutterLogInsteadOfResult())
    }

    override fun getView(): View = this

    override fun dispose() {
        super.dispose()
        barcodeFindModule.viewDisposed()
        removeAllViews()
    }

    override fun onCurrentTopViewVisibleChanged(topViewId: String?) {
        if (topViewId == viewId) {
            dispatchWindowVisibilityChanged(visibility)
        }
    }
}
