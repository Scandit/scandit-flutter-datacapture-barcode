/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.barcode

import android.content.Context
import com.scandit.datacapture.flutter.barcode.capture.ScanditFlutterBarcodeCaptureSessionHolder
import com.scandit.datacapture.flutter.barcode.capture.ScanditFlutterDataCaptureBarcodeCaptureHandler
import com.scandit.datacapture.flutter.barcode.capture.ScanditFlutterDataCaptureBarcodeCapturePlugin
import com.scandit.datacapture.flutter.barcode.capture.listeners.ScanditFlutterBarcodeCaptureListener
import com.scandit.datacapture.flutter.barcode.count.FrameworksBarcodeCount
import com.scandit.datacapture.flutter.barcode.count.ScanditFlutterBarcodeCountSessionHolder
import com.scandit.datacapture.flutter.barcode.count.ScanditFlutterDataCaptureBarcodeCountMethodCallHandler
import com.scandit.datacapture.flutter.barcode.count.ScanditFlutterDataCaptureBarcodeCountPlugin
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountCaptureListListener
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountListener
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountViewListener
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountViewUiListener
import com.scandit.datacapture.flutter.barcode.selection.ScanditFlutterBarcodeSelectionSessionHolder
import com.scandit.datacapture.flutter.barcode.selection.ScanditFlutterDataCaptureBarcodeSelectionHandler
import com.scandit.datacapture.flutter.barcode.selection.ScanditFlutterDataCaptureBarcodeSelectionPlugin
import com.scandit.datacapture.flutter.barcode.selection.listeners.ScanditFlutterBarcodeSelectionListener
import com.scandit.datacapture.flutter.barcode.tracking.ScanditFlutterBarcodeTrackingAdvancedOverlayHandler
import com.scandit.datacapture.flutter.barcode.tracking.ScanditFlutterBarcodeTrackingBasicOverlayHandler
import com.scandit.datacapture.flutter.barcode.tracking.ScanditFlutterBarcodeTrackingSessionHolder
import com.scandit.datacapture.flutter.barcode.tracking.ScanditFlutterDataCaptureBarcodeTrackingHandler
import com.scandit.datacapture.flutter.barcode.tracking.ScanditFlutterDataCaptureBarcodeTrackingPlugin
import com.scandit.datacapture.flutter.barcode.tracking.listeners.ScanditFlutterBarcodeTrackingAdvancedOverlayListener
import com.scandit.datacapture.flutter.barcode.tracking.listeners.ScanditFlutterBarcodeTrackingBasicOverlayListener
import com.scandit.datacapture.flutter.barcode.tracking.listeners.ScanditFlutterBarcodeTrackingListener
import com.scandit.datacapture.flutter.barcode.utils.AdvancedOverlayViewPool
import com.scandit.datacapture.flutter.core.utils.EventHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/** ScanditFlutterDataCaptureBarcodePlugin */
class ScanditFlutterDataCaptureBarcodeProxyPlugin : FlutterPlugin, MethodCallHandler {
    private val scanditFlutterDataCaptureBarcodeCorePlugin =
        ScanditFlutterDataCaptureBarcodePlugin()

    private var scanditFlutterDataCaptureBarcodeCapturePlugin:
        ScanditFlutterDataCaptureBarcodeCapturePlugin? = null

    private var scanditFlutterDataCaptureBarcodeTrackingPlugin:
        ScanditFlutterDataCaptureBarcodeTrackingPlugin? = null

    private var scanditFlutterDataCaptureBarcodeSelectionPlugin:
        ScanditFlutterDataCaptureBarcodeSelectionPlugin? = null

    private var scanditFlutterDataCaptureBarcodeCountPlugin:
        ScanditFlutterDataCaptureBarcodeCountPlugin? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        lock.withLock {
            if (isPluginAttached) return

            scanditFlutterDataCaptureBarcodeCorePlugin.onAttachedToEngine(binding)
            scanditFlutterDataCaptureBarcodeCapturePlugin =
                ScanditFlutterDataCaptureBarcodeCapturePlugin(
                    provideScanditFlutterDataCaptureBarcodeCapture(binding.binaryMessenger)
                ).also {
                    it.onAttachedToEngine(binding)
                }
            scanditFlutterDataCaptureBarcodeTrackingPlugin =
                ScanditFlutterDataCaptureBarcodeTrackingPlugin(
                    provideScanditFlutterDataCaptureBarcodeTracking(
                        binding.binaryMessenger,
                        binding.applicationContext
                    )
                ).also {
                    it.onAttachedToEngine(binding)
                }

            scanditFlutterDataCaptureBarcodeSelectionPlugin =
                ScanditFlutterDataCaptureBarcodeSelectionPlugin(
                    provideScanditFlutterDataCaptureBarcodeSelection(binding.binaryMessenger)
                ).also {
                    it.onAttachedToEngine(binding)
                }

            val frameworksBarcodeCount = provideFrameworksBarcodeCount(binding)

            scanditFlutterDataCaptureBarcodeCountPlugin =
                ScanditFlutterDataCaptureBarcodeCountPlugin(
                    frameworksBarcodeCount,
                    provideScanditFlutterDataCaptureBarcodeCountMethodCallHandler(
                        frameworksBarcodeCount
                    )
                ).also {
                    it.onAttachedToEngine(binding)
                }

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.BarcodeCountView",
                ScanditBarcodeCountPlatformViewFactory(frameworksBarcodeCount)
            )

            isPluginAttached = true
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        lock.withLock {
            scanditFlutterDataCaptureBarcodeCorePlugin.onDetachedFromEngine(binding)
            scanditFlutterDataCaptureBarcodeCapturePlugin?.onDetachedFromEngine(binding)
            scanditFlutterDataCaptureBarcodeTrackingPlugin?.onDetachedFromEngine(binding)
            scanditFlutterDataCaptureBarcodeSelectionPlugin?.onDetachedFromEngine(binding)
            scanditFlutterDataCaptureBarcodeCountPlugin?.onDetachedFromEngine(binding)
            isPluginAttached = false
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        result.notImplemented()
    }

    companion object {
        @JvmStatic
        private val lock = ReentrantLock()

        @JvmStatic
        private var isPluginAttached = false

        //region BARCODE TRACKING

        @JvmStatic
        private fun provideScanditFlutterDataCaptureBarcodeTracking(
            binaryMessenger: BinaryMessenger,
            applicationContext: Context
        ): ScanditFlutterDataCaptureBarcodeTrackingHandler {
            val sessionHolder = ScanditFlutterBarcodeTrackingSessionHolder()

            return ScanditFlutterDataCaptureBarcodeTrackingHandler(
                provideScanditFlutterBarcodeTrackingListener(binaryMessenger, sessionHolder),
                provideBarcodeTrackingBasicOverlayHandler(binaryMessenger, sessionHolder),
                provideBarcodeTrackingAdvancedOverlayHandler(
                    applicationContext,
                    binaryMessenger,
                    sessionHolder
                ),
                sessionHolder
            )
        }

        @JvmStatic
        private fun provideBarcodeTrackingAdvancedOverlayHandler(
            applicationContext: Context,
            binaryMessenger: BinaryMessenger,
            sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder
        ): ScanditFlutterBarcodeTrackingAdvancedOverlayHandler {
            val advancedOverlayViewPool = AdvancedOverlayViewPool(applicationContext)

            return ScanditFlutterBarcodeTrackingAdvancedOverlayHandler(
                binaryMessenger,
                provideBarcodeTrackingAdvancedOverlayListener(
                    binaryMessenger
                ),
                sessionHolder,
                advancedOverlayViewPool
            )
        }

        @JvmStatic
        private fun provideBarcodeTrackingAdvancedOverlayListener(
            binaryMessenger: BinaryMessenger
        ): ScanditFlutterBarcodeTrackingAdvancedOverlayListener {
            val eventHandler = EventHandler(
                EventChannel(
                    binaryMessenger,
                    ScanditFlutterBarcodeTrackingAdvancedOverlayListener.CHANNEL_NAME
                )
            )

            return ScanditFlutterBarcodeTrackingAdvancedOverlayListener(
                eventHandler
            )
        }

        @JvmStatic
        private fun provideScanditFlutterBarcodeTrackingListener(
            binaryMessenger: BinaryMessenger,
            sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder
        ): ScanditFlutterBarcodeTrackingListener =
            ScanditFlutterBarcodeTrackingListener(
                eventHandler = EventHandler(
                    EventChannel(
                        binaryMessenger,
                        ScanditFlutterBarcodeTrackingListener.CHANNEL_NAME
                    )
                ),
                sessionHolder = sessionHolder
            )

        @JvmStatic
        private fun provideBarcodeTrackingBasicOverlayHandler(
            binaryMessenger: BinaryMessenger,
            sessionHolder: ScanditFlutterBarcodeTrackingSessionHolder
        ): ScanditFlutterBarcodeTrackingBasicOverlayHandler =
            ScanditFlutterBarcodeTrackingBasicOverlayHandler(
                binaryMessenger = binaryMessenger,
                barcodeTrackingBasicOverlayListener =
                provideScanditFlutterBarcodeTrackingBasicOverlayListener(binaryMessenger),
                sessionHolder = sessionHolder
            )

        @JvmStatic
        private fun provideScanditFlutterBarcodeTrackingBasicOverlayListener(
            binaryMessenger: BinaryMessenger
        ): ScanditFlutterBarcodeTrackingBasicOverlayListener {
            val eventHandler = EventHandler(
                EventChannel(
                    binaryMessenger,
                    ScanditFlutterBarcodeTrackingBasicOverlayListener.CHANNEL_NAME
                )
            )
            return ScanditFlutterBarcodeTrackingBasicOverlayListener(eventHandler)
        }

        //endregion BARCODE TRACKING

        //region BARCODE CAPTURE

        @JvmStatic
        private fun provideScanditFlutterDataCaptureBarcodeCapture(
            binaryMessenger: BinaryMessenger
        ): ScanditFlutterDataCaptureBarcodeCaptureHandler {
            val sessionHolder = ScanditFlutterBarcodeCaptureSessionHolder()
            return ScanditFlutterDataCaptureBarcodeCaptureHandler(
                provideScanditFlutterBarcodeCaptureListener(binaryMessenger, sessionHolder),
                sessionHolder
            )
        }

        @JvmStatic
        private fun provideScanditFlutterBarcodeCaptureListener(
            binaryMessenger: BinaryMessenger,
            sessionHolder: ScanditFlutterBarcodeCaptureSessionHolder
        ): ScanditFlutterBarcodeCaptureListener =
            ScanditFlutterBarcodeCaptureListener(
                EventHandler(
                    EventChannel(
                        binaryMessenger,
                        ScanditFlutterBarcodeCaptureListener.CHANNEL_NAME
                    )
                ),
                sessionHolder
            )

        //endregion BARCODE CAPTURE

        //region BARCODE SELECTION

        @JvmStatic
        private fun provideScanditFlutterDataCaptureBarcodeSelection(
            binaryMessenger: BinaryMessenger
        ): ScanditFlutterDataCaptureBarcodeSelectionHandler {
            val sessionHolder = ScanditFlutterBarcodeSelectionSessionHolder()
            return ScanditFlutterDataCaptureBarcodeSelectionHandler(
                provideScanditFlutterBarcodeSelectionListener(binaryMessenger, sessionHolder),
                sessionHolder
            )
        }

        @JvmStatic
        private fun provideScanditFlutterBarcodeSelectionListener(
            binaryMessenger: BinaryMessenger,
            sessionHolder: ScanditFlutterBarcodeSelectionSessionHolder
        ): ScanditFlutterBarcodeSelectionListener =
            ScanditFlutterBarcodeSelectionListener(
                EventHandler(
                    EventChannel(
                        binaryMessenger,
                        ScanditFlutterBarcodeSelectionListener.CHANNEL_NAME
                    )
                ),
                sessionHolder
            )

        //endregion BARCODE SELECTION

        //region BARCODE COUNT

        @JvmStatic
        private fun provideScanditFlutterBarcodeCountListener(
            channel: EventChannel,
            sessionHolder: ScanditFlutterBarcodeCountSessionHolder
        ): ScanditFlutterBarcodeCountListener {
            return ScanditFlutterBarcodeCountListener(
                EventHandler(channel),
                sessionHolder
            )
        }

        @JvmStatic
        private fun provideScanditFlutterBarcodeCountCaptureListListener(
            channel: EventChannel
        ): ScanditFlutterBarcodeCountCaptureListListener {
            return ScanditFlutterBarcodeCountCaptureListListener(
                EventHandler(
                    channel
                )
            )
        }

        @JvmStatic
        private fun provideFrameworksBarcodeCount(
            binding: FlutterPluginBinding
        ): FrameworksBarcodeCount {
            val sessionHolder = ScanditFlutterBarcodeCountSessionHolder()

            val barcodeCountEventsChannel = EventChannel(
                binding.binaryMessenger,
                ScanditFlutterBarcodeCountListener.CHANNEL_NAME
            )

            return FrameworksBarcodeCount(
                binding.applicationContext,
                provideScanditFlutterBarcodeCountCaptureListListener(barcodeCountEventsChannel),
                provideScanditFlutterBarcodeCountListener(barcodeCountEventsChannel, sessionHolder),
                provideScanditFlutterBarcodeCountViewListener(binding),
                provideScanditFlutterBarcodeCountViewUiListener(binding),
                sessionHolder
            )
        }

        @JvmStatic
        private fun provideScanditFlutterDataCaptureBarcodeCountMethodCallHandler(
            frameworksBarcodeCount: FrameworksBarcodeCount
        ): ScanditFlutterDataCaptureBarcodeCountMethodCallHandler {
            return ScanditFlutterDataCaptureBarcodeCountMethodCallHandler(
                frameworksBarcodeCount
            )
        }

        @JvmStatic
        private fun provideScanditFlutterBarcodeCountViewListener(
            binding: FlutterPluginBinding
        ): ScanditFlutterBarcodeCountViewListener {
            val viewListenerChannel = EventChannel(
                binding.binaryMessenger,
                ScanditFlutterBarcodeCountViewListener.CHANNEL_NAME
            )
            return ScanditFlutterBarcodeCountViewListener(
                EventHandler(
                    viewListenerChannel
                )
            )
        }

        @JvmStatic
        private fun provideScanditFlutterBarcodeCountViewUiListener(
            binding: FlutterPluginBinding
        ): ScanditFlutterBarcodeCountViewUiListener {
            return ScanditFlutterBarcodeCountViewUiListener(
                EventHandler(
                    EventChannel(
                        binding.binaryMessenger,
                        ScanditFlutterBarcodeCountViewUiListener.CHANNEL_NAME
                    )
                )
            )
        }

        //endregion BARCODE COUNT
    }
}
