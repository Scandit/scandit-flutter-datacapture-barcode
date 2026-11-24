/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import XCTest
import scandit_flutter_datacapture_barcode

class ScanditFlutterDataCaptureBarcodeExampleTests: XCTestCase {
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

    // getDefaults() (the full blob) no longer exists (SDC-32178); getDynamicDefaults() is the
    // surviving endpoint.
    func testDefaultsAreAvailable() {
        let messenger = ScanditFlutterDataCaptureBarcodeExampleTests.messenger
        let methodCall = FlutterMethodCall(
            methodName: "getDynamicDefaults",
            arguments: nil
        )
        let barcodeModule = ScanditFlutterDataCaptureBarcodeModule(with: messenger!)
        barcodeModule.methodCallHandler(
            methodCall: methodCall,
            result: { result in
                XCTAssertNotNil(result)
                XCTAssertTrue(result as! NSObject != FlutterMethodNotImplemented)
            }
        )
    }

    func testMethodNotImplementedForNonExistingMethod() {
        let messenger = ScanditFlutterDataCaptureBarcodeExampleTests.messenger
        let methodCall = FlutterMethodCall(
            methodName: "not-existing-method",
            arguments: nil
        )
        let barcodeModule = ScanditFlutterDataCaptureBarcodeModule(with: messenger!)
        barcodeModule.methodCallHandler(
            methodCall: methodCall,
            result: { result in
                XCTAssertNotNil(result)
                XCTAssertTrue(result as! NSObject == FlutterMethodNotImplemented)
            }
        )
    }
}
