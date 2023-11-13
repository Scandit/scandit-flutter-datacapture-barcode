/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Foundation
import scandit_flutter_datacapture_core
import ScanditBarcodeCapture

@objc
public protocol ScanditFlutterDataCaptureBarcodeSelectionProtocol {
    func resetBarcodeSelection(result: FlutterResult)
    func unfreezeCamera(result: FlutterResult)
    func addListener(result: FlutterResult)
    func removeListener(result: FlutterResult)
    func finishDidUpdateSelection(enabled: Bool, result: FlutterResult)
    func finishDidUpdateSession(enabled: Bool, result: FlutterResult)
    func countOfBarcodes(selectionIdentifier: String, result: FlutterResult)
    func resetSession(call: FlutterMethodCall, result: FlutterResult)
    func dispose()
}

@objc
public class ScanditFlutterDataCaptureBarcodeSelection: NSObject, ScanditFlutterDataCaptureBarcodeSelectionProtocol {
    private enum FunctionNames {
        static let resetMode = "resetMode"
        static let unfreezeCamera = "unfreezeCamera"
        static let addListener = "addBarcodeSelectionListener"
        static let removeListener = "removeBarcodeSelectionListener"
        static let finishDidUpdateSelection = "finishDidUpdateSelection"
        static let finishDidUpdateSession = "finishDidUpdateSession"
        static let getBarcodeSelectionSessionCount = "getBarcodeSelectionSessionCount"
        static let resetBarcodeSelectionSession = "resetBarcodeSelectionSession"
        static let getLastFrameData = "getLastFrameData"
        static let getDefaults = "getBarcodeSelectionDefaults"
    }
    
    let methodChannel: FlutterMethodChannel
    let eventChannel: FlutterEventChannel
    
    var barcodeSelection: BarcodeSelection?
    var eventSink: FlutterEventSink?
    var hasListeners = false
    
    var sessionHolder = ScanditFlutterDataCaptureBarcodeSelectionSessionHolder()
    
    internal let didUpdateSelectionLock: CallbackLock<Bool> = {
        CallbackLock<Bool>(name: ScanditFlutterDataCaptureBarcodeSelectionEvent.selectionDidUpdate.rawValue)
    }()
    internal let didUpdateSessionLock: CallbackLock<Bool> = {
        CallbackLock<Bool>(name: ScanditFlutterDataCaptureBarcodeSelectionEvent.sessionDidUpate.rawValue)
    }()
    
    @objc
    public init(binaryMessenger: FlutterBinaryMessenger) {
        let prefix = "com.scandit.datacapture.barcode.selection"
        methodChannel = FlutterMethodChannel(name: "\(prefix)/method_channel",
                                             binaryMessenger: binaryMessenger)
        eventChannel = FlutterEventChannel(name: "\(prefix)/event_channel",
                                           binaryMessenger: binaryMessenger)
        super.init()
        methodChannel.setMethodCallHandler(selectionListenerMethodCallHandler(call:result:))
        eventChannel.setStreamHandler(self)
        registerDeserializer()
    }
    
    func selectionListenerMethodCallHandler(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case FunctionNames.resetMode:
            resetBarcodeSelection(result: result)
        case FunctionNames.unfreezeCamera:
            unfreezeCamera(result: result)
        case FunctionNames.addListener:
            addListener(result: result)
        case FunctionNames.removeListener:
            removeListener(result: result)
        case FunctionNames.finishDidUpdateSelection:
            let enabled = call.arguments as? Bool ?? false
            finishDidUpdateSelection(enabled: enabled, result: result)
        case FunctionNames.finishDidUpdateSession:
            let enabled = call.arguments as? Bool ?? false
            finishDidUpdateSession(enabled: enabled, result: result)
        case FunctionNames.getBarcodeSelectionSessionCount:
            let selectionIdentifier = call.arguments as! String
            countOfBarcodes(selectionIdentifier: selectionIdentifier, result: result)
        case FunctionNames.resetBarcodeSelectionSession:
            resetSession(call: call, result: result)
        case FunctionNames.getLastFrameData:
            ScanditFlutterDataCaptureCore.getLastFrameData(reply: result)
        case FunctionNames.getDefaults:
            do {
                let defaultsJSONString = String(data: try JSONSerialization.data(withJSONObject: defaults, options: []),
                                                encoding: .utf8)
                result(defaultsJSONString)
            } catch {
                result(FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func resetBarcodeSelection(result: FlutterResult) {
        barcodeSelection?.reset()
        result(nil)
    }
    
    public func unfreezeCamera(result: FlutterResult) {
        barcodeSelection?.unfreezeCamera()
        result(nil)
    }
    
    public func addListener(result: FlutterResult) {
        hasListeners = true
        barcodeSelection?.addListener(self)
        result(nil)
    }
    
    public func removeListener(result: FlutterResult) {
        hasListeners = false
        barcodeSelection?.removeListener(self)
        result(nil)
    }
    
    public func finishDidUpdateSelection(enabled: Bool, result: FlutterResult) {
        didUpdateSelectionLock.unlock(value: enabled)
        result(nil)
    }
    
    public func finishDidUpdateSession(enabled: Bool, result: FlutterResult) {
        didUpdateSessionLock.unlock(value: enabled)
        result(nil)
    }
    
    public func countOfBarcodes(selectionIdentifier: String, result: FlutterResult) {
        let count = sessionHolder.barcodeCountOfFrame(with: selectionIdentifier)
        result(count)
    }
    
    public func resetSession(call: FlutterMethodCall, result: FlutterResult) {
        sessionHolder.reset(frameSequenceId: call.arguments as? Int)
        result(nil)
    }
    
    @objc
    public func dispose() {
        methodChannel.setMethodCallHandler(nil)
        eventChannel.setStreamHandler(nil)
        unlockLocks()
    }
    
    func unlockLocks() {
        didUpdateSelectionLock.reset()
        didUpdateSessionLock.reset()
    }
}
