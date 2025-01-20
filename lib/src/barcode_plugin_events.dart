/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';

class BarcodePluginEvents {
  static Stream barcodeCountEventStream = _getBarcodeCountStream();

  static Stream barcodeCaptureEventStream = _getBarcodeCaptureStream();

  static Stream barcodeSelectionEventStream = _getBarcodeSelectionStream();

  static Stream barcodeBatchEventStream = _getBarcodeBatchStream();

  static Stream sparkScanEventStream = _getSparkScanStream();

  static Stream barcodeFindEventStream = _getBarcodeFindStream();

  static Stream barcodePickEventStream = _getBarcodePickStream();

  static Stream _getBarcodeCountStream() {
    return const EventChannel('com.scandit.datacapture.barcode.count/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeCaptureStream() {
    return const EventChannel('com.scandit.datacapture.barcode.capture/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeSelectionStream() {
    return const EventChannel('com.scandit.datacapture.barcode.selection/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeBatchStream() {
    return const EventChannel('com.scandit.datacapture.barcode.batch/event_channel').receiveBroadcastStream();
  }

  static Stream _getSparkScanStream() {
    return const EventChannel('com.scandit.datacapture.barcode.spark/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodeFindStream() {
    return const EventChannel('com.scandit.datacapture.barcode.find/event_channel').receiveBroadcastStream();
  }

  static Stream _getBarcodePickStream() {
    return const EventChannel('com.scandit.datacapture.barcode.pick/event_channel').receiveBroadcastStream();
  }
}
