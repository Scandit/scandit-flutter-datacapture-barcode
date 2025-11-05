/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_check_common.dart';
import 'barcode_check_defaults.dart';

enum BarcodeCheckCircleHighlightPreset {
  dot('dot'),
  icon('icon');

  const BarcodeCheckCircleHighlightPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCheckCircleHighlightPresetSerializer on BarcodeCheckCircleHighlightPreset {
  static BarcodeCheckCircleHighlightPreset fromJSON(String jsonValue) {
    return BarcodeCheckCircleHighlightPreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

abstract class BarcodeCheckHighlight extends Serializable with PrivateBarcodeCheckHighlight {
  final String _type;

  BarcodeCheckHighlight._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type, 'barcodeId': barcodeId};
  }
}

mixin PrivateBarcodeCheckHighlight {
  String barcodeId = ''; // Will be set externally
  BarcodeCheckViewController? controller; // Will be set externally
}

class BarcodeCheckCircleHighlight extends BarcodeCheckHighlight {
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
  final BarcodeCheckCircleHighlightPreset _preset;

  BarcodeCheckCircleHighlight._(this._barcode, this._preset, this._brush, this._icon, this._size)
      : super._('barcodeCheckCircleHighlight');

  BarcodeCheckCircleHighlight(Barcode barcode, BarcodeCheckCircleHighlightPreset preset)
      : this._(
            barcode,
            preset,
            BarcodeCheckDefaults.view.circleHighlightPresets.get(preset).defaultBrush,
            BarcodeCheckDefaults.view.defaultHighlightIcon,
            BarcodeCheckDefaults.view.circleHighlightPresets.get(preset).defaultSize);

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

class BarcodeCheckRectangleHighlight extends BarcodeCheckHighlight {
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

  BarcodeCheckRectangleHighlight._(this._barcode, this._brush, this._icon) : super._('barcodeCheckRectangleHighlight');

  BarcodeCheckRectangleHighlight(Barcode barcode)
      : this._(barcode, BarcodeCheckDefaults.view.defaultRectangleHighlightBrush,
            BarcodeCheckDefaults.view.defaultHighlightIcon);

  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['brush'] = jsonEncode(brush.toMap());
    json['icon'] = icon != null ? jsonEncode(icon!.toMap()) : null;
    return json;
  }
}
