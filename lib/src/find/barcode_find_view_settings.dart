/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_find_defaults.dart';

/// Added in version 6.22.0
class BarcodeFindViewSettings implements Serializable {
  final Color _inListItemColor;
  final Color _notInListItemColor;
  final Color _progressBarStartColor;
  final Color _progressBarFinishColor;
  final bool _soundEnabled;
  final bool _hapticEnabled;
  final bool _hardwareTriggerEnabled;
  final int? _hardwareTriggerKeyCode;

  /// Constructs a new BarcodeFind view settings to use when creating an instance of the [BarcodeFindView].
  ///
  /// Added in version 6.22.0
  BarcodeFindViewSettings(this._inListItemColor, this._notInListItemColor, this._soundEnabled, this._hapticEnabled)
      : _progressBarStartColor = BarcodeFindDefaults.barcodeFindViewSettingsDefaults.progressBarStartColor,
        _progressBarFinishColor = BarcodeFindDefaults.barcodeFindViewSettingsDefaults.progressBarFinishColor,
        _hardwareTriggerEnabled = false,
        _hardwareTriggerKeyCode = null;

  BarcodeFindViewSettings.withProgressBarColor(
    this._inListItemColor,
    this._notInListItemColor,
    this._progressBarStartColor,
    this._progressBarFinishColor,
    this._soundEnabled,
    this._hapticEnabled,
  )   : _hardwareTriggerEnabled = false,
        _hardwareTriggerKeyCode = null;

  BarcodeFindViewSettings.withHardwareTriggers(
    this._inListItemColor,
    this._notInListItemColor,
    this._soundEnabled,
    this._hapticEnabled,
    this._hardwareTriggerEnabled,
    this._hardwareTriggerKeyCode,
  )   : _progressBarStartColor = BarcodeFindDefaults.barcodeFindViewSettingsDefaults.progressBarStartColor,
        _progressBarFinishColor = BarcodeFindDefaults.barcodeFindViewSettingsDefaults.progressBarFinishColor;

  BarcodeFindViewSettings.withProgressBarColorAndHardwareTriggers(
    this._inListItemColor,
    this._notInListItemColor,
    this._progressBarStartColor,
    this._progressBarFinishColor,
    this._soundEnabled,
    this._hapticEnabled,
    this._hardwareTriggerEnabled,
    this._hardwareTriggerKeyCode,
  );

  /// The color for the overlay of an item that is in the list of items to find.
  ///
  /// Default is #2EC1CE.
  ///
  /// Added in version 6.22.0
  Color get inListItemColor => _inListItemColor;

  /// The color for the overlay of an item that is not in the list of items to find.
  ///
  /// Default is #FFFFFF.
  ///
  /// Added in version 6.22.0
  Color get notInListItemColor => _notInListItemColor;

  /// The color used at the start of the progress bar. The progress bar will diplay a gradient from [BarcodeFindViewSettings.progressBarStartColor] to [BarcodeFindViewSettings.progressBarFinishColor].
  ///
  /// Default is #2EC1CE.
  ///
  /// Added in version 8.5.0
  Color get progressBarStartColor => _progressBarStartColor;

  /// The color used at the end of the progress bar. The progress bar will diplay a gradient from [BarcodeFindViewSettings.progressBarStartColor] to [BarcodeFindViewSettings.progressBarFinishColor].
  ///
  /// Default is #97e0e6.
  ///
  /// Added in version 8.5.0
  Color get progressBarFinishColor => _progressBarFinishColor;

  /// Indicates whether audio feedback should be enabled.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get soundEnabled => _soundEnabled;

  /// Indicates whether haptic feedback should be enabled.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get hapticEnabled => _hapticEnabled;

  /// Added in version 8.5.0
  bool get hardwareTriggerEnabled => _hardwareTriggerEnabled;

  /// Added in version 8.5.0
  int? get hardwareTriggerKeyCode => _hardwareTriggerKeyCode;

  @override
  Map<String, dynamic> toMap() {
    return {
      'inListItemColor': inListItemColor.jsonValue,
      'notInListItemColor': notInListItemColor.jsonValue,
      'progressBarStartColor': progressBarStartColor.jsonValue,
      'progressBarFinishColor': progressBarFinishColor.jsonValue,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'hardwareTriggerEnabled': hardwareTriggerEnabled,
      'hardwareTriggerKeyCode': hardwareTriggerKeyCode,
    };
  }
}
