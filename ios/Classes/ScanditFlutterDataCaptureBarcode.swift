/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import scandit_flutter_datacapture_core
import ScanditFrameworksBarcode

@objc
public class ScanditFlutterDataCaptureBarcode: NSObject, FlutterPlugin {
    private let barcodeModule: BarcodeModule
    private let barcodeMethodChannel: FlutterMethodChannel

    private let barcodeCaptureModule: BarcodeCaptureModule
    private let barcodeCaptureMethodChannel: FlutterMethodChannel

    private let barcodeBatchModule: BarcodeBatchModule
    private let barcodeBatchMethodChannel: FlutterMethodChannel

    private let barcodeSelectionModule: BarcodeSelectionModule
    private let barcodeSelectionMethodChannel: FlutterMethodChannel

    private let barcodeCountModule: BarcodeCountModule
    private let barcodeCountMethodChannel: FlutterMethodChannel

    private let sparkScanModule: SparkScanModule
    private let sparkScanMethodChannel: FlutterMethodChannel

    private let barcodeFindModule: BarcodeFindModule
    private let barcodeFindMethodChannel: FlutterMethodChannel

    private let barcodePickModule: BarcodePickModule
    private let barcodePickMethodChannel: FlutterMethodChannel
    
    private let barcodeArModule: BarcodeArModule
    private let barcodeArMethodChannel: FlutterMethodChannel
    
    private let barcodeGeneratorModule: BarcodeGeneratorModule
    private let barcodeGeneratorMethodChannel: FlutterMethodChannel

    init(barcodeModule: BarcodeModule,
         barcodeMethodChannel: FlutterMethodChannel,
         barcodeCaptureModule: BarcodeCaptureModule,
         barcodeCaptureMethodChannel: FlutterMethodChannel,
         barcodeBatchModule: BarcodeBatchModule,
         barcodeBatchMethodChannel: FlutterMethodChannel,
         barcodeSelectionModule: BarcodeSelectionModule,
         barcodeSelectionMethodChannel: FlutterMethodChannel,
         barcodeCountModule: BarcodeCountModule,
         barcodeCountMethodChannel: FlutterMethodChannel,
         sparkScanModule: SparkScanModule,
         sparkScanMethodChannel: FlutterMethodChannel,
         barcodeFindModule: BarcodeFindModule,
         barcodeFindMethodChannel: FlutterMethodChannel,
         barcodePickModule: BarcodePickModule,
         barcodePickMethodChannel: FlutterMethodChannel,
         barcodeArModule: BarcodeArModule,
         barcodeArMethodChannel: FlutterMethodChannel,
         barcodeGeneratorModule: BarcodeGeneratorModule,
         barcodeGeneratorMethodChannel: FlutterMethodChannel) {
        self.barcodeModule = barcodeModule
        self.barcodeMethodChannel = barcodeMethodChannel
        self.barcodeCaptureModule = barcodeCaptureModule
        self.barcodeCaptureMethodChannel = barcodeCaptureMethodChannel
        self.barcodeBatchModule = barcodeBatchModule
        self.barcodeBatchMethodChannel = barcodeBatchMethodChannel
        self.barcodeSelectionModule = barcodeSelectionModule
        self.barcodeSelectionMethodChannel = barcodeSelectionMethodChannel
        self.barcodeCountModule = barcodeCountModule
        self.barcodeCountMethodChannel = barcodeCountMethodChannel
        self.sparkScanModule = sparkScanModule
        self.sparkScanMethodChannel = sparkScanMethodChannel
        self.barcodeFindModule = barcodeFindModule
        self.barcodeFindMethodChannel = barcodeFindMethodChannel
        self.barcodePickModule = barcodePickModule
        self.barcodePickMethodChannel = barcodePickMethodChannel
        self.barcodeArModule = barcodeArModule
        self.barcodeArMethodChannel = barcodeArMethodChannel
        self.barcodeGeneratorModule = barcodeGeneratorModule
        self.barcodeGeneratorMethodChannel = barcodeGeneratorMethodChannel

        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // Barcode
        let barcodeModule = BarcodeModule()
        barcodeModule.didStart()
        let barcodeMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode/method_channel",
                                                        binaryMessenger: registrar.messenger())
        let barcodeMethodHandler = BarcodeMethodHandler(barcodeModule: barcodeModule)
        barcodeMethodChannel.setMethodCallHandler(barcodeMethodHandler.methodCallHandler(methodCall:result:))

        // Barcode Capture
        let barcodeCaptureEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.capture/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let barcodeCaptureModule = BarcodeCaptureModule(
            emitter: barcodeCaptureEmitter
        )
        barcodeCaptureModule.didStart()
        let barcodeCaptureMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.capture/method_channel",
                                                               binaryMessenger: registrar.messenger())
        let barcodeCaptureMethodHandler = BarcodeCaptureMethodHandler(barcodeCaptureModule: barcodeCaptureModule)
        barcodeCaptureMethodChannel.setMethodCallHandler(barcodeCaptureMethodHandler.methodCallHandler(methodCall:result:))

        // Barcode Batch
        let barcodeBatchEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.batch/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let barcodeBatchModule = BarcodeBatchModule(
            emitter: barcodeBatchEmitter
        )
        barcodeBatchModule.didStart()
        let barcodeBatchMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.batch/method_channel",
                                                                binaryMessenger: registrar.messenger())
        let barcodeBatchMethodHandler = BarcodeBatchMethodHandler(barcodeBatchModule: barcodeBatchModule)
        barcodeBatchMethodChannel.setMethodCallHandler(barcodeBatchMethodHandler.methodCallHandler(methodCall:result:))

        // Barcode Selection
        let barcodeSelectionEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.selection/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let brushProviderQueue = DispatchQueue(label: "com.scandit.datacapture.flutter.brushprovider")
        let barcodeSelectionModule = BarcodeSelectionModule(
            barcodeSelectionListener: FrameworksBarcodeSelectionListener(emitter: barcodeSelectionEmitter),
            aimedBrushProvider: FrameworksBarcodeSelectionAimedBrushProvider(emitter: barcodeSelectionEmitter,
                                                                             queue: brushProviderQueue),
            trackedBrushProvider: FrameworksBarcodeSelectionTrackedBrushProvider(emitter: barcodeSelectionEmitter,
                                                                                 queue: brushProviderQueue))
        barcodeSelectionModule.didStart()
        let barcodeSelectionMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.selection/method_channel",
                                                                 binaryMessenger: registrar.messenger())
        let barcodeSelectionMethodHandler = BarcodeSelectionMethodHandler(barcodeSelectionModule: barcodeSelectionModule)
        barcodeSelectionMethodChannel.setMethodCallHandler(barcodeSelectionMethodHandler.methodCallHandler(methodCall:result:))

        // Barcode Count
        let barcodeCountEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.count/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let barcodeCountModule = BarcodeCountModule(emitter: barcodeCountEmitter)
        barcodeCountModule.didStart()

        let barcodeCountMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.count/method_channel",
                                                             binaryMessenger: registrar.messenger())
        let barcodeCountMethodHandler = BarcodeCountMethodHandler(barcodeCountModule: barcodeCountModule)
        barcodeCountMethodChannel.setMethodCallHandler(barcodeCountMethodHandler.methodCallHandler(methodCall:result:))

        let barcodeCountViewFactory = FlutterBarcodeCountViewFactory(barcodeCountModule: barcodeCountModule)
        registrar.register(barcodeCountViewFactory, withId: "com.scandit.BarcodeCountView")

        // Spark Scan
        let sparkScanEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.spark/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let sparkScanModule = SparkScanModule(emitter: sparkScanEmitter)
        sparkScanModule.didStart()

        let sparkScanMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.spark/method_channel",
                                                          binaryMessenger: registrar.messenger())
        let sparkScanMethodHandler = SparkScanMethodHandler(sparkScanModule: sparkScanModule)
        sparkScanMethodChannel.setMethodCallHandler(sparkScanMethodHandler.methodCallHandler(methodCall:result:))

        let sparkScanViewFactory = FlutterSparkScanViewFactory(sparkScanModule: sparkScanModule)
        registrar.register(sparkScanViewFactory, withId: "com.scandit.SparkScanView")

        // Barcode Find
        let barcodeFindEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.find/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let barcodeFindModule = BarcodeFindModule(emitter: barcodeFindEmitter)
        barcodeFindModule.didStart()

        let barcodeFindMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.find/method_channel",
                                                            binaryMessenger: registrar.messenger())
        let barcodeFindMethodHandler = BarcodeFindMethodHandler(barcodeFindModule: barcodeFindModule)
        barcodeFindMethodChannel.setMethodCallHandler(barcodeFindMethodHandler.methodCallHandler(methodCall:result:))

        let barcodeFindViewFactory = FlutterBarcodeFindViewFactory(barcodeFindModule: barcodeFindModule)
        registrar.register(barcodeFindViewFactory, withId: "com.scandit.BarcodeFindView")


        let barcodePickEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.pick/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let barcodePickModule = BarcodePickModule(emitter: barcodePickEmitter)
        barcodePickModule.didStart()

        let barcdePickMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.pick/method_channel",
                                                            binaryMessenger: registrar.messenger())
        let barcodePickMethodHandler = BarcodePickMethodHandler(barcodePickModule: barcodePickModule)
        barcdePickMethodChannel.setMethodCallHandler(barcodePickMethodHandler.methodCallHandler(methodCall:result:))
        let barcodePickViewFactory = FlutterBarcodePickViewFactory(barcodePickModule: barcodePickModule)
        registrar.register(barcodePickViewFactory, withId: "com.scandit.BarcodePickView")
        
        
        let barcodeArEmitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(name: "com.scandit.datacapture.barcode.ar/event_channel",
                                              binaryMessenger: registrar.messenger())
        )
        let barcodeArModule = BarcodeArModule(emitter: barcodeArEmitter)
        barcodeArModule.didStart()

        let barcodeArMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.ar/method_channel",
                                                            binaryMessenger: registrar.messenger())
        let barcodeArMethodHandler = BarcodeArMethodHandler(barcodeAr: barcodeArModule)
        barcodeArMethodChannel.setMethodCallHandler(barcodeArMethodHandler.methodCallHandler(methodCall:result:))
        let barcodeArViewFactory = FlutterBarcodeArViewFactory(barcodeArModule: barcodeArModule)
        registrar.register(barcodeArViewFactory, withId: "com.scandit.BarcodeArView")
        
        // Generator
        let barcodeGeneratorModule = BarcodeGeneratorModule()
        barcodeGeneratorModule.didStart()
        
        let barcodeGeneratorMethodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.barcode.generator/method_channel",
                                                                binaryMessenger: registrar.messenger())
        let barcodeGeneratorMethodHandler = BarcodeGeneratorHandler(barcodeGeneratorModule: barcodeGeneratorModule)
        barcodeGeneratorMethodChannel.setMethodCallHandler(barcodeGeneratorMethodHandler.methodCallHandler(methodCall:result:))

        let plugin = ScanditFlutterDataCaptureBarcode(barcodeModule: barcodeModule,
                                                      barcodeMethodChannel: barcodeMethodChannel,
                                                      barcodeCaptureModule: barcodeCaptureModule,
                                                      barcodeCaptureMethodChannel: barcodeCaptureMethodChannel,
                                                      barcodeBatchModule: barcodeBatchModule,
                                                      barcodeBatchMethodChannel: barcodeBatchMethodChannel,
                                                      barcodeSelectionModule: barcodeSelectionModule,
                                                      barcodeSelectionMethodChannel: barcodeSelectionMethodChannel,
                                                      barcodeCountModule: barcodeCountModule,
                                                      barcodeCountMethodChannel: barcodeCountMethodChannel,
                                                      sparkScanModule: sparkScanModule,
                                                      sparkScanMethodChannel: sparkScanMethodChannel,
                                                      barcodeFindModule: barcodeFindModule,
                                                      barcodeFindMethodChannel: barcodeFindMethodChannel,
                                                      barcodePickModule: barcodePickModule,
                                                      barcodePickMethodChannel: barcdePickMethodChannel,
                                                      barcodeArModule: barcodeArModule,
                                                      barcodeArMethodChannel: barcodeArMethodChannel,
                                                      barcodeGeneratorModule: barcodeGeneratorModule,
                                                      barcodeGeneratorMethodChannel: barcodeGeneratorMethodChannel
        )
        registrar.publish(plugin)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        barcodeModule.didStop()
        barcodeMethodChannel.setMethodCallHandler(nil)

        barcodeCaptureModule.didStop()
        barcodeCaptureMethodChannel.setMethodCallHandler(nil)

        barcodeBatchModule.didStop()
        barcodeBatchMethodChannel.setMethodCallHandler(nil)

        barcodeSelectionModule.didStop()
        barcodeSelectionMethodChannel.setMethodCallHandler(nil)

        barcodeCountModule.didStop()
        barcodeCountMethodChannel.setMethodCallHandler(nil)

        sparkScanModule.didStop()
        sparkScanMethodChannel.setMethodCallHandler(nil)

        barcodeFindModule.didStop()
        barcodeFindMethodChannel.setMethodCallHandler(nil)
        
        barcodeArModule.didStop()
        barcodeArMethodChannel.setMethodCallHandler(nil)
        
        barcodeGeneratorModule.didStop()
        barcodeGeneratorMethodChannel.setMethodCallHandler(nil)
    }
}
