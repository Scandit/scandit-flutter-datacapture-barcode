/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import XCTest

@testable import scandit_flutter_datacapture_barcode

class ScanditFlutterDataCaptureBarcodeBatchTests: XCTestCase {
    static var messenger: FlutterBinaryMessenger!

    override class func setUp() {
        super.setUp()

        guard let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate,
            let flutterViewController = appDelegate.window.rootViewController as? FlutterViewController
        else {
            fatalError("The Flutter engine and the plugins are not set up.")
        }
        messenger = flutterViewController.binaryMessenger
    }

    func testAddRemoveBarcodeBatchSimpleOverlayListenerIsCorrectlyInvoked() {
        let messenger = ScanditFlutterDataCaptureBarcodeBatchTests.messenger
        let addListenerMethod = FlutterMethodCall(
            methodName: "subscribeBarcodeBatchBasicOverlayListener",
            arguments: nil
        )
        let basicStreamHandler = BarcodeBatchBasicOverlayStreamHandler()
        let advancedStreamHandler = BarcodeBatchAdvancedOverlayStreamHandler()
        let barcodeBatch = ScanditFlutterDataCaptureBarcodeBatch(
            with: messenger!,
            simpleOverlayStreamHandler: basicStreamHandler,
            advancedOverlayStreamHandler: advancedStreamHandler
        )
        XCTAssertFalse(basicStreamHandler.hasListeners)
        barcodeBatch.basicOverlayMethodCallHandler(methodCall: addListenerMethod) { result in
            XCTAssertNil(result)
            basicStreamHandler.hasListeners = true
        }

        let removeListenersMethodCall = FlutterMethodCall(
            methodName: "unsubscribeBarcodeBatchBasicOverlayListener",
            arguments: nil
        )
        barcodeBatch.basicOverlayMethodCallHandler(methodCall: removeListenersMethodCall) { result in
            XCTAssertNil(result)
            basicStreamHandler.hasListeners = false
        }
    }

    func testAddAndRemoveBarcodeBatchAdvancedOverlayListenerIsCorrectlyInvoked() {
        let messenger = ScanditFlutterDataCaptureBarcodeBatchTests.messenger
        let addListenerMethod = FlutterMethodCall(
            methodName: "addBarcodeBatchAdvancedOverlayDelegate",
            arguments: nil
        )
        let basicStreamHandler = BarcodeBatchBasicOverlayStreamHandler()
        let advancedStreamHandler = BarcodeBatchAdvancedOverlayStreamHandler()
        let barcodeBatch = ScanditFlutterDataCaptureBarcodeBatch(
            with: messenger!,
            simpleOverlayStreamHandler: basicStreamHandler,
            advancedOverlayStreamHandler: advancedStreamHandler
        )
        XCTAssertFalse(advancedStreamHandler.hasListeners)
        barcodeBatch.advancedOverlayMethodCallHandler(methodCall: addListenerMethod) { result in
            XCTAssertNil(result)
            advancedStreamHandler.hasListeners = true
        }

        let removeListenersMethodCall = FlutterMethodCall(
            methodName: "removeBarcodeBatchAdvancedOverlayDelegate",
            arguments: nil
        )
        barcodeBatch.advancedOverlayMethodCallHandler(methodCall: removeListenersMethodCall) { result in
            XCTAssertNil(result)
            advancedStreamHandler.hasListeners = false
        }
    }

    func testAddAndRemoveListenerIsCorrrectlyInvoked() {
        let messenger = ScanditFlutterDataCaptureBarcodeBatchTests.messenger
        let methodCall = FlutterMethodCall(
            methodName: "addBarcodeBatchListener",
            arguments: nil
        )
        let basicStreamHandler = BarcodeBatchBasicOverlayStreamHandler()
        let advancedStreamHandler = BarcodeBatchAdvancedOverlayStreamHandler()
        let barcodeBatch = ScanditFlutterDataCaptureBarcodeBatch(
            with: messenger!,
            simpleOverlayStreamHandler: basicStreamHandler,
            advancedOverlayStreamHandler: advancedStreamHandler
        )
        XCTAssertFalse(barcodeBatch.hasListeners)
        barcodeBatch.barcodeBatchMethodCallHandler(methodCall: methodCall) { result in
            XCTAssertNil(result)
            barcodeBatch.hasListeners = true
        }

        let removeListenersMethodCall = FlutterMethodCall(
            methodName: "removeBarcodeBatchListener",
            arguments: nil
        )
        barcodeBatch.barcodeBatchMethodCallHandler(methodCall: removeListenersMethodCall) { result in
            XCTAssertNil(result)
            barcodeBatch.hasListeners = false
        }
    }

    func testDefaultsAreAvailable() {
        let messenger = ScanditFlutterDataCaptureBarcodeBatchTests.messenger
        let methodCall = FlutterMethodCall(
            methodName: "getBarcodeBatchDefaults",
            arguments: nil
        )
        let basicStreamHandler = BarcodeBatchBasicOverlayStreamHandler()
        let advancedStreamHandler = BarcodeBatchAdvancedOverlayStreamHandler()
        let barcodeBatch = ScanditFlutterDataCaptureBarcodeBatch(
            with: messenger!,
            simpleOverlayStreamHandler: basicStreamHandler,
            advancedOverlayStreamHandler: advancedStreamHandler
        )
        let barcodeBatchModule = ScanditFlutterDataCaptureBarcodeBatchModule(
            with: messenger!,
            barcodeBatch: barcodeBatch
        )
        barcodeBatchModule.methodCallHandler(
            methodCall: methodCall,
            result: { result in
                XCTAssertNotNil(result)
                XCTAssertTrue(result as! NSObject != FlutterMethodNotImplemented)
            }
        )
    }

    func testMethodNotImplementedForNonExistingMethod() {
        let messenger = ScanditFlutterDataCaptureBarcodeBatchTests.messenger
        let methodCall = FlutterMethodCall(
            methodName: "not-existing-method",
            arguments: nil
        )
        let basicStreamHandler = BarcodeBatchBasicOverlayStreamHandler()
        let advancedStreamHandler = BarcodeBatchAdvancedOverlayStreamHandler()
        let barcodeBatch = ScanditFlutterDataCaptureBarcodeBatch(
            with: messenger!,
            simpleOverlayStreamHandler: basicStreamHandler,
            advancedOverlayStreamHandler: advancedStreamHandler
        )
        let barcodeBatchModule = ScanditFlutterDataCaptureBarcodeBatchModule(
            with: messenger!,
            barcodeBatch: barcodeBatch
        )
        barcodeBatchModule.methodCallHandler(
            methodCall: methodCall,
            result: { result in
                XCTAssertNotNil(result)
                XCTAssertTrue(result as! NSObject == FlutterMethodNotImplemented)
            }
        )
    }
}
