/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeCountIcon implements Serializable {
  final ScanditIcon? defaultIcon;
  final ScanditIcon? accessibleIcon;

  BarcodeCountIcon({ScanditIcon? defaultIcon, ScanditIcon? accessibleIcon})
      : this._(defaultIcon: defaultIcon, accessibleIcon: accessibleIcon);

  BarcodeCountIcon._({this.defaultIcon, this.accessibleIcon});

  factory BarcodeCountIcon.fromJSON(Map<String, dynamic> json) {
    ScanditIcon? defaultIcon;
    if (json['defaultIcon'] != null) {
      defaultIcon = ScanditIcon.fromJSON(json['defaultIcon'] as Map<String, dynamic>);
    }
    ScanditIcon? accessibleIcon;
    if (json['accessibleIcon'] != null) {
      accessibleIcon = ScanditIcon.fromJSON(json['accessibleIcon'] as Map<String, dynamic>);
    }
    return BarcodeCountIcon(defaultIcon: defaultIcon, accessibleIcon: accessibleIcon);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'defaultIcon': defaultIcon?.toMap(),
      'accessibleIcon': accessibleIcon?.toMap(),
    };
  }
}
