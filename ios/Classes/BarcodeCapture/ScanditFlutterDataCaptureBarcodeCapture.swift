/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation
import scandit_flutter_datacapture_core

class ScanditFlutterDataCaptureBarcodeCapture: NSObject {
    private enum FunctionNames {
        static let finishDidScan = "finishDidScan"
        static let finishDidUpdateSession = "finishDidUpdateSession"
        static let getBarcodeCaptureDefaults = "getBarcodeCaptureDefaults"
        static let addBarcodeCaptureListener = "addBarcodeCaptureListener"
        static let removeBarcodeCaptureListener = "removeBarcodeCaptureListener"
    }

    let eventChannel: FlutterEventChannel
    let methodChannel: FlutterMethodChannel

    internal var sink: FlutterEventSink?

    internal var hasListeners = false

    internal let didUpdateSessionLock: CallbackLock<Bool> = {
        let name = ScanditFlutterDataCaptureBarcodeCaptureEvent.didUpdateSession.rawValue
        return CallbackLock<Bool>(name: name)
    }()
    internal let didScanLock = CallbackLock<Bool>(name: ScanditFlutterDataCaptureBarcodeCaptureEvent.didScan.rawValue)

    init(with binaryMessenger: FlutterBinaryMessenger) {
        let prefix = "com.scandit.datacapture.barcode.capture"
        let eventChannelName = "\(prefix).event/barcode_capture_listener"
        eventChannel = FlutterEventChannel(name: eventChannelName,
                                           binaryMessenger: binaryMessenger)
        let methodChannelName = "\(prefix).method/barcode_capture_listener"
        methodChannel = FlutterMethodChannel(name: methodChannelName,
                                             binaryMessenger: binaryMessenger)
        super.init()
        eventChannel.setStreamHandler(self)
        methodChannel.setMethodCallHandler(methodCallHandler)
        registerDeserializer()
    }

    public func methodCallHandler(methodCall: FlutterMethodCall, result: FlutterResult) {
        switch methodCall.method {
        case FunctionNames.addBarcodeCaptureListener:
            addBarcodeCaptureListener(result: result)
        case FunctionNames.removeBarcodeCaptureListener:
            removeBarcodeCaptureListener(result: result)
        case FunctionNames.finishDidScan:
            finishDidScan(enabled: methodCall.arguments as? Bool ?? false, result: result)
        case FunctionNames.finishDidUpdateSession:
            finishDidUpdate(enabled: methodCall.arguments as? Bool ?? false, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func unlockLocks() {
        didUpdateSessionLock.reset()
        didScanLock.reset()
    }

    func addBarcodeCaptureListener(result: FlutterResult) {
        hasListeners = true
        result(nil)
    }

    func removeBarcodeCaptureListener(result: FlutterResult) {
        hasListeners = false
        unlockLocks()
        result(nil)
    }

    func finishDidScan(enabled: Bool, result: FlutterResult) {
        finishDidScanCallback(enabled: enabled)
        result(nil)
    }

    func finishDidUpdate(enabled: Bool, result: FlutterResult) {
        finishDidUpdateSessionCallback(enabled: enabled)
        result(nil)
    }

    func dispose() {
        eventChannel.setStreamHandler(nil)
        methodChannel.setMethodCallHandler(nil)
        unlockLocks()
    }
}
