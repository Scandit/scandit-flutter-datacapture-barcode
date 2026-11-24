/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_ar_common.dart';
import 'barcode_ar_defaults.dart';

/// The circle highlight presets.
///
/// Added in version 7.1.0
enum BarcodeArCircleHighlightPreset {
  /// Dot style. By default a smaller blue circle.
  ///
  /// Added in version 7.1.0
  dot('dot'),
  /// Icon style. By default a larger blue circle.
  ///
  /// Added in version 7.1.0
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

/// Common interface for Barcode AR highlights. Highlights let the user identify the scanned barcode. They are shown on top of the respective barcode and are displayed as soon as the respective barcode is scanned. They are available in different shapes and have configurable styles. Currently, two types of highlights are supported: [BarcodeArCircleHighlight] and [BarcodeArRectangleHighlight].
///
/// Added in version 7.1.0
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

/// A type of highlight that draws circles on top of barcodes. Highlight styles are customizable. Here are some examples:
///
/// |  |  |  |
/// | --- | --- | --- |
/// | *Dot preset.* | *Icon preset.* | *Icon preset with different border color.* |
///
/// Added in version 7.1.0
class BarcodeArCircleHighlight extends BarcodeArHighlight {
  Brush _brush;
  /// The brush used for visualizing a recognized barcode in the UI. By default, the brush has a blue fill color with 45% alpha, blue stroke and a stroke width of 2.
  ///
  /// Added in version 7.1.0
  Brush get brush => _brush;
  /// The brush used for visualizing a recognized barcode in the UI. By default, the brush has a blue fill color with 45% alpha, blue stroke and a stroke width of 2.
  ///
  /// Added in version 7.1.0
  set brush(Brush newValue) {
    _brush = newValue;
    controller?.updateHighlight(this);
  }

  ScanditIcon? _icon;
  /// The icon used for visualizing a recognized barcode in the UI.
  ///
  /// Added in version 7.1.0
  ScanditIcon? get icon => _icon;
  /// The icon used for visualizing a recognized barcode in the UI.
  ///
  /// Added in version 7.1.0
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    controller?.updateHighlight(this);
  }

  double _size;
  /// The size of the circle highlight in device-independent pixels. Minimum value is 18. If specified value is less than the minimum value, it will be coerced to the minimum value.
  ///
  /// Added in version 7.1.0
  double get size => _size;
  /// The size of the circle highlight in device-independent pixels. Minimum value is 18. If specified value is less than the minimum value, it will be coerced to the minimum value.
  ///
  /// Added in version 7.1.0
  set size(double newValue) {
    _size = newValue;
    controller?.updateHighlight(this);
  }

  bool _isPulsing;
  /// Whether the highlight is showing a pulsing animation.
  ///
  /// Added in version 8.5.0
  bool get isPulsing => _isPulsing;
  /// Whether the highlight is showing a pulsing animation.
  ///
  /// Added in version 8.5.0
  set isPulsing(bool newValue) {
    _isPulsing = newValue;
    controller?.updateHighlight(this);
  }

  final Barcode _barcode;
  final BarcodeArCircleHighlightPreset _preset;

  BarcodeArCircleHighlight._(this._barcode, this._preset, this._brush, this._icon, this._size, this._isPulsing)
      : super._('barcodeArCircleHighlight');

  /// Creates a new instance with default values for the specified preset.
  ///
  /// Added in version 7.1.0
  BarcodeArCircleHighlight(Barcode barcode, BarcodeArCircleHighlightPreset preset)
      : this._(
            barcode,
            preset,
            BarcodeArDefaults.view.circleHighlightPresets.get(preset).defaultBrush,
            BarcodeArDefaults.view.defaultHighlightIcon,
            BarcodeArDefaults.view.circleHighlightPresets.get(preset).defaultSize,
            BarcodeArDefaults.view.defaultHighlightIsPulsing);

  /// The barcode instance for the annotation.
  ///
  /// Added in version 7.1.0
  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['preset'] = _preset.toString();
    json['brush'] = brush.toMap();
    json['icon'] = icon?.toMap();
    json['size'] = size;
    json['isPulsing'] = isPulsing;
    return json;
  }
}

/// A type of highlight that draws rectangles on top of barcodes. Highlight styles are customizable. Here are some examples:
///
/// |  |  |
/// | --- | --- |
/// | *Default style.* | *Customized brush and icon.* |
///
/// Added in version 7.1.0
class BarcodeArRectangleHighlight extends BarcodeArHighlight {
  Brush _brush;
  /// The brush used for visualizing a recognized barcode in the UI. By default, the brush has a blue fill color with 45% alpha, blue stroke and a stroke width of 2.
  ///
  /// Added in version 7.1.0
  Brush get brush => _brush;
  /// The brush used for visualizing a recognized barcode in the UI. By default, the brush has a blue fill color with 45% alpha, blue stroke and a stroke width of 2.
  ///
  /// Added in version 7.1.0
  set brush(Brush newValue) {
    _brush = newValue;
    controller?.updateHighlight(this);
  }

  ScanditIcon? _icon;
  /// The icon used for visualizing a recognized barcode in the UI. Is *null* by default.
  ///
  /// Added in version 7.1.0
  ScanditIcon? get icon => _icon;
  /// The icon used for visualizing a recognized barcode in the UI. Is *null* by default.
  ///
  /// Added in version 7.1.0
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    controller?.updateHighlight(this);
  }

  final Barcode _barcode;

  BarcodeArRectangleHighlight._(this._barcode, this._brush, this._icon) : super._('barcodeArRectangleHighlight');

  /// Creates a new instance with default values.
  ///
  /// Added in version 7.1.0
  BarcodeArRectangleHighlight(Barcode barcode)
      : this._(barcode, BarcodeArDefaults.view.defaultRectangleHighlightBrush,
            BarcodeArDefaults.view.defaultHighlightIcon);

  /// The barcode instance for the annotation.
  ///
  /// Added in version 7.1.0
  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['brush'] = brush.toMap();
    json['icon'] = icon?.toMap();
    return json;
  }
}

/// A custom highlight that can be used to attach your own component to a scanned barcode.
///
/// Added in version 8.1.0
class BarcodeArCustomHighlight extends BarcodeArHighlight {
  final Widget _child;
  final Barcode _barcode;

  BarcodeArCustomHighlight._(this._barcode, this._child) : super._('barcodeArCustomHighlight');

  /// Creates a new instance of the custom highlight.
  ///
  /// Added in version 8.1.0
  BarcodeArCustomHighlight({required Barcode barcode, required Widget child}) : this._(barcode, child);

  /// The barcode instance for the annotation.
  ///
  /// Added in version 8.1.0
  Barcode get barcode => _barcode;

  /// The child widget to be used as a custom highlight.
  ///
  /// The child widget can be any Flutter widget, allowing for complete customization of the highlight appearance.
  ///
  /// ```dart
  /// BarcodeArCustomHighlight(
  ///   barcode: barcode,
  ///   child: YourCustomWidget(),
  /// );
  /// ```
  ///
  /// Added in version 8.1.0
  Widget get child => _child;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    return json;
  }
}
