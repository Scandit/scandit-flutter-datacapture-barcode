/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_ar_defaults.dart';

class BarcodeArViewSettings implements Serializable {
  BarcodeArViewSettings();

  bool soundEnabled = BarcodeArDefaults.view.defaultSoundEnabled;

  bool hapticEnabled = BarcodeArDefaults.view.defaultHapticsEnabled;

  CameraPosition defaultCameraPosition = BarcodeArDefaults.view.defaultCameraPosition;

  @override
  Map<String, dynamic> toMap() {
    return {
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
      'defaultCameraPosition': defaultCameraPosition.toString()
    };
  }
}
