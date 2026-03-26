/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.scandit.datacapture.flutter.barcode.ar.ui.BarcodeArPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.count.ui.BarcodeCountPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.find.ui.BarcodeFindPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.pick.ui.BarcodePickPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.spark.ui.SparkScanPlatformViewFactory;
import com.scandit.datacapture.flutter.core.BaseFlutterPlugin;
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter;
import com.scandit.datacapture.frameworks.barcode.BarcodeModule;
import com.scandit.datacapture.frameworks.barcode.capture.BarcodeCaptureModule;
import com.scandit.datacapture.frameworks.barcode.ar.BarcodeArModule;
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;
import com.scandit.datacapture.frameworks.barcode.generator.BarcodeGeneratorModule;
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule;
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.barcode.batch.BarcodeBatchModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

public class ScanditFlutterDataCaptureBarcodeProxyPlugin extends BaseFlutterPlugin implements FlutterPlugin, ActivityAware {
    private final static FlutterEmitter barcodeBatchEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.batch/event_channel");

    private final static FlutterEmitter sparkScanEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.spark/event_channel");

    private final static FlutterEmitter barcodeSelectionEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.selection/event_channel");

    private final static FlutterEmitter barcodeCountEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.count/event_channel");

    private final static FlutterEmitter barcodeCaptureEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.capture/event_channel");

    private final static FlutterEmitter barcodeFindEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.find/event_channel");

    private final static FlutterEmitter barcodePickEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.pick/event_channel");

    private final static FlutterEmitter barcodeArEmitter = new FlutterEmitter("com.scandit.datacapture.barcode.ar/event_channel");

    private static final AtomicInteger activePluginInstances = new AtomicInteger(0);

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.incrementAndGet();
        super.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.decrementAndGet();
        super.onDetachedFromEngine(binding);
    }

    @Override
    protected int getActivePluginInstanceCount() {
        return activePluginInstances.get();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        setupEventChannels();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        disposeEventChannels();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        disposeEventChannels();
    }

    private void setupEventChannels() {
        FlutterPluginBinding binding = getCurrentBinding();
        if (binding != null) {
            barcodePickEmitter.addChannel(binding.getBinaryMessenger());
            barcodeFindEmitter.addChannel(binding.getBinaryMessenger());
            barcodeBatchEmitter.addChannel(binding.getBinaryMessenger());
            sparkScanEmitter.addChannel(binding.getBinaryMessenger());
            barcodeSelectionEmitter.addChannel(binding.getBinaryMessenger());
            barcodeCountEmitter.addChannel(binding.getBinaryMessenger());
            barcodeCaptureEmitter.addChannel(binding.getBinaryMessenger());
            barcodeArEmitter.addChannel(binding.getBinaryMessenger());
        }
    }

    private void disposeEventChannels() {
        FlutterPluginBinding binding = getCurrentBinding();
        if (binding != null) {
            barcodePickEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeFindEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeBatchEmitter.removeChannel(binding.getBinaryMessenger());
            sparkScanEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeSelectionEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeCountEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeCaptureEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeArEmitter.removeChannel(binding.getBinaryMessenger());
        }
    }

    protected void setupMethodChannels(@NonNull FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        // Barcode method channel
        MethodChannel barcodeMethodChannel = createChannel(binding,
                BarcodeMethodHandler.METHOD_CHANNEL
        );
        barcodeMethodChannel.setMethodCallHandler(
                new BarcodeMethodHandler(serviceLocator)
        );
        registerChannel(barcodeMethodChannel);
    }

    protected void setupPlatformViewRegistry(FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodeCountView",
                new BarcodeCountPlatformViewFactory(
                        serviceLocator
                )
        );

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.SparkScanView",
                new SparkScanPlatformViewFactory(
                        serviceLocator
                )
        );

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodeFindView",
                new BarcodeFindPlatformViewFactory(
                        serviceLocator
                )
        );

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodePickView",
                new BarcodePickPlatformViewFactory(
                        serviceLocator
                )
        );

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodeArView",
                new BarcodeArPlatformViewFactory(
                        serviceLocator
                )
        );
    }

    protected void setupModules(FlutterPluginBinding binding) {
        // Barcode
        setupBarcodeModule(binding);
        // Barcode Capture
        setupBarcodeCapture(binding);
        // Barcode Count
        setupBarcodeCount(binding);
        // Barcode Selection
        setupBarcodeSelection(binding);
        // Barcode Batch
        setupBarcodeBatch(binding);
        // Spark Scan
        setupSparkScan(binding);
        // Barcode Find
        setupBarcodeFind(binding);
        // Barcode Pick
        setupBarcodePick(binding);
        // Barcode Check
        setupBarcodeAr(binding);
        // Barcode Generator
        setupBarcodeGenerator(binding);
    }

    private void setupBarcodePick(@NonNull FlutterPluginBinding binding) {
        BarcodePickModule barcodePickModule = resolveModule(BarcodePickModule.class);
        if (barcodePickModule != null) return;

        barcodePickModule = BarcodePickModule.create(barcodePickEmitter);
        barcodePickModule.onCreate(binding.getApplicationContext());

        registerModule(barcodePickModule);
    }

    private void setupBarcodeFind(@NonNull FlutterPluginBinding binding) {
        BarcodeFindModule barcodeFindModule = resolveModule(BarcodeFindModule.class);
        if (barcodeFindModule != null) return;

        barcodeFindModule = BarcodeFindModule.create(barcodeFindEmitter);
        barcodeFindModule.onCreate(binding.getApplicationContext());

        registerModule(barcodeFindModule);
    }

    private void setupBarcodeBatch(@NonNull FlutterPluginBinding binding) {
        BarcodeBatchModule barcodeBatchModule = resolveModule(BarcodeBatchModule.class);
        if (barcodeBatchModule != null) return;

        barcodeBatchModule = BarcodeBatchModule.create(barcodeBatchEmitter, null);
        barcodeBatchModule.onCreate(binding.getApplicationContext());

        registerModule(barcodeBatchModule);
    }

    private void setupSparkScan(@NonNull FlutterPluginBinding binding) {
        SparkScanModule sparkScanModule = resolveModule(SparkScanModule.class);
        if (sparkScanModule != null) return;

        sparkScanModule = SparkScanModule.create(sparkScanEmitter);
        sparkScanModule.onCreate(binding.getApplicationContext());

        registerModule(sparkScanModule);
    }

    private void setupBarcodeSelection(@NonNull FlutterPluginBinding binding) {
        BarcodeSelectionModule barcodeSelectionModule = resolveModule(BarcodeSelectionModule.class);
        if (barcodeSelectionModule != null) return;

        barcodeSelectionModule = BarcodeSelectionModule.create(barcodeSelectionEmitter);
        barcodeSelectionModule.onCreate(binding.getApplicationContext());

        registerModule(barcodeSelectionModule);
    }

    private void setupBarcodeCount(@NonNull FlutterPluginBinding binding) {
        BarcodeCountModule barcodeCountModule = resolveModule(BarcodeCountModule.class);
        if (barcodeCountModule != null) return;

        barcodeCountModule = BarcodeCountModule.create(barcodeCountEmitter);
        barcodeCountModule.onCreate(binding.getApplicationContext());

        registerModule(barcodeCountModule);
    }

    private void setupBarcodeCapture(@NonNull FlutterPluginBinding binding) {
        BarcodeCaptureModule barcodeCaptureModule = resolveModule(BarcodeCaptureModule.class);
        if (barcodeCaptureModule != null) return;

        barcodeCaptureModule = BarcodeCaptureModule.create(
                barcodeCaptureEmitter
        );
        barcodeCaptureModule.onCreate(binding.getApplicationContext());
        registerModule(barcodeCaptureModule);
    }

    private void setupBarcodeModule(@NonNull FlutterPluginBinding binding) {
        BarcodeModule barcodeModule = resolveModule(BarcodeModule.class);
        if (barcodeModule != null) return;

        barcodeModule = new BarcodeModule();
        barcodeModule.onCreate(binding.getApplicationContext());
        registerModule(barcodeModule);
    }

    private void setupBarcodeAr(@NonNull FlutterPluginBinding binding) {
        BarcodeArModule module = resolveModule(BarcodeArModule.class);
        if (module != null) return;

        module = BarcodeArModule.create(barcodeArEmitter);
        module.onCreate(binding.getApplicationContext());
        registerModule(module);
    }

    private void setupBarcodeGenerator(@NonNull FlutterPluginBinding binding) {
        BarcodeGeneratorModule module = resolveModule(BarcodeGeneratorModule.class);
        if (module != null) return;

        module = BarcodeGeneratorModule.create();
        module.onCreate(binding.getApplicationContext());
        registerModule(module);
    }

    @VisibleForTesting
    public static void resetActiveInstances() {
        activePluginInstances.set(0);
    }
}
