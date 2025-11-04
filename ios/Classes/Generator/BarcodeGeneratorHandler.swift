/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import scandit_flutter_datacapture_core

class BarcodeGeneratorHandler {
    private let barcodeGeneratorModule: BarcodeGeneratorModule

    init(barcodeGeneratorModule: BarcodeGeneratorModule) {
        self.barcodeGeneratorModule = barcodeGeneratorModule
    }

    func methodCallHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case "createGenerator":
            barcodeGeneratorModule.createGenerator(
                generatorJson: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        case "generateToBytes":
            let args = methodCall.arguments as! [String: Any]
            barcodeGeneratorModule.generateToBytes(
                generatorId: args["generatorId"] as! String,
                text: args["text"] as! String,
                imageWidth: args["imageWidth"] as! Int,
                result: FlutterFrameworkResult(reply: result)
            )
        case "generateFromBytesToBytes":
            let args = methodCall.arguments as! [String: Any]
            barcodeGeneratorModule.generateFromBytesToBytes(
                generatorId: args["generatorId"] as! String,
                data: (args["data"] as! FlutterStandardTypedData).data,
                imageWidth: args["imageWidth"] as! Int,
                result: FlutterFrameworkResult(reply: result)
            )
        case "disposeGenerator":
            barcodeGeneratorModule.disposeGenerator(
                generatorId: methodCall.arguments as! String,
                result: FlutterFrameworkResult(reply: result)
            )
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
