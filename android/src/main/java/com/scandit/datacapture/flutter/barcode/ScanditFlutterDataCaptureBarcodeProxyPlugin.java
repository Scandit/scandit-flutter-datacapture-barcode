/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.barcode.capture.BarcodeCaptureMethodHandler;
import com.scandit.datacapture.flutter.barcode.check.BarcodeCheckMethodHandler;
import com.scandit.datacapture.flutter.barcode.check.ui.BarcodeCheckPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.count.BarcodeCountMethodHandler;
import com.scandit.datacapture.flutter.barcode.find.BarcodeFindMethodHandler;
import com.scandit.datacapture.flutter.barcode.pick.BarcodePickMethodHandler;
import com.scandit.datacapture.flutter.barcode.selection.BarcodeSelectionMethodHandler;
import com.scandit.datacapture.flutter.barcode.spark.SparkScanMethodHandler;
import com.scandit.datacapture.flutter.barcode.batch.BarcodeBatchMethodHandler;
import com.scandit.datacapture.flutter.barcode.count.ui.BarcodeCountPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.find.ui.BarcodeFindPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.pick.ui.BarcodePickPlatformViewFactory;
import com.scandit.datacapture.flutter.barcode.spark.ui.SparkScanPlatformViewFactory;
import com.scandit.datacapture.flutter.core.extensions.MethodChannelExtensions;
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter;
import com.scandit.datacapture.frameworks.barcode.BarcodeModule;
import com.scandit.datacapture.frameworks.barcode.capture.BarcodeCaptureModule;
import com.scandit.datacapture.frameworks.barcode.capture.listeners.FrameworksBarcodeCaptureListener;
import com.scandit.datacapture.frameworks.barcode.check.BarcodeCheckModule;
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule;
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule;
import com.scandit.datacapture.frameworks.barcode.find.listeners.FrameworksBarcodeFindListener;
import com.scandit.datacapture.frameworks.barcode.find.listeners.FrameworksBarcodeFindViewUiListener;
import com.scandit.datacapture.frameworks.barcode.find.transformer.FrameworksBarcodeFindTransformer;
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule;
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule;
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionAimedBrushProvider;
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionListener;
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionTrackedBrushProvider;
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule;
import com.scandit.datacapture.frameworks.barcode.spark.delegates.FrameworksSparkScanFeedbackDelegate;
import com.scandit.datacapture.frameworks.barcode.spark.listeners.FrameworksSparkScanListener;
import com.scandit.datacapture.frameworks.barcode.spark.listeners.FrameworksSparkScanViewUiListener;
import com.scandit.datacapture.frameworks.barcode.batch.BarcodeBatchModule;
import com.scandit.datacapture.frameworks.barcode.batch.listeners.FrameworksBarcodeBatchAdvancedOverlayListener;
import com.scandit.datacapture.frameworks.barcode.batch.listeners.FrameworksBarcodeBatchBasicOverlayListener;
import com.scandit.datacapture.frameworks.barcode.batch.listeners.FrameworksBarcodeBatchListener;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.DefaultServiceLocator;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.lang.ref.WeakReference;
import java.util.concurrent.locks.ReentrantLock;

public class ScanditFlutterDataCaptureBarcodeProxyPlugin implements
        FlutterPlugin,
        MethodCallHandler,
        ActivityAware {

    private static final ReentrantLock lock = new ReentrantLock();

    private final static FlutterEmitter barcodeBatchEmitter = new FlutterEmitter(BarcodeBatchMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter sparkScanEmitter = new FlutterEmitter(SparkScanMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeSelectionEmitter = new FlutterEmitter(BarcodeSelectionMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeCountEmitter = new FlutterEmitter(BarcodeCountMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeCaptureEmitter = new FlutterEmitter(BarcodeCaptureMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeFindEmitter = new FlutterEmitter(BarcodeFindMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodePickEmitter = new FlutterEmitter(BarcodePickMethodHandler.EVENT_CHANNEL_NAME);

    private final static FlutterEmitter barcodeCheckEmitter = new FlutterEmitter(BarcodeCheckMethodHandler.EVENT_CHANNEL_NAME);

    private final ServiceLocator<FrameworkModule> serviceLocator = DefaultServiceLocator.getInstance();

    private MethodChannel barcodeMethodChannel;

    private MethodChannel barcodeCaptureMethodChannel;

    private MethodChannel barcodeCountMethodChannel;

    private MethodChannel barcodeSelectionMethodChannel;

    private MethodChannel barcodeBatchMethodChannel;

    private MethodChannel sparkScanMethodChannel;

    private MethodChannel barcodeFindMethodChannel;

    private MethodChannel barcodePickMethodChannel;

    private MethodChannel barcodeCheckMethodChannel;

    private WeakReference<FlutterPluginBinding> flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        flutterPluginBinding = new WeakReference<>(binding);
        setupModules(binding);
        setupMethodChannels(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        flutterPluginBinding = new WeakReference<>(null);
        disposeMethodChannels();
        disposeModules();
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
        FlutterPluginBinding binding = flutterPluginBinding.get();
        if (binding != null) {
            barcodePickEmitter.addChannel(binding.getBinaryMessenger());
            barcodeFindEmitter.addChannel(binding.getBinaryMessenger());
            barcodeBatchEmitter.addChannel(binding.getBinaryMessenger());
            sparkScanEmitter.addChannel(binding.getBinaryMessenger());
            barcodeSelectionEmitter.addChannel(binding.getBinaryMessenger());
            barcodeCountEmitter.addChannel(binding.getBinaryMessenger());
            barcodeCaptureEmitter.addChannel(binding.getBinaryMessenger());
            barcodeCheckEmitter.addChannel(binding.getBinaryMessenger());
        }
    }

    private void disposeEventChannels() {
        FlutterPluginBinding binding = flutterPluginBinding.get();
        if (binding != null) {
            barcodePickEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeFindEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeBatchEmitter.removeChannel(binding.getBinaryMessenger());
            sparkScanEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeSelectionEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeCountEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeCaptureEmitter.removeChannel(binding.getBinaryMessenger());
            barcodeCheckEmitter.removeChannel(binding.getBinaryMessenger());
        }
    }

    private void setupMethodChannels(@NonNull FlutterPluginBinding binding) {
        // Barcode method channel
        barcodeMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodeMethodHandler.METHOD_CHANNEL
        );
        barcodeMethodChannel.setMethodCallHandler(
                new BarcodeMethodHandler(serviceLocator)
        );

        // Barcode capture method channel
        barcodeCaptureMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodeCaptureMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeCaptureMethodChannel.setMethodCallHandler(
                new BarcodeCaptureMethodHandler(serviceLocator)
        );

        // Barcode selection method channel
        barcodeSelectionMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodeSelectionMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeSelectionMethodChannel.setMethodCallHandler(new BarcodeSelectionMethodHandler(serviceLocator));

        // Barcode count method channel
        barcodeCountMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodeCountMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeCountMethodChannel.setMethodCallHandler(new BarcodeCountMethodHandler(serviceLocator));

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodeCountView",
                new BarcodeCountPlatformViewFactory(
                        serviceLocator
                )
        );

        // Barcode batch method channel
        barcodeBatchMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodeBatchMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeBatchMethodChannel.setMethodCallHandler(
                new BarcodeBatchMethodHandler(serviceLocator)
        );

        // SparkScan method channel
        sparkScanMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                SparkScanMethodHandler.METHOD_CHANNEL_NAME
        );
        sparkScanMethodChannel.setMethodCallHandler(new SparkScanMethodHandler(serviceLocator));

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.SparkScanView",
                new SparkScanPlatformViewFactory(
                        serviceLocator
                )
        );

        // Barcode find method channel
        barcodeFindMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodeFindMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeFindMethodChannel.setMethodCallHandler(new BarcodeFindMethodHandler(serviceLocator));

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodeFindView",
                new BarcodeFindPlatformViewFactory(
                        serviceLocator
                )
        );

        // Barcode Pick method channel
        barcodePickMethodChannel = MethodChannelExtensions.getMethodChannel(binding,
                BarcodePickMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodePickMethodChannel.setMethodCallHandler(new BarcodePickMethodHandler(serviceLocator));

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodePickView",
                new BarcodePickPlatformViewFactory(
                        serviceLocator
                )
        );

        // Barcode check method channel
        barcodeCheckMethodChannel = MethodChannelExtensions.getMethodChannel(
                binding,
                BarcodeCheckMethodHandler.METHOD_CHANNEL_NAME
        );
        barcodeCheckMethodChannel.setMethodCallHandler(new BarcodeCheckMethodHandler(serviceLocator));

        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.BarcodeCheckView",
                new BarcodeCheckPlatformViewFactory(
                        serviceLocator
                )
        );
    }

    private void disposeMethodChannels() {
        if (barcodeMethodChannel != null) {
            barcodeMethodChannel.setMethodCallHandler(null);
            barcodeMethodChannel = null;
        }
        if (barcodeCaptureMethodChannel != null) {
            barcodeCaptureMethodChannel.setMethodCallHandler(null);
            barcodeCaptureMethodChannel = null;
        }
        if (barcodeCountMethodChannel != null) {
            barcodeCountMethodChannel.setMethodCallHandler(null);
            barcodeCountMethodChannel = null;
        }
        if (barcodeSelectionMethodChannel != null) {
            barcodeSelectionMethodChannel.setMethodCallHandler(null);
            barcodeSelectionMethodChannel = null;
        }
        if (barcodeBatchMethodChannel != null) {
            barcodeBatchMethodChannel.setMethodCallHandler(null);
            barcodeBatchMethodChannel = null;
        }
        if (sparkScanMethodChannel != null) {
            sparkScanMethodChannel.setMethodCallHandler(null);
            sparkScanMethodChannel = null;
        }
        if (barcodeFindMethodChannel != null) {
            barcodeFindMethodChannel.setMethodCallHandler(null);
            barcodeFindMethodChannel = null;
        }
        if (barcodePickMethodChannel != null) {
            barcodePickMethodChannel.setMethodCallHandler(null);
            barcodePickMethodChannel = null;
        }
        if (barcodeCheckMethodChannel != null) {
            barcodeCheckMethodChannel.setMethodCallHandler(null);
            barcodeCheckMethodChannel = null;
        }
    }

    private void setupModules(FlutterPluginBinding binding) {
        lock.lock();
        try {
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
            setupBarcodeCheck(binding);
        } finally {
            lock.unlock();
        }
    }

    private void disposeModules() {
        lock.lock();
        try {
            // Barcode Module
            FrameworkModule module = serviceLocator.remove(BarcodeModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Capture Module
            module = serviceLocator.remove(BarcodeCaptureModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Count Module
            module = serviceLocator.remove(BarcodeCountModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Selection Module
            module = serviceLocator.remove(BarcodeSelectionModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Batch Module
            module = serviceLocator.remove(BarcodeBatchModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Spark Scan Module
            module = serviceLocator.remove(SparkScanModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Find Module
            module = serviceLocator.remove(BarcodeFindModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Pick Module
            module = serviceLocator.remove(BarcodePickModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }

            // Barcode Check Module
            module = serviceLocator.remove(BarcodeCheckModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }
        } finally {
            lock.unlock();
        }
    }

    private void setupBarcodePick(@NonNull FlutterPluginBinding binding) {
        BarcodePickModule barcodePickModule = (BarcodePickModule) serviceLocator.resolve(BarcodePickModule.class.getName());
        if (barcodePickModule != null) return;

        barcodePickModule = BarcodePickModule.create(barcodePickEmitter);
        barcodePickModule.onCreate(binding.getApplicationContext());

        serviceLocator.register(barcodePickModule);
    }

    private void setupBarcodeFind(@NonNull FlutterPluginBinding binding) {
        BarcodeFindModule barcodeFindModule = (BarcodeFindModule) serviceLocator.resolve(BarcodeFindModule.class.getName());
        if (barcodeFindModule != null) return;

        barcodeFindModule = BarcodeFindModule.create(
                new FrameworksBarcodeFindListener(barcodeFindEmitter),
                new FrameworksBarcodeFindViewUiListener(barcodeFindEmitter),
                new FrameworksBarcodeFindTransformer(barcodeFindEmitter)
        );
        barcodeFindModule.onCreate(binding.getApplicationContext());

        serviceLocator.register(barcodeFindModule);
    }

    private void setupBarcodeBatch(@NonNull FlutterPluginBinding binding) {
        BarcodeBatchModule barcodeBatchModule = (BarcodeBatchModule) serviceLocator.resolve(BarcodeBatchModule.class.getName());
        if (barcodeBatchModule != null) return;

        barcodeBatchModule = BarcodeBatchModule.create(
                FrameworksBarcodeBatchListener.create(barcodeBatchEmitter),
                new FrameworksBarcodeBatchBasicOverlayListener(barcodeBatchEmitter),
                new FrameworksBarcodeBatchAdvancedOverlayListener(barcodeBatchEmitter)
        );
        barcodeBatchModule.onCreate(binding.getApplicationContext());

        serviceLocator.register(barcodeBatchModule);
    }

    private void setupSparkScan(@NonNull FlutterPluginBinding binding) {
        SparkScanModule sparkScanModule = (SparkScanModule) serviceLocator.resolve(SparkScanModule.class.getName());
        if (sparkScanModule != null) return;

        sparkScanModule = SparkScanModule.create(
                FrameworksSparkScanListener.create(sparkScanEmitter),
                new FrameworksSparkScanViewUiListener(sparkScanEmitter),
                FrameworksSparkScanFeedbackDelegate.create(sparkScanEmitter)
        );
        sparkScanModule.onCreate(binding.getApplicationContext());

        serviceLocator.register(sparkScanModule);
    }

    private void setupBarcodeSelection(@NonNull FlutterPluginBinding binding) {
        BarcodeSelectionModule barcodeSelectionModule = (BarcodeSelectionModule) serviceLocator.resolve(BarcodeSelectionModule.class.getName());
        if (barcodeSelectionModule != null) return;

        barcodeSelectionModule = BarcodeSelectionModule.create(
                FrameworksBarcodeSelectionListener.create(barcodeSelectionEmitter),
                new FrameworksBarcodeSelectionAimedBrushProvider(barcodeSelectionEmitter),
                new FrameworksBarcodeSelectionTrackedBrushProvider(barcodeSelectionEmitter)
        );
        barcodeSelectionModule.onCreate(binding.getApplicationContext());

        serviceLocator.register(barcodeSelectionModule);
    }

    private void setupBarcodeCount(@NonNull FlutterPluginBinding binding) {
        BarcodeCountModule barcodeCountModule = (BarcodeCountModule) serviceLocator.resolve(BarcodeCountModule.class.getName());
        if (barcodeCountModule != null) return;

        barcodeCountModule = BarcodeCountModule.create(barcodeCountEmitter);
        barcodeCountModule.onCreate(binding.getApplicationContext());

        serviceLocator.register(barcodeCountModule);
    }

    private void setupBarcodeCapture(@NonNull FlutterPluginBinding binding) {
        BarcodeCaptureModule barcodeCaptureModule = (BarcodeCaptureModule) serviceLocator.resolve(BarcodeCaptureModule.class.getName());
        if (barcodeCaptureModule != null) return;

        barcodeCaptureModule = BarcodeCaptureModule.create(
                FrameworksBarcodeCaptureListener.create(barcodeCaptureEmitter)
        );
        barcodeCaptureModule.onCreate(binding.getApplicationContext());
        serviceLocator.register(barcodeCaptureModule);
    }

    private void setupBarcodeModule(@NonNull FlutterPluginBinding binding) {
        BarcodeModule barcodeModule = (BarcodeModule) serviceLocator.resolve(BarcodeModule.class.getName());
        if (barcodeModule != null) return;

        barcodeModule = new BarcodeModule();
        barcodeModule.onCreate(binding.getApplicationContext());
        serviceLocator.register(barcodeModule);
    }

    private void setupBarcodeCheck(@NonNull FlutterPluginBinding binding) {
        BarcodeCheckModule module = (BarcodeCheckModule) serviceLocator.resolve(BarcodeCheckModule.class.getName());
        if (module != null) return;

        module = BarcodeCheckModule.create(barcodeCheckEmitter);
        module.onCreate(binding.getApplicationContext());
        serviceLocator.register(module);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        result.notImplemented();
    }
}
