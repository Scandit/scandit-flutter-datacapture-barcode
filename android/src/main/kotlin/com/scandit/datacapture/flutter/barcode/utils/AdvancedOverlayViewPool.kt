/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.utils

import android.content.Context
import android.graphics.Bitmap
import android.widget.ImageView
import com.scandit.datacapture.barcode.tracking.data.TrackedBarcode

class AdvancedOverlayViewPool(private val context: Context) {
    private val views: MutableMap<Int, ImageView> = mutableMapOf()

    @Synchronized
    fun getOrCreateView(barcode: TrackedBarcode, bitmap: Bitmap): ImageView =
        views.getOrPut(barcode.identifier, ::createView).also {
            it.setImageBitmap(bitmap)
        }

    @Synchronized
    fun removeView(barcode: TrackedBarcode) {
        views.remove(barcode.identifier)
    }

    @Synchronized
    fun clear() = views.clear()

    private fun createView() = ImageView(context)
}
