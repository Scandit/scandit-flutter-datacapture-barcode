/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

@objc
public class FlutterBarcodeCountViewFactory: NSObject, FlutterPlatformViewFactory {
    let barcodeCountPlugin: ScanditFlutterDataCaptureBarcodeCount

    @objc
    public init(barcodeCountPlugin: ScanditFlutterDataCaptureBarcodeCount) {
        self.barcodeCountPlugin = barcodeCountPlugin
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        guard let args = args as? [String: Any],
              let creationJson = args["BarcodeCountView"] as? String else {
            fatalError("Unable to create the BarcodeCountView without the json.")
        }
        let view = FlutterBarcodeCountView(frame: frame)
        barcodeCountPlugin.add(view, from: creationJson)

        return view
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}
