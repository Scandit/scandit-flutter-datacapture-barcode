/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode

import com.scandit.datacapture.flutter.barcode.capture.BarcodeCaptureMethodHandler
import com.scandit.datacapture.flutter.barcode.count.BarcodeCountMethodHandler
import com.scandit.datacapture.flutter.barcode.find.BarcodeFindMethodHandler
import com.scandit.datacapture.flutter.barcode.pick.BarcodePickMethodHandler
import com.scandit.datacapture.flutter.barcode.selection.BarcodeSelectionMethodHandler
import com.scandit.datacapture.flutter.barcode.spark.SparkScanMethodHandler
import com.scandit.datacapture.flutter.barcode.tracking.BarcodeTrackingMethodHandler
import com.scandit.datacapture.flutter.core.extensions.getMethodChannel
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter
import com.scandit.datacapture.frameworks.barcode.BarcodeModule
import com.scandit.datacapture.frameworks.barcode.capture.BarcodeCaptureModule
import com.scandit.datacapture.frameworks.barcode.capture.listeners.FrameworksBarcodeCaptureListener
import com.scandit.datacapture.frameworks.barcode.count.BarcodeCountModule
import com.scandit.datacapture.frameworks.barcode.count.listeners.FrameworksBarcodeCountCaptureListListener
import com.scandit.datacapture.frameworks.barcode.count.listeners.FrameworksBarcodeCountListener
import com.scandit.datacapture.frameworks.barcode.count.listeners.FrameworksBarcodeCountViewListener
import com.scandit.datacapture.frameworks.barcode.count.listeners.FrameworksBarcodeCountViewUiListener
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule
import com.scandit.datacapture.frameworks.barcode.find.listeners.FrameworksBarcodeFindListener
import com.scandit.datacapture.frameworks.barcode.find.listeners.FrameworksBarcodeFindViewUiListener
import com.scandit.datacapture.frameworks.barcode.find.transformer.FrameworksBarcodeFindTransformer
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionAimedBrushProvider
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionListener
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionTrackedBrushProvider
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule
import com.scandit.datacapture.frameworks.barcode.spark.delegates.FrameworksSparkScanFeedbackDelegate
import com.scandit.datacapture.frameworks.barcode.spark.listeners.FrameworksSparkScanListener
import com.scandit.datacapture.frameworks.barcode.spark.listeners.FrameworksSparkScanViewUiListener
import com.scandit.datacapture.frameworks.barcode.tracking.BarcodeTrackingModule
import com.scandit.datacapture.frameworks.barcode.tracking.listeners.FrameworksBarcodeTrackingAdvancedOverlayListener
import com.scandit.datacapture.frameworks.barcode.tracking.listeners.FrameworksBarcodeTrackingBasicOverlayListener
import com.scandit.datacapture.frameworks.barcode.tracking.listeners.FrameworksBarcodeTrackingListener
import com.scandit.datacapture.frameworks.core.locator.DefaultServiceLocator
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/** ScanditFlutterDataCaptureBarcodePlugin */
class ScanditFlutterDataCaptureBarcodeProxyPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {

    private val serviceLocator = DefaultServiceLocator.getInstance()

    private var barcodeMethodChannel: MethodChannel? = null

    private var barcodeCaptureMethodChannel: MethodChannel? = null

    private var barcodeCountMethodChannel: MethodChannel? = null

    private var barcodeSelectionMethodChannel: MethodChannel? = null

    private var barcodeTrackingMethodChannel: MethodChannel? = null

    private var sparkScanMethodChannel: MethodChannel? = null

    private var barcodeFindMethodChannel: MethodChannel? = null

    private var barcodePickMethodChannel: MethodChannel? = null

    private var flutterPluginBinding: WeakReference<FlutterPluginBinding?> = WeakReference(null)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        onAttached()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetached()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttached()
    }

    override fun onDetachedFromActivity() {
        onDetached()
    }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(binding)
        onAttached()
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(null)
        onDetached()
    }

    private fun onAttached() {
        lock.withLock {
            if (isPluginAttached) {
                disposeModules()
            }

            val flutterBinding = flutterPluginBinding.get() ?: return

            setupModules(flutterBinding)

            isPluginAttached = true
        }
    }

    private fun onDetached() {
        lock.withLock {
            disposeModules()
            isPluginAttached = false
        }
    }

    private fun setupModules(binding: FlutterPluginBinding) {
        // Barcode
        setupBarcodeModule(binding)

        // Barcode Capture
        setupBarcodeCapture(binding)

        // Barcode Count
        setupBarcodeCount(binding)

        // Barcode Selection
        setupBarcodeSelection(binding)

        // Barcode Tracking
        setupBarcodeTracking(binding)

        // Spark Scan
        setupSparkScan(binding)

        // Barcode Find
        setupBarcodeFind(binding)

        // Barcode Pick
        setupBarcodePick(binding)
    }

    private fun disposeModules() {
        // Barcode Module
        serviceLocator.remove(BarcodeModule::class.java.name)?.onDestroy()
        barcodeMethodChannel?.setMethodCallHandler(null)
        // Barcode Capture Module
        serviceLocator.remove(BarcodeCaptureModule::class.java.name)?.onDestroy()
        barcodeCaptureMethodChannel?.setMethodCallHandler(null)

        // Barcode Count Module
        serviceLocator.remove(BarcodeCountModule::class.java.name)?.onDestroy()
        barcodeCountMethodChannel?.setMethodCallHandler(null)

        // Barcode Selection Module
        serviceLocator.remove(BarcodeSelectionModule::class.java.name)?.onDestroy()
        barcodeSelectionMethodChannel?.setMethodCallHandler(null)

        // Barcode Tracking Module
        serviceLocator.remove(BarcodeTrackingModule::class.java.name)?.onDestroy()
        barcodeTrackingMethodChannel?.setMethodCallHandler(null)

        // Spark Scan Module
        serviceLocator.remove(SparkScanModule::class.java.name)?.onDestroy()
        sparkScanMethodChannel?.setMethodCallHandler(null)

        // Barcode Find Module
        serviceLocator.remove(BarcodeFindModule::class.java.name)?.onDestroy()
        barcodeFindMethodChannel?.setMethodCallHandler(null)

        // Barcode Pick Module
        serviceLocator.remove(BarcodePickModule::class.java.name)?.onDestroy()
        barcodePickMethodChannel?.setMethodCallHandler(null)
    }

    private fun setupBarcodePick(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodePickMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        val barcodePickModule = BarcodePickModule(
            eventEmitter
        ).also { module ->
            module.onCreate(binding.applicationContext)

            barcodePickMethodChannel = binding.getMethodChannel(
                BarcodePickMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(BarcodePickMethodHandler(module))
            }

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.BarcodePickView",
                BarcodePickPlatformViewFactory(
                    serviceLocator
                )
            )
        }

        serviceLocator.register(barcodePickModule)
    }

    private fun setupBarcodeFind(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeFindMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        val barcodeFindModule = BarcodeFindModule(
            FrameworksBarcodeFindListener(eventEmitter),
            FrameworksBarcodeFindViewUiListener(eventEmitter),
            FrameworksBarcodeFindTransformer(eventEmitter)
        ).also { module ->
            module.onCreate(binding.applicationContext)

            barcodeFindMethodChannel = binding.getMethodChannel(
                BarcodeFindMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(BarcodeFindMethodHandler(module))
            }

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.BarcodeFindView",
                BarcodeFindPlatformViewFactory(
                    serviceLocator
                )
            )
        }

        serviceLocator.register(barcodeFindModule)
    }

    private fun setupBarcodeTracking(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeTrackingMethodHandler.EVENT_CHANNEL_NAME
            )
        )
        val barcodeTrackingModule = BarcodeTrackingModule(
            FrameworksBarcodeTrackingListener(eventEmitter),
            FrameworksBarcodeTrackingBasicOverlayListener(eventEmitter),
            FrameworksBarcodeTrackingAdvancedOverlayListener(eventEmitter)
        ).also { module ->
            module.onCreate(binding.applicationContext)

            barcodeTrackingMethodChannel = binding.getMethodChannel(
                BarcodeTrackingMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(BarcodeTrackingMethodHandler(module))
            }
        }

        serviceLocator.register(barcodeTrackingModule)
    }

    private fun setupSparkScan(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                SparkScanMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        val sparkScanModule = SparkScanModule(
            FrameworksSparkScanListener(eventEmitter),
            FrameworksSparkScanViewUiListener(eventEmitter),
            FrameworksSparkScanFeedbackDelegate(eventEmitter)
        ).also { module ->
            module.onCreate(binding.applicationContext)

            sparkScanMethodChannel = binding.getMethodChannel(
                SparkScanMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(SparkScanMethodHandler(module))
            }

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.SparkScanView",
                SparkScanPlatformViewFactory(serviceLocator)
            )
        }

        serviceLocator.register(sparkScanModule)
    }

    private fun setupBarcodeSelection(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeSelectionMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        val barcodeSelectionModule = BarcodeSelectionModule(
            FrameworksBarcodeSelectionListener(eventEmitter),
            FrameworksBarcodeSelectionAimedBrushProvider(eventEmitter),
            FrameworksBarcodeSelectionTrackedBrushProvider(eventEmitter)
        ).also { module ->
            module.onCreate(binding.applicationContext)

            barcodeSelectionMethodChannel = binding.getMethodChannel(
                BarcodeSelectionMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(BarcodeSelectionMethodHandler(module))
            }
        }

        serviceLocator.register(barcodeSelectionModule)
    }

    private fun setupBarcodeCount(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeCountMethodHandler.EVENT_CHANNEL_NAME
            )
        )
        val barcodeCountModule = BarcodeCountModule(
            FrameworksBarcodeCountListener(eventEmitter),
            FrameworksBarcodeCountCaptureListListener(eventEmitter),
            FrameworksBarcodeCountViewListener(eventEmitter),
            FrameworksBarcodeCountViewUiListener(eventEmitter)
        ).also { module ->
            module.onCreate(binding.applicationContext)

            barcodeCountMethodChannel = binding.getMethodChannel(
                BarcodeCountMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(BarcodeCountMethodHandler(module))
            }

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.BarcodeCountView",
                BarcodeCountPlatformViewFactory(
                    serviceLocator
                )
            )
        }

        serviceLocator.register(barcodeCountModule)
    }

    private fun setupBarcodeCapture(binding: FlutterPluginBinding) {
        val barcodeCaptureModule = BarcodeCaptureModule(
            FrameworksBarcodeCaptureListener(
                FlutterEmitter(
                    EventChannel(
                        binding.binaryMessenger,
                        BarcodeCaptureMethodHandler.EVENT_CHANNEL_NAME
                    )
                )
            )
        ).also { module ->
            module.onCreate(binding.applicationContext)

            barcodeCaptureMethodChannel = binding.getMethodChannel(
                BarcodeCaptureMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(BarcodeCaptureMethodHandler(module))
            }
        }

        serviceLocator.register(barcodeCaptureModule)
    }

    private fun setupBarcodeModule(binding: FlutterPluginBinding) {
        val barcodeModule = BarcodeModule()
        barcodeModule.onCreate(binding.applicationContext)

        barcodeMethodChannel = binding.getMethodChannel(
            BarcodeMethodHandler.METHOD_CHANNEL
        )
        barcodeMethodChannel?.setMethodCallHandler(
            BarcodeMethodHandler(barcodeModule)
        )

        serviceLocator.register(barcodeModule)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        result.notImplemented()
    }

    companion object {
        @JvmStatic
        private val lock = ReentrantLock()

        @JvmStatic
        private var isPluginAttached = false
    }
}
