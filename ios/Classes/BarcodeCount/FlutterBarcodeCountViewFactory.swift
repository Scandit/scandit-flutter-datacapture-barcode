/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore

class FlutterBarcodeCountViewFactory: NSObject, FlutterPlatformViewFactory {
    var views: [FlutterBarcodeCountView] = []

    let barcodeCountModule: BarcodeCountModule

    init(barcodeCountModule: BarcodeCountModule) {
        self.barcodeCountModule = barcodeCountModule
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create BarcodeCountView without the JSON.")
            fatalError("Unable to create BarcodeCountView without the JSON.")
        }
        guard let creationJson = creationArgs["BarcodeCountView"] as? String else {
            Log.error("Unable to create the BarcodeCountView without the json.")
            fatalError("Unable to create the BarcodeCountView without the json.")
        }
        let view = FlutterBarcodeCountView(frame: frame)
        view.factory = self
        barcodeCountModule.addViewFromJson(parent: view, viewJson: creationJson)
        views.append(view)
        return view
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func addBarcodeCountViewToLastContainer() {
        guard let view = views.last, let barcodeCountView = barcodeCountModule.barcodeCountView else { return }
        if barcodeCountView.superview != nil {
            barcodeCountView.removeFromSuperview()
        }
        view.addSubview(barcodeCountView)
    }
}
