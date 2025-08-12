/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class FlutterSparkScanViewFactory: NSObject, FlutterPlatformViewFactory {
    
    let sparkScanModule: SparkScanModule

    init(sparkScanModule: SparkScanModule) {
        self.sparkScanModule = sparkScanModule
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create SparkScanView without the JSON.")
            fatalError("Unable to create SparkScanView without the JSON.")
        }
        guard let creationJson = creationArgs["SparkScanView"] as? String else {
            Log.error("Unable to create the SparkScanView without the json.")
            fatalError("Unable to create the SparkScanView without the json.")
        }
        let view = FlutterSparkScanView(frame: frame, 
                                        creationJson: creationJson,
                                        sparkScanModule: sparkScanModule)
        view.factory = self
        return view
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}
