/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditBarcodeCapture
import scandit_flutter_datacapture_core

enum ScanditDataCaptureBarcodeError: Int, CustomNSError {
    case invalidSequenceId = 1
    case trackedBarcodeNotFound
    case brushInvalid
    case nilOverlay
    case viewInvalid
    case deserializationError

    var domain: String { return "ScanditDataCaptureBarcodeErrorDomain" }

    var code: Int {
        return rawValue
    }

    var message: String {
        switch self {
        case .invalidSequenceId:
            return "The sequence id does not match the current sequence id."
        case .trackedBarcodeNotFound:
            return "Tracked barcode not found."
        case .brushInvalid:
            return "It was not possible to deserialize a valid Brush."
        case .nilOverlay:
            return "Overlay is null."
        case .viewInvalid:
            return "It was not possible to deserialize a valid View."
        case .deserializationError:
            return "Unable to deserialize a valid object."
        }
    }

    var errorUserInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: message]
    }
}

final class ScanditDataCaptureBarcodeErrorWrapper: FlutterError {
    convenience init(error: ScanditDataCaptureBarcodeError) {
        self.init(code: "\(error.code)", message: error.message, details: nil)
    }
}

@objc
protocol ScanditFlutterDataCaptureBarcodeTrackingProtocol: class {
    func addBarcodeTrackingListener(result: FlutterResult)
    func removeBarcodeTrackingListener(result: FlutterResult)
    func addAdvancedOverlayDelegate(result: FlutterResult)
    func removeAdvancedOverlayDelegate(result: FlutterResult)
    func addBasicOverlayDelegate(result: FlutterResult)
    func removeBasicOverlayDelegate(result: FlutterResult)
    func finishDidUpdateSessionCallback(enabled: Bool, result: FlutterResult)
    func dispose()
}

@objc
public class ScanditFlutterDataCaptureBarcodeTracking: NSObject, ScanditFlutterDataCaptureBarcodeTrackingProtocol {
    internal let barcodeTrackingEventChannel: FlutterEventChannel
    internal let basicOverlayEventChannel: FlutterEventChannel
    internal let advancedOverlayEventChannel: FlutterEventChannel

    internal let barcodeTrackingMethodChannel: FlutterMethodChannel
    internal let basicOverlayMethodChannel: FlutterMethodChannel
    internal let advancedOverlayMethodChannel: FlutterMethodChannel

    internal var barcodeTrackingSink: FlutterEventSink?

    internal let basicOverlayStreamHandler: BarcodeTrackingBasicOverlayStreamHandler
    internal let advancedOverlayStreamHandler: BarcodeTrackingAdvancedOverlayStreamHandler

    internal var hasListeners = false

    internal let didUpdateSessionLock: CallbackLock<Bool> = {
        return CallbackLock<Bool>(name: ScanditFlutterDataCaptureBarcodeTrackingEvent.didUpdateSession.rawValue)
    }()

    internal var sessionHolder = ScanditFlutterDataCaptureBarcodeTrackingSessionHolder()

    internal var trackedBarcodeViewCache: [UIImageView: TrackedBarcode] = [:]

    // BarcodeTrackingBasicOverlay
    internal var barcodeTrackingBasicOverlay: BarcodeTrackingBasicOverlay?
    internal let brushForTrackedBarcodeLock: CallbackLock<Brush> = {
        let name = BarcodeTrackingBasicOverlayEvent.brushForTrackedBarcode.rawValue
        return CallbackLock<Brush>(name: name)
    }()

    // BarcodeTrackingAdvanceOverlay
    internal var barcodeTrackingAdvancedOverlay: BarcodeTrackingAdvancedOverlay?

    @objc
    public init(with messenger: FlutterBinaryMessenger,
                simpleOverlayStreamHandler: BarcodeTrackingBasicOverlayStreamHandler,
                advancedOverlayStreamHandler: BarcodeTrackingAdvancedOverlayStreamHandler) {
        self.basicOverlayStreamHandler = simpleOverlayStreamHandler
        self.advancedOverlayStreamHandler = advancedOverlayStreamHandler
        let pluginPrefix = "com.scandit.datacapture.barcode.tracking"
        let trackingChannelName = "\(pluginPrefix).event/barcode_tracking_listener"
        barcodeTrackingEventChannel = FlutterEventChannel(name: trackingChannelName,
                                                          binaryMessenger: messenger)
        let advancedOverlayChannelName = "\(pluginPrefix).event/barcode_tracking_advanced_overlay"
        advancedOverlayEventChannel = FlutterEventChannel(name: advancedOverlayChannelName,
                                                                         binaryMessenger: messenger)
        let basicOverlayChannelName = "\(pluginPrefix).event/barcode_tracking_basic_overlay"
        basicOverlayEventChannel = FlutterEventChannel(name: basicOverlayChannelName,
                                                       binaryMessenger: messenger)
        let barcodeTrackingListenerChannelName = "\(pluginPrefix).method/barcode_tracking_listener"
        barcodeTrackingMethodChannel = FlutterMethodChannel(name: barcodeTrackingListenerChannelName,
                                                            binaryMessenger: messenger)
        let basicOverlayMethodChannelName = "\(pluginPrefix).method/barcode_tracking_basic_overlay"
        basicOverlayMethodChannel = FlutterMethodChannel(name: basicOverlayMethodChannelName,
                                                         binaryMessenger: messenger)
        let advancedOverlayMethodChannelName = "\(pluginPrefix).method/barcode_tracking_advanced_overlay"
        advancedOverlayMethodChannel = FlutterMethodChannel(name: advancedOverlayMethodChannelName,
                                                            binaryMessenger: messenger)

        super.init()
        barcodeTrackingEventChannel.setStreamHandler(self)
        barcodeTrackingMethodChannel.setMethodCallHandler(barcodeTrackingMethodCallHandler)
        advancedOverlayEventChannel.setStreamHandler(advancedOverlayStreamHandler)
        basicOverlayEventChannel.setStreamHandler(basicOverlayStreamHandler)
        basicOverlayMethodChannel.setMethodCallHandler(basicOverlayMethodCallHandler)
        advancedOverlayMethodChannel.setMethodCallHandler(advancedOverlayMethodCallHandler)
        registerDeserializer()
    }

    public func addBarcodeTrackingListener(result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    public func removeBarcodeTrackingListener(result: FlutterResult) {
        hasListeners = false
        result(nil)
    }

    public func addAdvancedOverlayDelegate(result: FlutterResult) {
        advancedOverlayStreamHandler.hasListeners = true
        result(nil)
    }

    public func removeAdvancedOverlayDelegate(result: FlutterResult) {
        advancedOverlayStreamHandler.hasListeners = false
        result(nil)
    }

    public func addBasicOverlayDelegate(result: FlutterResult) {
        basicOverlayStreamHandler.hasListeners = true
        barcodeTrackingBasicOverlay?.delegate = self
        result(nil)
    }

    public func removeBasicOverlayDelegate(result: FlutterResult) {
        basicOverlayStreamHandler.hasListeners = false
        barcodeTrackingBasicOverlay?.delegate = nil
        result(nil)
    }

    public func resetSession(call: FlutterMethodCall, result: FlutterResult) {
        sessionHolder.reset(frameSequenceId: call.arguments as? Int)
        result(nil)
    }

    func invalidate() {
        unlockLocks()
    }

    internal func unlockLocks() {
        didUpdateSessionLock.reset()
        brushForTrackedBarcodeLock.reset()
    }

    @objc
    public func dispose() {
        barcodeTrackingEventChannel.setStreamHandler(nil)
        advancedOverlayEventChannel.setStreamHandler(nil)
        basicOverlayEventChannel.setStreamHandler(nil)
        barcodeTrackingMethodChannel.setMethodCallHandler(nil)
        basicOverlayMethodChannel.setMethodCallHandler(nil)
        advancedOverlayMethodChannel.setMethodCallHandler(nil)
        unlockLocks()
    }

    func barcodeTrackingMethodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        enum FunctionNames {
            static let barcodeTrackingFinishDidUpdateSession = "barcodeTrackingFinishDidUpdateSession"
            static let addBarcodeTrackingListener = "addBarcodeTrackingListener"
            static let removeBarcodeTrackingListener = "removeBarcodeTrackingListener"
            static let resetBarcodeTrackingSession = "resetBarcodeTrackingSession"
            static let getLastFrameData = "getLastFrameData"
        }
        switch methodCall.method {
        case FunctionNames.barcodeTrackingFinishDidUpdateSession:
            let enabled = methodCall.arguments as? Bool ?? false
            finishDidUpdateSessionCallback(enabled: enabled, result: result)
        case FunctionNames.addBarcodeTrackingListener:
            addBarcodeTrackingListener(result: result)
        case FunctionNames.removeBarcodeTrackingListener:
            removeBarcodeTrackingListener(result: result)
        case FunctionNames.resetBarcodeTrackingSession:
            resetSession(call: methodCall, result: result)
        case FunctionNames.getLastFrameData:
            ScanditFlutterDataCaptureCore.getLastFrameData(reply: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func basicOverlayMethodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        enum FunctionNames {
            static let setBrushForTrackedBarcode = "setBrushForTrackedBarcode"
            static let clearTrackedBarcodeBrushes = "clearTrackedBarcodeBrushes"
            static let addBasicOverlayDelegate = "subscribeBarcodeTrackingBasicOverlayListener"
            static let removeBasicOverlayDelegate = "unsubscribeBarcodeTrackingBasicOverlayListener"
            static let finishBrushForTrackedBarcodeCallback = "finishBrushForTrackedBarcodeCallback"
        }
        switch methodCall.method {
        case FunctionNames.addBasicOverlayDelegate:
            addBasicOverlayDelegate(result: result)
        case FunctionNames.removeBasicOverlayDelegate:
            removeBasicOverlayDelegate(result: result)
        case FunctionNames.setBrushForTrackedBarcode:
            setBrushForTrackedBarcode(arguments: methodCall.arguments as! String, result: result)
        case FunctionNames.clearTrackedBarcodeBrushes:
            clearTrackedBarcodeBrushes(result: result)
        case FunctionNames.finishBrushForTrackedBarcodeCallback:
            basicOverlayStreamHandler.finishBrushForTrackedBarcodeCallback(arguments: methodCall.arguments as? String,
                                                                           result: result,
                                                                           lock: brushForTrackedBarcodeLock)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func advancedOverlayMethodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        enum FunctionNames {
            static let setWidgetForTrackedBarcode = "setWidgetForTrackedBarcode"
            static let setAnchorForTrackedBarcode = "setAnchorForTrackedBarcode"
            static let setOffsetForTrackedBarcode = "setOffsetForTrackedBarcode"
            static let clearTrackedBarcodeWidgets = "clearTrackedBarcodeWidgets"
            static let addBarcodeTrackingAdvancedOverlayDelegate = "addBarcodeTrackingAdvancedOverlayDelegate"
            static let removeBarcodeTrackingAdvancedOverlayDelegate = "removeBarcodeTrackingAdvancedOverlayDelegate"
        }
        switch methodCall.method {
        case FunctionNames.setWidgetForTrackedBarcode:
            setWidgetForTrackedBarcode(arguments: methodCall.arguments, result: result)
        case FunctionNames.setAnchorForTrackedBarcode:
            setAnchorForTrackedBarcode(arguments: methodCall.arguments, result: result)
        case FunctionNames.setOffsetForTrackedBarcode:
            setOffsetForTrackedBarcode(arguments: methodCall.arguments, result: result)
        case FunctionNames.clearTrackedBarcodeWidgets:
            clearTrackedBarcodeWidgets(result: result)
        case FunctionNames.addBarcodeTrackingAdvancedOverlayDelegate:
            advancedOverlayStreamHandler.hasListeners = true
            result(nil)
        case FunctionNames.removeBarcodeTrackingAdvancedOverlayDelegate:
            advancedOverlayStreamHandler.hasListeners = false
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
