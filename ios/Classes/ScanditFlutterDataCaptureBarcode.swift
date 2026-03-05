/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

@objc
public class ScanditFlutterDataCaptureBarcode: NSObject, FlutterPlugin {
    private let barcodeModule: BarcodeModule
    private let barcodeMethodChannel: FlutterMethodChannel

    private let barcodeCaptureModule: BarcodeCaptureModule

    private let barcodeBatchModule: BarcodeBatchModule

    private let barcodeSelectionModule: BarcodeSelectionModule

    private let barcodeCountModule: BarcodeCountModule

    private let sparkScanModule: SparkScanModule

    private let barcodeFindModule: BarcodeFindModule

    private let barcodePickModule: BarcodePickModule

    private let barcodeArModule: BarcodeArModule

    private let barcodeGeneratorModule: BarcodeGeneratorModule

    init(
        barcodeModule: BarcodeModule,
        barcodeMethodChannel: FlutterMethodChannel,
        barcodeCaptureModule: BarcodeCaptureModule,
        barcodeBatchModule: BarcodeBatchModule,
        barcodeSelectionModule: BarcodeSelectionModule,
        barcodeCountModule: BarcodeCountModule,
        sparkScanModule: SparkScanModule,
        barcodeFindModule: BarcodeFindModule,
        barcodePickModule: BarcodePickModule,
        barcodeArModule: BarcodeArModule,
        barcodeGeneratorModule: BarcodeGeneratorModule
    ) {
        self.barcodeModule = barcodeModule
        self.barcodeMethodChannel = barcodeMethodChannel
        self.barcodeCaptureModule = barcodeCaptureModule
        self.barcodeBatchModule = barcodeBatchModule
        self.barcodeSelectionModule = barcodeSelectionModule
        self.barcodeCountModule = barcodeCountModule
        self.sparkScanModule = sparkScanModule
        self.barcodeFindModule = barcodeFindModule
        self.barcodePickModule = barcodePickModule
        self.barcodeArModule = barcodeArModule
        self.barcodeGeneratorModule = barcodeGeneratorModule

        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let barcodeModule = setupBarcodeModule(with: registrar)
        let barcodeCaptureModule = setupBarcodeCaptureModule(with: registrar)
        let barcodeBatchModule = setupBarcodeBatchModule(with: registrar)
        let barcodeSelectionModule = setupBarcodeSelectionModule(with: registrar)
        let barcodeCountModule = setupBarcodeCountModule(with: registrar)
        let sparkScanModule = setupSparkScanModule(with: registrar)
        let barcodeFindModule = setupBarcodeFindModule(with: registrar)
        let barcodePickModule = setupBarcodePickModule(with: registrar)
        let barcodeArModule = setupBarcodeArModule(with: registrar)
        let barcodeGeneratorModule = setupBarcodeGeneratorModule()

        let plugin = ScanditFlutterDataCaptureBarcode(
            barcodeModule: barcodeModule.module,
            barcodeMethodChannel: barcodeModule.methodChannel,
            barcodeCaptureModule: barcodeCaptureModule,
            barcodeBatchModule: barcodeBatchModule,
            barcodeSelectionModule: barcodeSelectionModule,
            barcodeCountModule: barcodeCountModule,
            sparkScanModule: sparkScanModule,
            barcodeFindModule: barcodeFindModule,
            barcodePickModule: barcodePickModule,
            barcodeArModule: barcodeArModule,
            barcodeGeneratorModule: barcodeGeneratorModule
        )
        registrar.publish(plugin)
    }

    private static func setupBarcodeModule(
        with registrar: FlutterPluginRegistrar
    ) -> (module: BarcodeModule, methodChannel: FlutterMethodChannel) {
        let module = BarcodeModule()
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        let methodChannel = FlutterMethodChannel(
            name: "com.scandit.datacapture.barcode/method_channel",
            binaryMessenger: registrar.messenger()
        )
        let methodHandler = BarcodeMethodHandler(barcodeModule: module)
        methodChannel.setMethodCallHandler(methodHandler.methodCallHandler(methodCall:result:))

        return (module, methodChannel)
    }

    private static func setupBarcodeCaptureModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodeCaptureModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.capture/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodeCaptureModule(emitter: emitter)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        return module
    }

    private static func setupBarcodeBatchModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodeBatchModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.batch/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodeBatchModule(emitter: emitter, viewFromJsonResolver: nil)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        return module
    }

    private static func setupBarcodeSelectionModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodeSelectionModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.selection/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodeSelectionModule(
            emitter: emitter,
            aimedBrushProvider: FrameworksBarcodeSelectionAimedBrushProvider(
                emitter: emitter
            ),
            trackedBrushProvider: FrameworksBarcodeSelectionTrackedBrushProvider(
                emitter: emitter
            )
        )
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        return module
    }

    private static func setupBarcodeCountModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodeCountModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.count/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodeCountModule(emitter: emitter)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        let viewFactory = FlutterBarcodeCountViewFactory(barcodeCountModule: module)
        registrar.register(viewFactory, withId: "com.scandit.BarcodeCountView")

        return module
    }

    private static func setupSparkScanModule(
        with registrar: FlutterPluginRegistrar
    ) -> SparkScanModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.spark/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = SparkScanModule(emitter: emitter)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        let viewFactory = FlutterSparkScanViewFactory(sparkScanModule: module)
        registrar.register(viewFactory, withId: "com.scandit.SparkScanView")

        return module
    }

    private static func setupBarcodeFindModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodeFindModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.find/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodeFindModule(emitter: emitter)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        let viewFactory = FlutterBarcodeFindViewFactory(barcodeFindModule: module)
        registrar.register(viewFactory, withId: "com.scandit.BarcodeFindView")

        return module
    }

    private static func setupBarcodePickModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodePickModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.pick/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodePickModule(emitter: emitter)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        let viewFactory = FlutterBarcodePickViewFactory(barcodePickModule: module)
        registrar.register(viewFactory, withId: "com.scandit.BarcodePickView")

        return module
    }

    private static func setupBarcodeArModule(
        with registrar: FlutterPluginRegistrar
    ) -> BarcodeArModule {
        let emitter = FlutterEventEmitter(
            eventChannel: FlutterEventChannel(
                name: "com.scandit.datacapture.barcode.ar/event_channel",
                binaryMessenger: registrar.messenger()
            )
        )
        let module = BarcodeArModule(emitter: emitter)
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        let viewFactory = FlutterBarcodeArViewFactory(barcodeArModule: module)
        registrar.register(viewFactory, withId: "com.scandit.BarcodeArView")

        return module
    }

    private static func setupBarcodeGeneratorModule() -> BarcodeGeneratorModule {
        let module = BarcodeGeneratorModule()
        module.didStart()
        DefaultServiceLocator.shared.register(module: module)

        return module
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        barcodeModule.didStop()
        barcodeMethodChannel.setMethodCallHandler(nil)

        barcodeCaptureModule.didStop()

        barcodeBatchModule.didStop()

        barcodeSelectionModule.didStop()

        barcodeCountModule.didStop()

        sparkScanModule.didStop()

        barcodePickModule.didStop()

        barcodeFindModule.didStop()

        barcodeArModule.didStop()

        barcodeGeneratorModule.didStop()
    }
}
