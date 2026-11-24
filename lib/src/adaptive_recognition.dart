/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode.dart';

/// Reason an adaptive recognition dispatch failed, delivered to an [AdaptiveRecognitionServiceListener].
///
/// Added in version 8.7.0
enum AdaptiveRecognitionErrorReason {
  /// The dispatch failed for an unspecified reason, such as a network, backend, or pre-dispatch failure.
  ///
  /// Added in version 8.7.0
  unknown('unknown'),
  /// The dispatch did not complete within the allotted time.
  ///
  /// Added in version 8.7.0
  timeout('timeout');

  const AdaptiveRecognitionErrorReason(this._name);

  @override
  String toString() => _name;

  final String _name;

  static AdaptiveRecognitionErrorReason fromJSON(String jsonValue) {
    return AdaptiveRecognitionErrorReason.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Frame correlation metadata delivered with every [AdaptiveRecognitionServiceListener] callback.
///
/// Correlation metadata delivered with every [AdaptiveRecognitionServiceListener] callback. It ties an asynchronously-delivered adaptive recognition outcome back to the frame that produced the dispatch. The SDK produces these; applications do not construct them.
///
/// Added in version 8.7.0
class AdaptiveRecognitionFrameMetadata {
  final int _frameId;
  final List<Barcode> _barcodes;

  AdaptiveRecognitionFrameMetadata._(this._frameId, this._barcodes);

  /// Monotonic per-mode ordinal identifying the frame within a capture session.
  ///
  /// Added in version 8.7.0
  int get frameId => _frameId;

  /// The barcodes recognized in the dispatched frame.
  ///
  /// Added in version 8.7.0
  List<Barcode> get barcodes => _barcodes;

  // Shared by BarcodeCapture and BarcodeCount so the JSON-string-per-barcode wire shape is
  // decoded in one place instead of in each mode's controller.
  factory AdaptiveRecognitionFrameMetadata.fromJSON(Map<String, dynamic> json) {
    final barcodeJsonStrings = (json['barcodes'] as List).cast<String>();
    return AdaptiveRecognitionFrameMetadata._(
      json['frameId'] as int,
      barcodeJsonStrings.map((barcode) => Barcode.fromJSON(jsonDecode(barcode) as Map<String, dynamic>)).toList(),
    );
  }
}

/// Interface for the outcome of adaptive recognition dispatches performed by a capture mode’s adaptive recognition service. Register it on the mode with [BarcodeCapture.addAdaptiveRecognitionServiceListener]. Each callback receives the [AdaptiveRecognitionFrameMetadata] of the originating frame, so an asynchronously-delivered outcome can be correlated back to the frame that produced it.
///
/// All callbacks are optional, so an implementor overrides only the ones it needs.
///
/// For any given frame, its response or error callback always follows that frame’s dispatch-started callback.
///
/// Added in version 8.7.0
abstract class AdaptiveRecognitionServiceListener {
  /// Invoked when a frame is dispatched to the adaptive recognition service. The frame data is provided for the mode’s own use, for example to display the dispatched frame.
  ///
  /// Added in version 8.7.0
  void onAdaptiveRecognitionServiceDispatchStarted(
    Future<FrameData?> Function() getFrameData,
    AdaptiveRecognitionFrameMetadata frameMetadata,
  ) {}

  /// Invoked when an adaptive recognition dispatch completes successfully. The response is a JSON string whose shape is defined by the task’s response schema and is opaque to the SDK.
  ///
  /// Added in version 8.7.0
  void onAdaptiveRecognitionServiceResponse(
    String response,
    AdaptiveRecognitionFrameMetadata frameMetadata,
  ) {}

  /// Invoked when an adaptive recognition dispatch fails.
  ///
  /// Added in version 8.7.0
  void onAdaptiveRecognitionServiceError(
    AdaptiveRecognitionErrorReason reason,
    AdaptiveRecognitionFrameMetadata frameMetadata,
  ) {}
}
