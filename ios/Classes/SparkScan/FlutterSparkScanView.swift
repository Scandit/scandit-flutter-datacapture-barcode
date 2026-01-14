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

        guard let _ = superview, let _ = window else {
            print("FlutterSparkScanView: Failed to setup view - superview or window is nil")
            return
        }

        let flutterAppDelegate = (UIApplication.shared.delegate as! FlutterAppDelegate)

        // Handle both older Flutter versions (non-optional window) and newer versions (optional window)
        let appWindow: UIWindow?
        if #available(iOS 13.0, *) {
            // iOS 13+ with scene support - window is optional
            appWindow = flutterAppDelegate.window
        } else {
            // Pre-iOS 13 - window was non-optional, but we treat it as optional for consistency
            appWindow = flutterAppDelegate.window
        }

        guard let window = appWindow,
              let rootViewController = window.rootViewController,
              let flutterView = rootViewController.view,
              let parent = flutterView.superview else {
            print("FlutterSparkScanView: Failed to setup view - Flutter app delegate window, root view controller, view, or parent is nil")
            return
        }

        sparkScanModule.addViewToContainer(parent,
                                           jsonString: creationJson,
                                           result: FlutterLogInsteadOfResult(),
                                           completion: { [weak self] viewId in
            guard let self = self else {
                return
            }

            guard viewId > 0 else {
                print("FlutterSparkScanView: The native SparkScanView creation failed. Received invalid viewId: \(viewId)")
                return
            }

            self.viewId = viewId
            self.sparkScanModule.bringSparkScanViewToFront(viewId: self.viewId)
            self.sparkScanModule.setupViewConstraints(viewId: self.viewId, referenceView: flutterView)

            self.isViewCreated = true
        })
    }

    override func removeFromSuperview() {
        if viewId > 0 {
            sparkScanModule.disposeView(viewId: self.viewId)
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
