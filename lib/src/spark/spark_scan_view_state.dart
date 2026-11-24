/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// The view state of [SparkScanView].
///
/// Added in version 7.0.0
enum SparkScanViewState {
  /// The initial view state for a few moments after SparkScanView is created.
  ///
  /// Added in version 7.0.0
  initial('initial'),
  /// SparkScan is displaying only the collapsed capture button.
  ///
  /// Added in version 7.0.0
  idle('idle'),
  /// SparkScan is displaying an expanded capture button, and if the [SparkScanPreviewBehavior] of the current scanning mode is [SparkScanPreviewBehavior.persistent], we are also displaying camera feed through the mini preview but no actual scanning is taking place. This state is reachable after scanning.
  ///
  /// It is also reachable after a [SparkScanViewSettings.inactiveStateTimeout] timeout.
  ///
  /// Added in version 7.0.0
  inactive('inactive'),
  /// We are actively recognising barcodes, mini preview and expanded capture button are visible.
  ///
  /// Added in version 7.0.0
  active('active'),
  /// User returns SparkScanBarcodeFeedback.Error ([Error]) from the [SparkScanView.feedbackDelegate]. Mini preview is visible with a frozen frame and expanded capture button is visible. If capture button is tapped or after a SparkScanBarcodeErrorFeedback.resumeCapturingDelay ([Error.ResumeCapturingDelay]) timeout is reached we move to [SparkScanViewState.active] state.
  ///
  /// Added in version 7.0.0
  error('error');

  const SparkScanViewState(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanViewStateSerializer on SparkScanViewState {
  static SparkScanViewState fromJSON(String jsonValue) {
    return SparkScanViewState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
