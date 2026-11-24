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

/// Common interface for [BarcodePickView] styles.
///
/// Added in version 6.22.0
abstract class BarcodePickViewHighlightStyle extends Serializable {}

/// A style that will draw dots on top of barcodes.
///
/// Added in version 6.22.0
class BarcodePickViewHighlightStyleDot implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;

  BarcodePickViewHighlightStyleDot._(this._brushesForState);

  /// Creates a new instance with default values.
  ///
  /// Added in version 6.22.0
  BarcodePickViewHighlightStyleDot() : this._(BarcodePickDefaults.viewHighlightStyleDefaults.dot.brushesForState);

  /// Gets the brush used for the passed pick state.
  ///
  /// Added in version 6.22.0
  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  /// Use this method to configure the brush used for the specific pick state.
  ///
  /// Added in version 6.22.0
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

/// A style that will draw dots on top of barcodes, the highlights also have icons drawn on top.
///
/// Added in version 6.22.0
class BarcodePickViewHighlightStyleDotWithIcons implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;
  final List<IconForState> _iconsForState = [];

  BarcodePickViewHighlightStyleDotWithIcons._(this._brushesForState);

  /// Creates a new instance with default values.
  ///
  /// Added in version 6.22.0
  BarcodePickViewHighlightStyleDotWithIcons()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.dotWithIcons.brushesForState);

  /// Gets the brush used for the passed pick state.
  ///
  /// Added in version 6.22.0
  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  /// Use this method to configure the brush used for the specific pick state.
  ///
  /// Added in version 6.22.0
  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  // Need to be async in order to load the asset
  /// Use this method to configure the icon used for the specific pick state.
  ///
  /// The asset key of the icon to load. For example: assets/images/picked.png.
  ///
  /// The icon is shown with a size of 18x18 dp.
  ///
  /// Added in version 6.22.0
  Future<void> setIconForState(String assetKey, BarcodePickState state) {
    return rootBundle.load(assetKey).then((value) {
      var base64EncodedImage = base64Encode(value.buffer.asUint8List());
      // Remove existing item first
      _iconsForState.removeWhere((element) => element.pickState == state);
      _iconsForState.add(IconForState(state, base64EncodedImage));
    });
  }

  /// Sets a delegate to override asynchronously the style of the highlights depending on each item’s code and state.
  ///
  /// Added in version 7.3.0
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

/// A style that will draw rectangles on top of barcodes.
///
/// Added in version 6.22.0
class BarcodePickViewHighlightStyleRectangular extends BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;

  BarcodePickViewHighlightStyleRectangular._(this._brushesForState);

  /// Creates a new instance with default values.
  ///
  /// Added in version 6.22.0
  BarcodePickViewHighlightStyleRectangular()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.rectangular.brushesForState);

  /// Gets the brush used for the passed pick state.
  ///
  /// Added in version 6.22.0
  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  /// Use this method to configure the brush used for the specific pick state.
  ///
  /// Added in version 6.22.0
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

/// A style that will draw rectangles on top of barcodes, the highlights can also have icons drawn on top.
///
/// Added in version 6.22.0
class BarcodePickViewHighlightStyleRectangularWithIcons implements BarcodePickViewHighlightStyle {
  final List<BrushForState> _brushesForState;
  final List<IconForState> _iconsForState = [];

  BarcodePickViewHighlightStyleRectangularWithIcons._(this._brushesForState);

  /// Creates a new instance with default values.
  ///
  /// Added in version 6.22.0
  BarcodePickViewHighlightStyleRectangularWithIcons()
      : this._(BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.brushesForState);

  /// Gets the brush used for the passed pick state.
  ///
  /// Added in version 6.22.0
  Brush getBrushForState(BarcodePickState state) {
    return _brushesForState.firstWhere((element) => element.pickState == state).brush;
  }

  /// Use this method to configure the brush used for the specific pick state.
  ///
  /// Added in version 6.22.0
  void setBrushForState(Brush brush, BarcodePickState state) {
    _brushesForState.firstWhere((element) => element.pickState == state).brush = brush;
  }

  // Need to be async in order to load the asset
  /// Use this method to configure the icon used for the specific pick state.
  ///
  /// The asset key of the icon to load. For example: assets/images/picked.png.
  ///
  /// Added in version 6.23.0
  Future<void> setIconForState(String assetKey, BarcodePickState state) {
    return rootBundle.load(assetKey).then((value) {
      var base64EncodedImage = base64Encode(value.buffer.asUint8List());
      // Remove existing item first
      _iconsForState.removeWhere((element) => element.pickState == state);
      _iconsForState.add(IconForState(state, base64EncodedImage));
    });
  }

  /// Sets a delegate to override asynchronously the style of the highlights depending on each item’s code and state.
  ///
  /// Added in version 7.3.0
  BarcodePickViewHighlightStyleAsyncProvider? asyncStyleProvider;

  /// If enabled the [RectangularWithIcons.AsyncStyleProvider] responses will be cached, otherwise the style will be asked every time. Defaults to *true*.
  ///
  /// Added in version 7.3.0
  bool styleResponseCacheEnabled =
      BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.styleResponseCacheEnabled;

  /// Minimum width for the highlights. Default is 40dp.
  ///
  /// Added in version 7.3.0
  int minimumHighlightWidth = BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.minimumHighlightWidth;
  /// Minimum height for the highlights. Default is 40dp.
  ///
  /// Added in version 7.3.0
  int minimumHighlightHeight =
      BarcodePickDefaults.viewHighlightStyleDefaults.rectangularWithIcons.minimumHighlightHeight;

  /// The settings used to customize the status icons.
  ///
  /// Added in version 7.3.0
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

/// Create this object to respond to BarcodePickViewHighlightStyleCustomView ([CustomView]) queries.
///
/// Added in version 7.3.0
class BarcodePickViewHighlightStyleCustomViewResponse extends Serializable {
  final Uint8List? _viewEncodedAsBase64;
  final BarcodePickStatusIconStyle? _statusIconStyle;

  BarcodePickViewHighlightStyleCustomViewResponse._(this._viewEncodedAsBase64, this._statusIconStyle);

  /// Creates a new instance with the provided view. A [BarcodePickStatusIconStyle] instance can also be provided to display a status icon.
  ///
  /// Added in version 7.3.0
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

/// An object that will provide the views to the BarcodePickViewHighlightStyleCustomView ([CustomView]) style.
///
/// Added in version 7.3.0
abstract class BarcodePickViewHighlightStyleCustomViewProvider {
  /// This method will be called every time the view for an item is needed.
  ///
  /// Added in version 7.3.0
  Future<BarcodePickViewHighlightStyleCustomViewResponse?> customViewForRequest(
    BarcodePickViewHighlightStyleRequest request,
  );
}

/// Added in version 7.3.0
abstract class BarcodePickViewHighlightStyleAsyncProvider {
  /// This method will be called every time a style for an item is needed.
  ///
  /// Added in version 7.3.0
  Future<BarcodePickViewHighlightStyleResponse?> styleForRequest(BarcodePickViewHighlightStyleRequest request);
}

/// A style that will allow the user to provide their own views to be displayed on top of barcodes.
///
/// Added in version 7.3.0
class BarcodePickViewHighlightStyleCustomView extends BarcodePickViewHighlightStyle {
  /// If *true* the view size will be adjusted to cover the barcode. Defaults to *false*.
  ///
  /// Added in version 7.3.0
  bool fitViewsToBarcode = BarcodePickDefaults.viewHighlightStyleDefaults.customView.fitViewsToBarcode;
  /// Sets a delegate that will provide the views to be displayed.
  ///
  /// Added in version 7.3.0
  BarcodePickViewHighlightStyleCustomViewProvider? asyncCustomViewProvider;
  /// The settings used to customize the status icons.
  ///
  /// Added in version 7.3.0
  BarcodePickStatusIconSettings statusIconSettings =
      BarcodePickDefaults.viewHighlightStyleDefaults.customView.statusIconSettings;
  /// Minimum width for the highlights. Default is 40dp.
  ///
  /// Added in version 7.3.0
  int minimumHighlightWidth = BarcodePickDefaults.viewHighlightStyleDefaults.customView.minimumHighlightWidth;
  /// Minimum height for the highlights. Default is 40dp.
  ///
  /// Added in version 7.3.0
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
