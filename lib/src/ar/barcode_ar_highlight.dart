/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_ar_common.dart';
import 'barcode_ar_defaults.dart';

enum BarcodeArCircleHighlightPreset {
  dot('dot'),
  icon('icon');

  const BarcodeArCircleHighlightPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeArCircleHighlightPresetSerializer on BarcodeArCircleHighlightPreset {
  static BarcodeArCircleHighlightPreset fromJSON(String jsonValue) {
    return BarcodeArCircleHighlightPreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

abstract class BarcodeArHighlight extends Serializable with PrivateBarcodeArHighlight {
  final String _type;

  BarcodeArHighlight._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type, 'barcodeId': barcodeId};
  }
}

mixin PrivateBarcodeArHighlight {
  String barcodeId = ''; // Will be set externally
  BarcodeArViewController? controller; // Will be set externally
}

class BarcodeArCircleHighlight extends BarcodeArHighlight {
  Brush _brush;
  Brush get brush => _brush;
  set brush(Brush newValue) {
    _brush = newValue;
    controller?.updateHighlight(this);
  }

  ScanditIcon? _icon;
  ScanditIcon? get icon => _icon;
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    controller?.updateHighlight(this);
  }

  double _size;
  double get size => _size;
  set size(double newValue) {
    _size = newValue;
    controller?.updateHighlight(this);
  }

  final Barcode _barcode;
  final BarcodeArCircleHighlightPreset _preset;

  BarcodeArCircleHighlight._(this._barcode, this._preset, this._brush, this._icon, this._size)
      : super._('barcodeArCircleHighlight');

  BarcodeArCircleHighlight(Barcode barcode, BarcodeArCircleHighlightPreset preset)
      : this._(
            barcode,
            preset,
            BarcodeArDefaults.view.circleHighlightPresets.get(preset).defaultBrush,
            BarcodeArDefaults.view.defaultHighlightIcon,
            BarcodeArDefaults.view.circleHighlightPresets.get(preset).defaultSize);

  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['preset'] = _preset.toString();
    json['brush'] = jsonEncode(brush.toMap());
    json['icon'] = icon != null ? jsonEncode(icon!.toMap()) : null;
    json['size'] = size;
    return json;
  }
}

class BarcodeArRectangleHighlight extends BarcodeArHighlight {
  Brush _brush;
  Brush get brush => _brush;
  set brush(Brush newValue) {
    _brush = newValue;
    controller?.updateHighlight(this);
  }

  ScanditIcon? _icon;
  ScanditIcon? get icon => _icon;
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    controller?.updateHighlight(this);
  }

  final Barcode _barcode;

  BarcodeArRectangleHighlight._(this._barcode, this._brush, this._icon) : super._('barcodeArRectangleHighlight');

  BarcodeArRectangleHighlight(Barcode barcode)
      : this._(barcode, BarcodeArDefaults.view.defaultRectangleHighlightBrush,
            BarcodeArDefaults.view.defaultHighlightIcon);

  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['brush'] = jsonEncode(brush.toMap());
    json['icon'] = icon != null ? jsonEncode(icon!.toMap()) : null;
    return json;
  }
}
