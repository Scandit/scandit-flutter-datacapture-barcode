/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// The type of highlight applied to the filtered barcodes.
///
/// Added in version 6.17.0
enum BarcodeFilterHighlightType {
  /// A quadrilateral filled with a solid color will be drawn over filtered barcodes.
  ///
  /// Added in version 6.17.0
  brush('brush');

  const BarcodeFilterHighlightType(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeFilterHighlightTypeSerializer on BarcodeFilterHighlightType {
  static BarcodeFilterHighlightType fromJSON(String jsonValue) {
    return BarcodeFilterHighlightType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Added in version 6.17.0
abstract class BarcodeFilterHighlightSettings implements Serializable {
  final BarcodeFilterHighlightType _highlightType;
  final Brush? _brush;

  BarcodeFilterHighlightSettings._(this._highlightType, this._brush);

  /// Returns the type of highlight that will be applied to filtered barcodes.
  ///
  /// Added in version 6.17.0
  BarcodeFilterHighlightType get highlightType => _highlightType;

  /// Returns the [Brush] applied to filtered barcodes when [BarcodeFilterHighlightSettings.highlightType] is set to [BarcodeFilterHighlightType.brush].
  ///
  /// Added in version 6.17.0
  Brush? get brush => _brush;

  @override
  Map<String, dynamic> toMap() {
    return {'highlightType': _highlightType.toString(), 'brush': _brush?.toMap()};
  }
}

/// Added in version 6.17.0
class BarcodeFilterHighlightSettingsBrush extends BarcodeFilterHighlightSettings {
  /// Creates a new BarcodeFilterHighlightSettings instance with [BarcodeFilterHighlightType.brush] type, with the specified brush.
  ///
  /// Added in version 6.17.0
  BarcodeFilterHighlightSettingsBrush() : super._(BarcodeFilterHighlightType.brush, Brush.transparent);

  BarcodeFilterHighlightSettingsBrush._(Brush brush) : super._(BarcodeFilterHighlightType.brush, brush);

  factory BarcodeFilterHighlightSettingsBrush.create(Brush brush) {
    return BarcodeFilterHighlightSettingsBrush._(brush);
  }

  /// Returns the [Brush] applied to filtered barcodes when [BarcodeFilterHighlightSettingsBrush.highlightType] is set to [BarcodeFilterHighlightType.brush].
  ///
  /// Added in version 8.5.0
  @override
  Brush? get brush => super.brush; // ignore: unnecessary_overrides

  /// Returns the type of highlight that will be applied to filtered barcodes.
  ///
  /// Added in version 8.5.0
  @override
  BarcodeFilterHighlightType get highlightType => super.highlightType; // ignore: unnecessary_overrides
}
