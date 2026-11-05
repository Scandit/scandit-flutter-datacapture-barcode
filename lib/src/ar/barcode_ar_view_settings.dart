/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_ar_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodeArViewSettings;

/// Added in version 7.1.0
class BarcodeArViewSettings implements Serializable {
  /// Constructs a new Barcode AR view settings to use when creating an instance of BarcodeArView.
  ///
  /// Added in version 7.1.0
  BarcodeArViewSettings();

  /// Indicates whether the feedback should have sound enabled.
  ///
  /// Default is *true*.
  ///
  /// Added in version 7.1.0
  bool soundEnabled = BarcodeArDefaults.view.defaultSoundEnabled;

  /// Indicates whether the feedback should have haptics enabled.
  ///
  /// Default is *true*.
  ///
  /// Added in version 7.1.0
  bool hapticEnabled = BarcodeArDefaults.view.defaultHapticsEnabled;

  /// Sets the default camera position.
  ///
  /// Default is [CameraPosition.worldFacing].
  ///
  /// Added in version 7.1.0
  CameraPosition defaultCameraPosition = BarcodeArDefaults.view.defaultCameraPosition;

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodeArViewSettings(
      soundEnabled: soundEnabled,
      hapticEnabled: hapticEnabled,
      defaultCameraPosition: defaultCameraPosition.toString(),
    );
  }
}
