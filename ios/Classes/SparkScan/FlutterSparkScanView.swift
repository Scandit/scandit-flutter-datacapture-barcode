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
        let sparkScanView = sparkScanModule.sparkScanView!
        flutterView.bringSubviewToFront(sparkScanView)
        let sparkScanViewConstraints = flutterView.constraints.filter {
            $0.firstItem === sparkScanView
        }
        flutterView.removeConstraints(sparkScanViewConstraints)
        flutterView.addConstraints([
            sparkScanView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sparkScanView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            sparkScanView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            sparkScanView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        guard let index = factory?.views.firstIndex(of: self) else { return }
        factory?.views.remove(at: index)
        sparkScanModule.sparkScanView?.removeFromSuperview()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        sparkScanModule.sparkScanView?.hitTest(point, with: event)
    }
}
