/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.scandit.datacapture.flutter.barcode.ar.ui.BarcodeArPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.capture.BarcodeCaptureMethodHandler;
import com.scandit.datacapture.flutter.barcode.ar.BarcodeArMethodHandler;
import com.scandit.datacapture.flutter.barcode.count.BarcodeCountMethodHandler;
import com.scandit.datacapture.flutter.barcode.find.BarcodeFindMethodHandler;
import com.scandit.datacapture.flutter.barcode.generator.BarcodeGeneratorMethodHandler;
import com.scandit.datacapture.flutter.barcode.pick.BarcodePickMethodHandler;
import com.scandit.datacapture.flutter.barcode.selection.BarcodeSelectionMethodHandler;
import com.scandit.datacapture.flutter.barcode.spark.SparkScanMethodHandler;
import com.scandit.datacapture.flutter.barcode.batch.BarcodeBatchMethodHandler;
import com.scandit.datacapture.flutter.barcode.count.ui.BarcodeCountPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.find.ui.BarcodeFindPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.pick.ui.BarcodePickPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.spark.ui.SparkScanPlatformViewFactory;
import com.scandit.datacapture.flutter.core.BaseFlutterPlugin;
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter;
import com.scandit.datacapture.frameworks.barcode.BarcodeModule;
import com.scandit.datacapture.frameworks.barcode.capture.BarcodeCaptureModule;
import com.scandit.datacapture.frameworks.barcode.capture.listeners.FrameworksBarcodeCaptureListener;
import com.scandit.datacapture.frameworks.barcode.ar.BarcodeArModule;
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;
import com.scandit.datacapture.frameworks.barcode.find.listeners.FrameworksBarcodeFindListener;
import com.scandit.datacapture.frameworks.barcode.find.listeners.FrameworksBarcodeFindViewUiListener;
import com.scandit.datacapture.frameworks.barcode.find.transformer.FrameworksBarcodeFindTransformer;
import com.scandit.datacapture.frameworks.barcode.generator.BarcodeGeneratorModule;
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule;
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule;
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionAimedBrushProvider;
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionListener;
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionTrackedBrushProvider;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.barcode.batch.BarcodeBatchModule;
import com.scandit.datacapture.frameworks.barcode.batch.listeners.FrameworksBarcodeBatchAdvancedOverlayListener;
import com.scandit.datacapture.frameworks.barcode.batch.listeners.FrameworksBarcodeBatchBasicOverlayListener;
import com.scandit.datacapture.frameworks.barcode.batch.listeners.FrameworksBarcodeBatchListener;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

public class ScanditFlutterDataCaptureBarcodeProxyPlugin extends BaseFlutterPlugin implements FlutterPlugin, ActivityAware {
    private final static FlutterEmitter barcodeBatchEmitter = new FlutterEmitter(BarcodeBatchMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter sparkScanEmitter = new FlutterEmitter(SparkScanMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeSelectionEmitter = new FlutterEmitter(BarcodeSelectionMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeCountEmitter = new FlutterEmitter(BarcodeCountMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeCaptureEmitter = new FlutterEmitter(BarcodeCaptureMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeFindEmitter = new FlutterEmitter(BarcodeFindMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodePickEmitter = new FlutterEmitter(BarcodePickMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeArEmitter = new FlutterEmitter(BarcodeArMethodHandler.EVENT_CHANNEL_NAME);

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

        // Barcode capture method channel
        MethodChannel barcodeCaptureMethodChannel = createChannel(binding,
                BarcodeCaptureMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeCaptureMethodChannel.setMethodCallHandler(
                new BarcodeCaptureMethodHandler(serviceLocator)
        );
        registerChannel(barcodeCaptureMethodChannel);

        // Barcode selection method channel
        MethodChannel barcodeSelectionMethodChannel = createChannel(binding,
                BarcodeSelectionMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeSelectionMethodChannel.setMethodCallHandler(new BarcodeSelectionMethodHandler(serviceLocator));
        registerChannel(barcodeSelectionMethodChannel);

        // Barcode count method channel
        MethodChannel barcodeCountMethodChannel = createChannel(binding,
                BarcodeCountMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeCountMethodChannel.setMethodCallHandler(new BarcodeCountMethodHandler(serviceLocator));
        registerChannel(barcodeCountMethodChannel);

        // Barcode batch method channel
        MethodChannel barcodeBatchMethodChannel = createChannel(binding,
                BarcodeBatchMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeBatchMethodChannel.setMethodCallHandler(
                new BarcodeBatchMethodHandler(serviceLocator)
        );
        registerChannel(barcodeBatchMethodChannel);

        // SparkScan method channel
        MethodChannel sparkScanMethodChannel = createChannel(binding,
                SparkScanMethodHandler.METHOD_CHANNEL_NAME
        );
        sparkScanMethodChannel.setMethodCallHandler(new SparkScanMethodHandler(serviceLocator));
        registerChannel(sparkScanMethodChannel);

        // Barcode find method channel
        MethodChannel barcodeFindMethodChannel = createChannel(binding,
                BarcodeFindMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeFindMethodChannel.setMethodCallHandler(new BarcodeFindMethodHandler(serviceLocator));
        registerChannel(barcodeFindMethodChannel);

        // Barcode Pick method channel
        MethodChannel barcodePickMethodChannel = createChannel(binding,
                BarcodePickMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodePickMethodChannel.setMethodCallHandler(new BarcodePickMethodHandler(serviceLocator));
        registerChannel(barcodePickMethodChannel);

        // Barcode check method channel
        MethodChannel barcodeCheckMethodChannel = createChannel(
                binding,
                BarcodeArMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeCheckMethodChannel.setMethodCallHandler(new BarcodeArMethodHandler(serviceLocator));
        registerChannel(barcodeCheckMethodChannel);

        // Barcode generator
        MethodChannel barcodeGeneratorMethodChannel = createChannel(
                binding,
                BarcodeGeneratorMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeGeneratorMethodChannel.setMethodCallHandler(new BarcodeGeneratorMethodHandler(serviceLocator));
        registerChannel(barcodeGeneratorMethodChannel);
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

        barcodeBatchModule = BarcodeBatchModule.create(barcodeBatchEmitter);
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

        barcodeSelectionModule = BarcodeSelectionModule.create(
                FrameworksBarcodeSelectionListener.create(barcodeSelectionEmitter),
                new FrameworksBarcodeSelectionAimedBrushProvider(barcodeSelectionEmitter),
                new FrameworksBarcodeSelectionTrackedBrushProvider(barcodeSelectionEmitter)
        );
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
                FrameworksBarcodeCaptureListener.create(barcodeCaptureEmitter)
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
