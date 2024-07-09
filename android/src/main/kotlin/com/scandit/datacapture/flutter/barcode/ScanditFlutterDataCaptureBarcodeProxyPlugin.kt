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
import com.scandit.datacapture.frameworks.barcode.pick.BarcodePickModule
import com.scandit.datacapture.frameworks.barcode.selection.BarcodeSelectionModule
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionAimedBrushProvider
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionListener
import com.scandit.datacapture.frameworks.barcode.selection.listeners.FrameworksBarcodeSelectionTrackedBrushProvider
import com.scandit.datacapture.frameworks.barcode.spark.SparkScanModule
import com.scandit.datacapture.frameworks.barcode.spark.listeners.FrameworksSparkScanListener
import com.scandit.datacapture.frameworks.barcode.spark.listeners.FrameworksSparkScanViewUiListener
import com.scandit.datacapture.frameworks.barcode.tracking.BarcodeTrackingModule
import com.scandit.datacapture.frameworks.barcode.tracking.listeners.FrameworksBarcodeTrackingAdvancedOverlayListener
import com.scandit.datacapture.frameworks.barcode.tracking.listeners.FrameworksBarcodeTrackingBasicOverlayListener
import com.scandit.datacapture.frameworks.barcode.tracking.listeners.FrameworksBarcodeTrackingListener
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
class ScanditFlutterDataCaptureBarcodeProxyPlugin : FlutterPlugin, MethodCallHandler,
    ActivityAware {

    private val barcodeModule: BarcodeModule = BarcodeModule()

    private var barcodeMethodChannel: MethodChannel? = null

    private var barcodeCaptureModule: BarcodeCaptureModule? = null

    private var barcodeCaptureMethodChannel: MethodChannel? = null

    private var barcodeCountModule: BarcodeCountModule? = null

    private var barcodeCountMethodChannel: MethodChannel? = null

    private var barcodeSelectionModule: BarcodeSelectionModule? = null

    private var barcodeSelectionMethodChannel: MethodChannel? = null

    private var barcodeTrackingModule: BarcodeTrackingModule? = null

    private var barcodeTrackingMethodChannel: MethodChannel? = null

    private var sparkScanModule: SparkScanModule? = null

    private var sparkScanMethodChannel: MethodChannel? = null

    private var barcodeFindModule: BarcodeFindModule? = null

    private var barcodeFindMethodChannel: MethodChannel? = null

    private var barcodePickModule: BarcodePickModule? = null

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
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        flutterPluginBinding = WeakReference(null)
    }

    private fun onAttached() {
        lock.withLock {
            if (isPluginAttached) return

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
        barcodeModule.onDestroy()
        barcodeMethodChannel?.setMethodCallHandler(null)
        // Barcode Capture Module
        barcodeCaptureModule?.onDestroy()
        barcodeCaptureModule = null
        barcodeCaptureMethodChannel?.setMethodCallHandler(null)

        // Barcode Count Module
        barcodeCountModule?.onDestroy()
        barcodeCountModule = null
        barcodeCountMethodChannel?.setMethodCallHandler(null)

        // Barcode Selection Module
        barcodeSelectionModule?.onDestroy()
        barcodeSelectionModule = null
        barcodeSelectionMethodChannel?.setMethodCallHandler(null)

        // Barcode Tracking Module
        barcodeTrackingModule?.onDestroy()
        barcodeTrackingModule = null
        barcodeTrackingMethodChannel?.setMethodCallHandler(null)

        // Spark Scan Module
        sparkScanModule?.onDestroy()
        sparkScanModule = null
        sparkScanMethodChannel?.setMethodCallHandler(null)

        // Barcode Find Module
        barcodeFindModule?.onDestroy()
        barcodeFindModule = null
        barcodeFindMethodChannel?.setMethodCallHandler(null)

        // Barcode Pick Module
        barcodePickModule?.onDestroy()
        barcodePickModule = null
        barcodePickMethodChannel?.setMethodCallHandler(null)
    }

    private fun setupBarcodePick(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodePickMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        barcodePickModule = BarcodePickModule(
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
                    module
                )
            )
        }
    }

    private fun setupBarcodeFind(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeFindMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        barcodeFindModule = BarcodeFindModule(
            FrameworksBarcodeFindListener(eventEmitter),
            FrameworksBarcodeFindViewUiListener(eventEmitter)
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
                    module
                )
            )
        }
    }

    private fun setupBarcodeTracking(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeTrackingMethodHandler.EVENT_CHANNEL_NAME
            )
        )
        barcodeTrackingModule = BarcodeTrackingModule(
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
    }

    private fun setupSparkScan(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                SparkScanMethodHandler.EVENT_CHANNEL_NAME
            )
        )

        sparkScanModule = SparkScanModule(
            FrameworksSparkScanListener(eventEmitter),
            FrameworksSparkScanViewUiListener(eventEmitter)
        ).also { module ->
            module.onCreate(binding.applicationContext)

            sparkScanMethodChannel = binding.getMethodChannel(
                SparkScanMethodHandler.METHOD_CHANNEL_NAME
            ).also {
                it.setMethodCallHandler(SparkScanMethodHandler(module))
            }

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.SparkScanView",
                SparkScanPlatformViewFactory(module)
            )
        }
    }

    private fun setupBarcodeSelection(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeSelectionMethodHandler.EVENT_CHANNEL_NAME
            )
        )
        barcodeSelectionModule = BarcodeSelectionModule(
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
    }

    private fun setupBarcodeCount(binding: FlutterPluginBinding) {
        val eventEmitter = FlutterEmitter(
            EventChannel(
                binding.binaryMessenger,
                BarcodeCountMethodHandler.EVENT_CHANNEL_NAME
            )
        )
        barcodeCountModule = BarcodeCountModule(
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
                    module
                )
            )
        }
    }

    private fun setupBarcodeCapture(binding: FlutterPluginBinding) {
        barcodeCaptureModule = BarcodeCaptureModule(
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
    }

    private fun setupBarcodeModule(binding: FlutterPluginBinding) {
        barcodeModule.onCreate(binding.applicationContext)

        barcodeMethodChannel = binding.getMethodChannel(
            BarcodeMethodHandler.METHOD_CHANNEL
        )
        barcodeMethodChannel?.setMethodCallHandler(
            BarcodeMethodHandler(barcodeModule)
        )
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
