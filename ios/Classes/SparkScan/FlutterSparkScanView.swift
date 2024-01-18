/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import scandit_flutter_datacapture_core

class FlutterSparkScanView: UIView, FlutterPlatformView {
    weak var factory: FlutterSparkScanViewFactory?
    let creationJson: String
    let sparkScanModule: SparkScanModule

    init(frame: CGRect, creationJson: String, sparkScanModule: SparkScanModule) {
        self.creationJson = creationJson
        self.sparkScanModule = sparkScanModule
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func view() -> UIView {
        self
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let _ = superview, let _ = window else { return }
        let flutterAppDelegate = (UIApplication.shared.delegate as! FlutterAppDelegate)
        let flutterView = flutterAppDelegate.window.rootViewController!.view!
        sparkScanModule.addViewToContainer(flutterView,
                                           jsonString: creationJson,
                                           result: FlutterLogInsteadOfResult())
        flutterView.bringSubviewToFront(sparkScanModule.sparkScanView!)
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        guard let index = factory?.views.firstIndex(of: self) else { return }
        factory?.views.remove(at: index)
        sparkScanModule.sparkScanView?.removeFromSuperview()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil;
        }

        return view;
    }
}
