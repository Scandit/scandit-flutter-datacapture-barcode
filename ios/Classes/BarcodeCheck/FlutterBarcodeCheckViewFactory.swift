/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class FlutterBarcodeCheckViewFactory: NSObject, FlutterPlatformViewFactory {
    var views: [FlutterBarcodeCheckView] = []

    let barcodeCheckModule: BarcodeCheckModule

    init(barcodeCheckModule: BarcodeCheckModule) {
        self.barcodeCheckModule = barcodeCheckModule
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create BarcodeCheckView without the JSON.")
            fatalError("Unable to create BarcodeCheckView without the JSON.")
        }
        guard let creationJson = creationArgs["BarcodeCheckView"] as? String else {
            Log.error("Unable to create the BarcodeCheckView without the json.")
            fatalError("Unable to create the BarcodeCheckView without the json.")
        }
        let view = FlutterBarcodeCheckView(frame: frame)
        view.factory = self
        barcodeCheckModule.addViewToContainer(container: view,
                                             jsonString: creationJson,
                                             result: FlutterLogInsteadOfResult())
        views.append(view)
        return view
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func addBarcodeCheckViewToLastContainer() {
        guard let view = views.last,
              let barcodeCheckView = barcodeCheckModule.barcodeCheckView else { return }
        if barcodeCheckView.superview != nil {
            barcodeCheckView.removeFromSuperview()
        }
        view.addSubview(barcodeCheckView)
    }
}


