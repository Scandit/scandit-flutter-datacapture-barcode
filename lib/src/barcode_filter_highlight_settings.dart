/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

enum BarcodeFilterHighlightType {
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

abstract class BarcodeFilterHighlightSettings implements Serializable {
  final BarcodeFilterHighlightType _highlightType;
  final Brush? _brush;

  BarcodeFilterHighlightSettings._(this._highlightType, this._brush);

  BarcodeFilterHighlightType get highlightType => _highlightType;

  Brush? get brush => _brush;

  @override
  Map<String, dynamic> toMap() {
    return {'highlightType': _highlightType, 'brush': _brush != null ? _brush.toMap() : null};
  }
}

class BarcodeFilterHighlightSettingsBrush extends BarcodeFilterHighlightSettings {
  BarcodeFilterHighlightSettingsBrush._(Brush brush) : super._(BarcodeFilterHighlightType.brush, brush);

  factory BarcodeFilterHighlightSettingsBrush.create(Brush brush) {
    return BarcodeFilterHighlightSettingsBrush._(brush);
  }
}
