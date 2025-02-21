/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_check_defaults.dart';

class BarcodeCheckViewSettings implements Serializable {
  BarcodeCheckViewSettings();

  bool soundEnabled = BarcodeCheckDefaults.view.defaultSoundEnabled;

  bool hapticEnabled = BarcodeCheckDefaults.view.defaultHapticsEnabled;

  CameraPosition defaultCameraPosition = BarcodeCheckDefaults.view.defaultCameraPosition;

  @override
  Map<String, dynamic> toMap() {
    return {
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'defaultCameraPosition': defaultCameraPosition.toString()
    };
  }
}
