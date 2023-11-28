/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.barcode.spark.ui.FlutterSparkScanView;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class SparkScanPlatformViewFactory extends PlatformViewFactory {
    SparkScanModule sparkScanModule;

    public SparkScanPlatformViewFactory(SparkScanModule sparkScanModule) {
        super(StandardMessageCodec.INSTANCE);
        this.sparkScanModule = sparkScanModule;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<String, String> creationArgs = (HashMap<String, String>) args;
        String creationJson = null;

        if (creationArgs != null) {
            creationJson = creationArgs.get("SparkScanView");
        }

        return new FlutterSparkScanView(context, creationJson, this.sparkScanModule);
    }
}
