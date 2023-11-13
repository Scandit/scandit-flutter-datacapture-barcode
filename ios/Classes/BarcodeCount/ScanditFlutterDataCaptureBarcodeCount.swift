/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import scandit_flutter_datacapture_core

@objc
public class ScanditFlutterDataCaptureBarcodeCount: NSObject, FLTDataCaptureContextListener {
    private enum FunctionNames {
        static let addBarcodeCountListener = "addBarcodeCountListener"
        static let removeBarcodeCountListener = "removeBarcodeCountListener"
        static let addBarcodeCountViewListener = "addBarcodeCountViewListener"
        static let removeBarcodeCountViewListener = "removeBarcodeCountViewListener"
        static let addBarcodeCountViewUiListener = "addBarcodeCountViewUiListener"
        static let removeBarcodeCountViewUiListener = "removeBarcodeCountViewUiListener"

        static let updateBarcodeCount = "updateBarcodeCountMode"
        static let updateBarcodeCountView = "updateBarcodeCountView"

        static let resetBarcodeCountSession = "resetBarcodeCountSession"
        static let getBarcodeCountLastFrameData = "getBarcodeCountLastFrameData"
        static let resetBarcodeCount = "resetBarcodeCount"
        static let startScanningPhase = "startScanningPhase"
        static let endScanningPhase = "endScanningPhase"
        static let setBarcodeCountCaptureList = "setBarcodeCountCaptureList"

        static let clearHighlights = "clearHighlights"

        static let finishDidScan = "barcodeCountFinishOnScan"

        static let finishBrushForRecognizedBarcode = "finishBrushForRecognizedBarcodeEvent"
        static let finishBrushForUnrecognizedBarcode = "finishBrushForUnrecognizedBarcodeEvent"
        static let finishBrushForRecognizedBarcodeNotInListEvent = "finishBrushForRecognizedBarcodeNotInListEvent"
        
        static let getBarcodeCaptureDefaults = "getBarcodeCountDefaults"
    }

    let barcodeCountMethodChannel: FlutterMethodChannel
    let barcodeCountEventChannel: FlutterEventChannel

    var sink: FlutterEventSink?

    internal var hasListeners = false

    internal let didScanLock = CallbackLock<Bool>(name: FlutterBarcodeCountEvent.didScan.rawValue)

    let barcodeCountDeserializer = BarcodeCountDeserializer()
    let barcodeCountViewDeserializer = BarcodeCountViewDeserializer()

    var barcodeCountViewListener: FlutterBarcodeCountViewListener
    var barcodeCountViewUIListener: FlutterBarcodeCountViewUIListener

    let barcodeCountSessionHolder = FlutterBarcodeCountSessionHolder()

    var context: DataCaptureContext?
    var barcodeCount: BarcodeCount? {
        willSet {
            barcodeCount?.remove(self)
        }
        didSet {
            barcodeCount?.add(self)
            barcodeCount?.setCaptureList(barcodeCountCaptureList)
        }
    }
    var barcodeCountView: BarcodeCountView?
    var barcodeCountCaptureList: BarcodeCountCaptureList?

    init(with binaryMessenger: FlutterBinaryMessenger) {
        let eventChannelName = "com.scandit.datacapture.barcode.count/event_channel"
        barcodeCountEventChannel = FlutterEventChannel(name: eventChannelName,
                                           binaryMessenger: binaryMessenger)
        let methodChannelName = "com.scandit.datacapture.barcode.count/method_channel"
        barcodeCountMethodChannel = FlutterMethodChannel(name: methodChannelName,
                                             binaryMessenger: binaryMessenger)
       
        barcodeCountViewUIListener = FlutterBarcodeCountViewUIListener()
       
        barcodeCountViewListener = FlutterBarcodeCountViewListener()
       
        super.init()
        barcodeCountEventChannel.setStreamHandler(self)
        barcodeCountMethodChannel.setMethodCallHandler(methodCallHandler)
        
        ScanditFlutterDataCaptureCore.addFLTContextListener(self)
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch methodCall.method {
        case FunctionNames.addBarcodeCountListener:
            addBarcodeCountListener(result)
        case FunctionNames.removeBarcodeCountListener:
            removeBarcodeCountListener(result)
        case FunctionNames.addBarcodeCountViewListener:
            addBarcodeCountViewListener(result)
        case FunctionNames.removeBarcodeCountViewListener:
            removeBarcodeCountViewListener(result)
        case FunctionNames.addBarcodeCountViewUiListener:
            addBarcodeCountViewUIListener(result)
        case FunctionNames.removeBarcodeCountViewUiListener:
            removeBarcodeCountViewUIListener(result)
        case FunctionNames.clearHighlights:
            clearHighlights(result)
        case FunctionNames.finishBrushForRecognizedBarcode:
            setBrushForRecognizedBarcode(arguments: methodCall.arguments, result: result)
        case FunctionNames.finishBrushForUnrecognizedBarcode:
            setBrushForUnrecognizedBarcode(arguments: methodCall.arguments, result: result)
        case FunctionNames.finishBrushForRecognizedBarcodeNotInListEvent:
            setBrushForRecognizedBarcodeNoInList(arguments: methodCall.arguments, result: result)
        case FunctionNames.finishDidScan:
            finishDidScanCallback(enabled: methodCall.arguments as? Bool ?? false, result: result)
        case FunctionNames.updateBarcodeCount:
            updateBarcodeCount(jsonString: methodCall.arguments as? String, result: result)
        case FunctionNames.updateBarcodeCountView:
            updateBarcodeCountView(jsonString: methodCall.arguments as? String, result: result)
        case FunctionNames.getBarcodeCountLastFrameData:
            ScanditFlutterDataCaptureCore.getLastFrameData(reply: result)
        case FunctionNames.resetBarcodeCountSession:
            resetBarcodeCountSession(frameSequenceId: methodCall.arguments as? Int, result: result)
        case FunctionNames.resetBarcodeCount:
            resetBarcodeCount(result: result)
        case FunctionNames.startScanningPhase:
            startScanningPhase(result: result)
        case FunctionNames.endScanningPhase:
            endScanningPhase(result: result)
        case FunctionNames.setBarcodeCountCaptureList:
            setCaptureList(jsonString: methodCall.arguments as? String, result: result)
        case FunctionNames.getBarcodeCaptureDefaults:
            defaults(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func addBarcodeCountListener(_ result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    func removeBarcodeCountListener(_ result: FlutterResult) {
        hasListeners = false
        unlockLocks()
        result(nil)
    }

    func addBarcodeCountViewListener(_ result: FlutterResult) {
        barcodeCountViewListener.addBarcodeCountViewListener(result)
    }

    func removeBarcodeCountViewListener(_ result: FlutterResult) {
        barcodeCountViewListener.removeBarcodeCountViewListener(result)
    }

    func addBarcodeCountViewUIListener(_ result: FlutterResult) {
        barcodeCountViewUIListener.addBarcodeCountViewUIListener(result)
    }

    func removeBarcodeCountViewUIListener(_ result: FlutterResult) {
        barcodeCountViewUIListener.removeBarcodeCountViewUIListener(result)
    }

    func clearHighlights(_ result: FlutterResult) {
        barcodeCountView?.clearHighlights()
        result(nil)
    }

    func updateBarcodeCount(jsonString: String?, result: FlutterResult) {
        guard let jsonString = jsonString else {
            result(FlutterError(code: "-2", message: "JSON is needed to update the barcode count mode", details: nil))
            return
        }
        if var barcodeCount = barcodeCount {
            do {
                barcodeCount = try barcodeCountDeserializer.updateMode(barcodeCount, fromJSONString: jsonString)
                self.barcodeCount = barcodeCount
            } catch let error as NSError {
                result(FlutterError(code: error.domain, message: error.localizedDescription, details: error))
                return
            }
        } else {
            guard let context = context else {
                return
            }
            do {
                barcodeCount = try barcodeCountDeserializer.mode(fromJSONString: jsonString, context: context)
            } catch let error as NSError {
                result(FlutterError(code: error.domain, message: error.localizedDescription, details: error))
                return
            }
        }
        let jsonValue = JSONValue(string: jsonString)
        if jsonValue.containsKey("enabled") {
            barcodeCount?.isEnabled = jsonValue.bool(forKey: "enabled")
        }
        result(nil)
    }

    func updateBarcodeCountView(jsonString: String?, result: FlutterResult) {
        guard let context = context else {
            return
        }
        guard let jsonString = jsonString else {
            result(FlutterError(code: "-2", message: "JSON is needed to update the barcode count view", details: nil))
            return
        }
        guard var view = barcodeCountView else {
            result(FlutterError(code: "-4", message: "The barcode count view is not set", details: nil))
            return
        }
        do {
            view = try barcodeCountViewDeserializer.update(view, fromJSONString: jsonString,
                                                           context: context)
        } catch let error as NSError {
            result(FlutterError(code: error.domain, message: error.localizedDescription, details: error))
        }
        result(nil)
    }

    func resetBarcodeCountSession(frameSequenceId: Int?, result: FlutterResult) {
        barcodeCountSessionHolder.reset(frameSequenceId: frameSequenceId)
        result(nil)
    }

    func resetBarcodeCount(result: FlutterResult) {
        barcodeCount?.reset()
        result(nil)
    }

    func startScanningPhase(result: FlutterResult) {
        barcodeCount?.startScanningPhase()
        result(nil)
    }

    func endScanningPhase(result: FlutterResult) {
        barcodeCount?.endScanningPhase()
        result(nil)
    }

    func setCaptureList(jsonString: String?, result: FlutterResult) {
        guard let jsonString = jsonString else {
            result(FlutterError(code: "-2", message: "JSON is needed to set the capture list", details: nil))
            return
        }
      
        let jsonArray = JSONValue(string: jsonString).asArray()
        let targetBarcodes = Set((0...jsonArray.count() - 1).map { jsonArray.atIndex($0).asObject() }.map {
            TargetBarcode(data: $0.string(forKey: "data"), quantity: $0.integer(forKey: "quantity"))
        })
        
        barcodeCountCaptureList = BarcodeCountCaptureList(listener: self, targetBarcodes: targetBarcodes)
        
        guard let mode = barcodeCount else {
            return
        }
        mode.setCaptureList(barcodeCountCaptureList)
        result(nil)
    }

    func add(_ view: FlutterBarcodeCountView, from json: String) {
        guard let context = context else {
            return
        }
        let jsonObject = JSONValue(string: json)
        if !jsonObject.containsKey("BarcodeCount") {
            return
        }
        let barcodeCountModeJson = jsonObject.object(forKey: "BarcodeCount").jsonString()
        if var barcodeCount = barcodeCount {
            do {
                barcodeCount = try barcodeCountDeserializer.updateMode(barcodeCount,
                                                                       fromJSONString: barcodeCountModeJson,
                                                                       context: context)
            } catch {
                return
            }
        } else {
            do {
                barcodeCount = try barcodeCountDeserializer.mode(fromJSONString: barcodeCountModeJson,
                                                                 context: context)
            } catch {
                return
            }
        }
        
        if !jsonObject.containsKey("View") {
            return
        }
        let barcodeCountViewJson = jsonObject.object(forKey: "View").jsonString()
        do {
            let bcView = try barcodeCountViewDeserializer.view(fromJSONString: barcodeCountViewJson,
                                                               barcodeCount: barcodeCount!,
                                                               context: context)
            bcView.delegate = barcodeCountViewListener
            bcView.uiDelegate = barcodeCountViewUIListener
            view.addSubview(bcView)
            barcodeCountView = bcView
        } catch {
            return
        }
    }

    func unlockLocks() {
        didScanLock.reset()
    }

    func dispose() {
        ScanditFlutterDataCaptureCore.removeFLTContextListener(self)
        disposeBarcodeCountView()
        barcodeCountEventChannel.setStreamHandler(nil)
        barcodeCountMethodChannel.setMethodCallHandler(nil)
        unlockLocks()
        barcodeCountViewListener.dispose()
        barcodeCountViewUIListener.dispose()
    }

    func disposeBarcodeCountView() {
        guard let barcodeCountView = barcodeCountView else { return }
        barcodeCountView.delegate = nil
        barcodeCountView.uiDelegate = nil
        barcodeCountView.removeFromSuperview()
        self.barcodeCountView = nil
        barcodeCount = nil
    }
    
    func defaults(result: FlutterResult) {
        do {
            let jsonString = String(data: try JSONSerialization.data(withJSONObject: defaults,
                                                                     options: []),
                                    encoding: .utf8)
            result(jsonString)
        } catch {
            result(FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: nil))
        }
    }

    public func didUpdate(dataCaptureContext: DataCaptureContext?) {
        context = dataCaptureContext
    }
    
    private func setBrushForRecognizedBarcode(arguments: Any?, result: FlutterResult) {
        guard let parsedArgs = arguments as? [String: Any?] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        let trackedBarcodeId = parsedArgs["identifier"] as? Int ?? 0
        guard let brushJson = parsedArgs["brush"] as? String else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        let brush =  Brush(jsonString: brushJson)
        guard let trackedBarcode = barcodeCountViewListener.getTrackedBarcodeForBrushForRecognizedEvent(trackedBarcodeId: trackedBarcodeId) else {
            result(nil)
            return
        }
        barcodeCountView?.setBrush(brush, forRecognizedBarcode: trackedBarcode)
        result(nil)
    }
    
    private func setBrushForUnrecognizedBarcode(arguments: Any?, result: FlutterResult) {
        guard let parsedArgs = arguments as? [String: Any?] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        let trackedBarcodeId = parsedArgs["identifier"] as? Int ?? 0
        guard let brushJson = parsedArgs["brush"] as? String else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        let brush =  Brush(jsonString: brushJson)
        guard let trackedBarcode = barcodeCountViewListener.getTrackedBarcodeForBrushForUnrecognizedEvent(trackedBarcodeId: trackedBarcodeId) else {
            result(nil)
            return
        }
        barcodeCountView?.setBrush(brush, forUnrecognizedBarcode: trackedBarcode)
        result(nil)
    }
    
    private func setBrushForRecognizedBarcodeNoInList(arguments: Any?, result: FlutterResult) {
        guard let parsedArgs = arguments as? [String: Any?] else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        let trackedBarcodeId = parsedArgs["identifier"] as? Int ?? 0
        guard let brushJson = parsedArgs["brush"] as? String else {
            result(ScanditDataCaptureBarcodeErrorWrapper(error: .deserializationError))
            return
        }
        let brush =  Brush(jsonString: brushJson)
        guard let trackedBarcode = barcodeCountViewListener.getTrackedBarcodeForBrushForBarcodeNotInListEvent(trackedBarcodeId: trackedBarcodeId) else {
            result(nil)
            return
        }
        barcodeCountView?.setBrush(brush, forRecognizedBarcodeNotInList: trackedBarcode)
        result(nil)
    }
}
