/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeFindViewSettings implements Serializable {
  final Color _inListItemColor;
  final Color _notInListItemColor;
  final bool _soundEnabled;
  final bool _hapticEnabled;

  BarcodeFindViewSettings(this._inListItemColor, this._notInListItemColor, this._soundEnabled, this._hapticEnabled);

  Color get inListItemColor => _inListItemColor;

  Color get notInListItemColor => _notInListItemColor;

  bool get soundEnabled => _soundEnabled;

  bool get hapticEnabled => _hapticEnabled;

  @override
  Map<String, dynamic> toMap() {
    return {
      'inListItemColor': inListItemColor.jsonValue,
      'notInListItemColor': notInListItemColor.jsonValue,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
    };
  }
}
