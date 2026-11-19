/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_state.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_status_icon_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_status_icon_style.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style_custom_view_container.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style_request.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style_response.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

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
    return {'type': 'dot', 'brushesForState': _brushesForState.map((e) => e.toMap()).toList()};
  }

  factory BarcodePickViewHighlightStyleDot.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json);
    return BarcodePickViewHighlightStyleDot._(brushesForState);
  }
}

class BarcodePickViewHighlightStyleDotWithIcons implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;
  final List<IconForState> _iconsForState = [];

  BarcodePickViewHighlightStyleDotWithIcons._(this._brushesForState);

  BarcodePickViewHighlightStyleDotWithIcons()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.dotWithIcons.brushesForState);

  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  // Need to be async in order to load the asset
  Future<void> setIconForState(String assetKey, BarcodePickState state) {
    return rootBundle.load(assetKey).then((value) {
      var base64EncodedImage = base64Encode(value.buffer.asUint8List());
      // Remove existing item first
      _iconsForState.removeWhere((element) => element.pickState == state);
      _iconsForState.add(IconForState(state, base64EncodedImage));
    });
  }

  BarcodePickViewHighlightStyleAsyncProvider? asyncStyleProvider;

  @override
  Map<String, dynamic> toMap() {
    var json = {
      'type': 'dotWithIcons',
      'brushesForState': _brushesForState.map((e) => e.toMap()).toList(),
      'hasAsyncProvider': asyncStyleProvider != null,
    };
    if (_iconsForState.isNotEmpty) {
      json['iconsForState'] = _iconsForState.map((e) => e.toMap()).toList();
    }
    return json;
  }

  factory BarcodePickViewHighlightStyleDotWithIcons.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json['brushesForState']);
    return BarcodePickViewHighlightStyleDotWithIcons._(brushesForState);
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
    return {'type': 'rectangular', 'brushesForState': _brushesForState.map((e) => e.toMap()).toList()};
  }

  factory BarcodePickViewHighlightStyleRectangular.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json['brushesForState']);
    return BarcodePickViewHighlightStyleRectangular._(brushesForState);
  }
}

class BarcodePickViewHighlightStyleRectangularWithIcons implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;
  final List<IconForState> _iconsForState = [];

  BarcodePickViewHighlightStyleRectangularWithIcons._(this._brushesForState);

  BarcodePickViewHighlightStyleRectangularWithIcons()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.brushesForState);

  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  // Need to be async in order to load the asset
  Future<void> setIconForState(String assetKey, BarcodePickState state) {
    return rootBundle.load(assetKey).then((value) {
      var base64EncodedImage = base64Encode(value.buffer.asUint8List());
      // Remove existing item first
      _iconsForState.removeWhere((element) => element.pickState == state);
      _iconsForState.add(IconForState(state, base64EncodedImage));
    });
  }

  BarcodePickViewHighlightStyleAsyncProvider? asyncStyleProvider;

  bool styleResponseCacheEnabled =
      BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.styleResponseCacheEnabled;

  int minimumHighlightWidth = BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.minimumHighlightWidth;
  int minimumHighlightHeight =
      BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.minimumHighlightHeight;

  BarcodePickStatusIconSettings statusIconSettings =
      BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.statusIconSettings;

  @override
  Map<String, dynamic> toMap() {
    var json = {
      'type': 'rectangularWithIcons',
      'brushesForState': _brushesForState.map((e) => e.toMap()).toList(),
      'hasAsyncProvider': asyncStyleProvider != null,
      'styleResponseCacheEnabled': styleResponseCacheEnabled,
      'minimumHighlightWidth': minimumHighlightWidth,
      'minimumHighlightHeight': minimumHighlightHeight,
      'statusIconSettings': statusIconSettings.toMap(),
    };
    if (_iconsForState.isNotEmpty) {
      json['iconsForState'] = _iconsForState.map((e) => e.toMap()).toList();
    }
    return json;
  }

  factory BarcodePickViewHighlightStyleRectangularWithIcons.fromJSON(Map<String, dynamic> json) {
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(json);
    return BarcodePickViewHighlightStyleRectangularWithIcons._(brushesForState);
  }
}

class BarcodePickViewHighlightStyleCustomViewResponse extends Serializable {
  final Uint8List? _viewEncodedAsBase64;
  final BarcodePickStatusIconStyle? _statusIconStyle;

  BarcodePickViewHighlightStyleCustomViewResponse._(this._viewEncodedAsBase64, this._statusIconStyle);

  static Future<BarcodePickViewHighlightStyleCustomViewResponse> create(
    BarcodePickViewHighlightStyleCustomViewWidget? widget,
    BarcodePickStatusIconStyle? statusIconStyle,
  ) async {
    if (widget == null) {
      return BarcodePickViewHighlightStyleCustomViewResponse._(null, statusIconStyle);
    }
    return BarcodePickViewHighlightStyleCustomViewResponse._(await widget.toImage, statusIconStyle);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'view': _viewEncodedAsBase64, 'statusIconStyle': _statusIconStyle?.toMap()};
  }
}

abstract class BarcodePickViewHighlightStyleCustomViewProvider {
  Future<BarcodePickViewHighlightStyleCustomViewResponse?> customViewForRequest(
    BarcodePickViewHighlightStyleRequest request,
  );
}

abstract class BarcodePickViewHighlightStyleAsyncProvider {
  Future<BarcodePickViewHighlightStyleResponse?> styleForRequest(BarcodePickViewHighlightStyleRequest request);
}

class BarcodePickViewHighlightStyleCustomView extends BarcodePickViewHighlightStyle {
  bool fitViewsToBarcode = BarcodePickDefaults.viewHighlightStyleDefaults.customView.fitViewsToBarcode;
  BarcodePickViewHighlightStyleCustomViewProvider? asyncCustomViewProvider;
  BarcodePickStatusIconSettings statusIconSettings =
      BarcodePickDefaults.viewHighlightStyleDefaults.customView.statusIconSettings;
  int minimumHighlightWidth = BarcodePickDefaults.viewHighlightStyleDefaults.customView.minimumHighlightWidth;
  int minimumHighlightHeight = BarcodePickDefaults.viewHighlightStyleDefaults.customView.minimumHighlightHeight;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'customView',
      'fitViewsToBarcode': fitViewsToBarcode,
      'hasAsyncProvider': asyncCustomViewProvider != null,
      'statusIconSettings': statusIconSettings.toMap(),
      'minimumHighlightWidth': minimumHighlightWidth,
      'minimumHighlightHeight': minimumHighlightHeight,
    };
  }
}
