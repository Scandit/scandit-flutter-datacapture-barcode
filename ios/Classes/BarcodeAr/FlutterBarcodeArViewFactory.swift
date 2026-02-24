/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class FlutterBarcodeArViewFactory: NSObject, FlutterPlatformViewFactory {
    var views: [FlutterBarcodeArView] = []

    let barcodeArModule: BarcodeArModule

    init(barcodeArModule: BarcodeArModule) {
        self.barcodeArModule = barcodeArModule
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create BarcodeArView without the JSON.")
            fatalError("Unable to create BarcodeArView without the JSON.")
        }
        guard let creationJson = creationArgs["BarcodeArView"] as? String else {
            Log.error("Unable to create the BarcodeArView without the json.")
            fatalError("Unable to create the BarcodeArView without the json.")
        }
        let view = FlutterBarcodeArView(frame: frame)
        view.factory = self
        barcodeArModule.addViewToContainer(container: view,
                                             jsonString: creationJson,
                                             result: FlutterLogInsteadOfResult())
        views.append(view)
        return view
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func addBarcodeArViewToLastContainer() {
        guard let view = views.last,
              let barcodeArView = barcodeArModule.barcodeArView else { return }
        if barcodeArView.superview != nil {
            barcodeArView.removeFromSuperview()
        }
        view.addSubview(barcodeArView)
    }
}


