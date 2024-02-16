/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_icon_style.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_pick_defaults.dart';
import 'barcode_pick_state.dart';

abstract class BarcodePickViewHighlightStyle extends Serializable {}

class BarcodePickViewHighlightStyleDot implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;

  BarcodePickViewHighlightStyleDot._(this._brushesForState);

  BarcodePickViewHighlightStyleDot() : this._(BarcodePickDefaults.viewHighlightStyleDefaults.dot.brushesForState);

  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'dot',
      'brushesForState': _brushesForState.map((e) => e.toMap()).toList(),
    };
  }

  factory BarcodePickViewHighlightStyleDot.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json);
    return BarcodePickViewHighlightStyleDot._(brushesForState);
  }
}

class BarcodePickViewHighlightStyleDotWithIcons implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;

  BarcodePickIconStyle iconStyle;

  BarcodePickViewHighlightStyleDotWithIcons._(this._brushesForState, this.iconStyle);

  BarcodePickViewHighlightStyleDotWithIcons()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.dotWithIcons.brushesForState,
            BarcodePickDefaults.viewHighlightStyleDefaults.dotWithIcons.iconStyle);

  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'dotWithIcons',
      'brushesForState': _brushesForState.map((e) => e.toMap()).toList(),
      'iconStyle': iconStyle.toString(),
    };
  }

  factory BarcodePickViewHighlightStyleDotWithIcons.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json['brushesForState']);
    var iconStyle = BarcodePickIconStyleDeserializer.fromJSON(json['iconStyle']);
    return BarcodePickViewHighlightStyleDotWithIcons._(brushesForState, iconStyle);
  }
}

class BarcodePickViewHighlightStyleRectangular extends BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;

  BarcodePickViewHighlightStyleRectangular._(this._brushesForState);

  BarcodePickViewHighlightStyleRectangular()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.rectangular.brushesForState);

  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'rectangular',
      'brushesForState': _brushesForState.map((e) => e.toMap()).toList(),
    };
  }

  factory BarcodePickViewHighlightStyleRectangular.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json['brushesForState']);
    return BarcodePickViewHighlightStyleRectangular._(brushesForState);
  }
}

class BarcodePickViewHighlightStyleRectangularWithIcons implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;
  BarcodePickIconStyle iconStyle;

  BarcodePickViewHighlightStyleRectangularWithIcons._(this._brushesForState, this.iconStyle);

  BarcodePickViewHighlightStyleRectangularWithIcons()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.brushesForState,
            BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.iconStyle);

  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'rectangularWithIcons',
      'brushesForState': _brushesForState.map((e) => e.toMap()).toList(),
      'iconStyle': iconStyle.toString(),
    };
  }

  factory BarcodePickViewHighlightStyleRectangularWithIcons.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json);
    var iconStyle = BarcodePickIconStyleDeserializer.fromJSON(json['iconStyle']);
    return BarcodePickViewHighlightStyleRectangularWithIcons._(brushesForState, iconStyle);
  }
}