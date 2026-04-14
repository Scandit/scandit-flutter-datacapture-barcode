/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksBarcode
import ScanditFrameworksCore
import scandit_flutter_datacapture_core

class FlutterSparkScanView: UIView, FlutterPlatformView {
    weak var factory: FlutterSparkScanViewFactory?
    let creationJson: String
    let sparkScanModule: SparkScanModule
    var isViewCreated: Bool
    var viewId: Int = 0

    init(frame: CGRect, creationJson: String, sparkScanModule: SparkScanModule) {
        self.creationJson = creationJson
        self.sparkScanModule = sparkScanModule
        self.isViewCreated = false
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
        if isViewCreated {
            return
        }

        guard superview != nil, window != nil else {
            print("FlutterSparkScanView: Failed to setup view - superview or window is nil")
            return
        }

        guard let window = self.window,
            let rootViewController = window.rootViewController,
            let flutterView = rootViewController.view,
            let parent = flutterView.superview
        else {
            print(
                "FlutterSparkScanView: Failed to setup view - window, root view controller, view, or parent is nil"
            )
            return
        }

        sparkScanModule.addViewToContainer(
            parent,
            jsonString: creationJson,
            result: FlutterLogInsteadOfResult(),
            completion: { [weak self] viewId in
                guard let self = self else {
                    return
                }

                guard viewId > 0 else {
                    print(
                        "FlutterSparkScanView: The native SparkScanView creation failed. Received invalid viewId: \(viewId)"
                    )
                    return
                }

                self.viewId = viewId
                self.sparkScanModule.bringSparkScanViewToFront(viewId: self.viewId, result: NoopFrameworksResult())
                self.sparkScanModule.setupViewConstraints(viewId: self.viewId, referenceView: flutterView)

                self.isViewCreated = true
            }
        )
    }

    override func removeFromSuperview() {
        if viewId > 0 {
            sparkScanModule.disposeSparkScanView(viewId: self.viewId, result: NoopFrameworksResult())
        }
        super.removeFromSuperview()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard viewId > 0 else {
            return super.hitTest(point, with: event)
        }
        return sparkScanModule.hitTest(viewId: self.viewId, point: point, with: event)
    }
}
