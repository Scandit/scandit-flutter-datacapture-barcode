/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode.utils

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64

object ViewParser {
    fun parse(base64EncodedWidget: String): Bitmap? {
        return try {
            Base64.decode(base64EncodedWidget, Base64.DEFAULT)?.let {
                BitmapFactory.decodeByteArray(it, 0, it.size)
            }
        } catch (e: Exception) {
            println(e)
            null
        }
    }
}
