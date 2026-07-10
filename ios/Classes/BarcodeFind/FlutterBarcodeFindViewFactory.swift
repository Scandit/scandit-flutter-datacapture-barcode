/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class FlutterBarcodeFindViewFactory: NSObject, FlutterPlatformViewFactory {
    var views: [FlutterBarcodeFindView] = []

    let barcodeFindModule: BarcodeFindModule

    init(barcodeFindModule: BarcodeFindModule) {
        self.barcodeFindModule = barcodeFindModule
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create BarcodeFindView without the JSON.")
            fatalError("Unable to create BarcodeFindView without the JSON.")
        }
        guard let creationJson = creationArgs["BarcodeFindView"] as? String else {
            Log.error("Unable to create the BarcodeFindView without the json.")
            fatalError("Unable to create the BarcodeFindView without the json.")
        }
        let view = FlutterBarcodeFindView(frame: frame)
        view.factory = self
        barcodeFindModule.addViewToContainer(container: view,
                                             jsonString: creationJson,
                                             result: FlutterLogInsteadOfResult())
        views.append(view)
        return view
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func addBarcodeCountViewToLastContainer() {
        guard let view = views.last,
              let barcodeFindView = barcodeFindModule.barcodeFindView else { return }
        if barcodeFindView.superview != nil {
            barcodeFindView.removeFromSuperview()
        }
        view.addSubview(barcodeFindView)
    }
}

