/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.utils

import android.graphics.Bitmap
import android.graphics.BitmapFactory

class ViewParser {
    fun parse(widget: ByteArray): Bitmap? {
        return try {
            BitmapFactory.decodeByteArray(widget, 0, widget.size)
        } catch (e: Exception) {
            println(e)
            null
        }
    }
}
