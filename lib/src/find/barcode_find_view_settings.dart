/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_find_defaults.dart';

class BarcodeFindViewSettings implements Serializable {
  final Color _inListItemColor;
  final Color _notInListItemColor;
  final Color _progressBarStartColor;
  final Color _progressBarFinishColor;
  final bool _soundEnabled;
  final bool _hapticEnabled;
  final bool _hardwareTriggerEnabled;
  final int? _hardwareTriggerKeyCode;

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

  Color get inListItemColor => _inListItemColor;

  Color get notInListItemColor => _notInListItemColor;

  Color get progressBarStartColor => _progressBarStartColor;

  Color get progressBarFinishColor => _progressBarFinishColor;

  bool get soundEnabled => _soundEnabled;

  bool get hapticEnabled => _hapticEnabled;

  bool get hardwareTriggerEnabled => _hardwareTriggerEnabled;

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
