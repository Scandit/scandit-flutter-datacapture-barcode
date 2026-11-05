/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// Wraps a pair of [ScanditIcon] instances used as a highlight icon by [BarcodeCountView]. The recognized and not-in-list highlights use [BarcodeCountIcon] only when the view [BarcodeCountView.style] is [BarcodeCountViewStyle.icon]. Accepted and rejected highlights always use [BarcodeCountIcon], regardless of the view style. As a consequence, in [BarcodeCountViewStyle.dot] [BarcodeCountView.acceptedBrush] and [BarcodeCountView.rejectedBrush] no longer drive the per-barcode highlight (they still tint the barcode quad outline when manual clustering is enabled); to hide an accepted or rejected highlight, return *null* from the corresponding listener callback instead of setting the brush to *null*.
///
/// The icon to render is selected at runtime based on the overlay’s color scheme. When the chosen variant is *null*, no highlight is drawn for that color scheme.
///
/// Added in version 8.6.0
class BarcodeCountIcon implements Serializable {
  /// The icon used when the overlay is in the default color scheme. If *null*, no highlight is drawn in the default color scheme.
  ///
  /// Added in version 8.6.0
  final ScanditIcon? defaultIcon;
  /// The icon used when the overlay is in the accessible color scheme. If *null*, no highlight is drawn in the accessible color scheme.
  ///
  /// Added in version 8.6.0
  final ScanditIcon? accessibleIcon;

  /// Constructs a new [BarcodeCountIcon] with separate variants for the default and accessible color schemes. Either argument may be *null*.
  ///
  /// Added in version 8.6.0
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
