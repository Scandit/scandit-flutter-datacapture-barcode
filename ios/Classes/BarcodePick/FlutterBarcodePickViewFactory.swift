/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class FlutterBarcodePickViewFactory: NSObject, FlutterPlatformViewFactory {
    var views: [FlutterBarcodePickView] = []

    let barcodePickModule: BarcodePickModule

    init(barcodePickModule: BarcodePickModule) {
        self.barcodePickModule = barcodePickModule
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create BarcodePickView without the JSON.")
            fatalError("Unable to create BarcodePickView without the JSON.")
        }
        guard let creationJson = creationArgs["BarcodePickView"] as? String else {
            Log.error("Unable to create the BarcodePickView without the json.")
            fatalError("Unable to create the BarcodePickView without the json.")
        }
        let view = FlutterBarcodePickView(frame: frame)
        view.factory = self
        barcodePickModule.addViewToContainer(container: view,
                                             jsonString: creationJson,
                                             result: FlutterLogInsteadOfResult())
        views.append(view)
        return view
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func addBarcodePickViewToLastContainer() {
        guard let view = views.last,
              let barcodePickView = barcodePickModule.barcodePickView else { return }
        if barcodePickView.superview != nil {
            barcodePickView.removeFromSuperview()
        }
        view.addSubview(barcodePickView)
    }
}


