/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';

class BarcodePluginEvents {
  static late Stream barcodeCountEventStream = _getBarcodeCountStream();

  static late Stream barcodeCaptureEventStream = _getBarcodeCaptureStream();

  static late Stream barcodeSelectionEventStream = _getBarcodeSelectionStream();

  static late Stream barcodeTrackingEventStream = _getBarcodeTrackingStream();

  static late Stream sparkScanEventStream = _getSparkScanStream();

  static late Stream barcodeFindEventStream = _getBarcodeFindStream();

  static Stream _getBarcodeCountStream() {
    return EventChannel('com.scandit.datacapture.barcode.count/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeCaptureStream() {
    return EventChannel('com.scandit.datacapture.barcode.capture/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeSelectionStream() {
    return EventChannel('com.scandit.datacapture.barcode.selection/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeTrackingStream() {
    return EventChannel('com.scandit.datacapture.barcode.tracking/event_channel').receiveBroadcastStream();
  }

  static Stream _getSparkScanStream() {
    return EventChannel('com.scandit.datacapture.barcode.spark/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeFindStream() {
    return EventChannel('com.scandit.datacapture.barcode.find/event_channel').receiveBroadcastStream();
  }
}
