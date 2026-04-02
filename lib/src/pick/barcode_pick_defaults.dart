import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_filter_highlight_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/internal/barcode_pick_consts.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_status_icon_settings.dart';

import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style.dart';
import 'package:scandit_flutter_datacapture_barcode/src/symbology.dart';
import 'package:scandit_flutter_datacapture_barcode/src/symbology_settings.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_pick_state.dart';

class BarcodePickDefaults {
  static MethodChannel channel = const MethodChannel(BarcodePickFunctionNames.methodsChannelName);

  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static late Map<String, SymbologySettings> _symbologySettingsDefaults;

  static Map<String, SymbologySettings> get symbologySettingsDefaults => _symbologySettingsDefaults;

  static late BarcodePickSettingsDefaults _barcodePickSettingsDefaults;

  static BarcodePickSettingsDefaults get barcodePickSettings => _barcodePickSettingsDefaults;

  static late ViewHighlightStyleDefaults _viewHighlightStyleDefaults;

  static ViewHighlightStyleDefaults get viewHighlightStyleDefaults => _viewHighlightStyleDefaults;

  static late ViewSettingsDefaults _viewSettingsDefaults;

  static ViewSettingsDefaults get viewSettingsDefaults => _viewSettingsDefaults;

  static late BarcodePickStatusIconSettingsDefaults _barcodePickStatusIconSettingsDefaults;

  static BarcodePickStatusIconSettingsDefaults get barcodePickStatusIconSettingsDefaults =>
      _barcodePickStatusIconSettingsDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodePickFunctionNames.getDefaults);

    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _symbologySettingsDefaults = (json['SymbologySettings'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, SymbologySettings.fromJSON(SymbologySerializer.fromJSON(key), jsonDecode(value))),
    );
    _barcodePickStatusIconSettingsDefaults =
        BarcodePickStatusIconSettingsDefaults.fromJSON(json['BarcodePickStatusIconSettings']);
    _barcodePickSettingsDefaults = BarcodePickSettingsDefaults.fromJSON(json['BarcodePickSettings']);
    _viewHighlightStyleDefaults = ViewHighlightStyleDefaults.fromJSON(json['BarcodePickViewHighlightStyle']);
    _viewSettingsDefaults = ViewSettingsDefaults.fromJSON(json['ViewSettings']);

    _isInitialized = true;
  }
}

@immutable
class ViewSettingsDefaults {
  final String initialGuidelineText;
  final String moveCloserGuidelineText;
  final String loadingDialogTextForPicking;
  final String loadingDialogTextForUnpicking;
  final bool showLoadingDialog;
  final String onFirstItemPickCompletedHintText;
  final String onFirstItemToPickFoundHintText;
  final String onFirstItemUnpickCompletedHintText;
  final String onFirstUnmarkedItemPickCompletedHintText;
  final bool showGuidelines;
  final bool showHints;
  final BarcodePickViewHighlightStyle highlightStyle;
  final bool showFinishButton;
  final bool showPauseButton;
  final bool showZoomButton;
  final Anchor zoomButtonPosition;
  final bool showTorchButton;
  final Anchor torchButtonPosition;
  final String tapShutterToPauseGuidelineText;
  final DoubleWithUnit? uiButtonsOffset;
  final bool hardwareTriggerEnabled;
  final int? hardwareTriggerKeyCode;
  final BarcodeFilterHighlightSettings? filterHighlightSettings;

  const ViewSettingsDefaults(
    this.initialGuidelineText,
    this.moveCloserGuidelineText,
    this.loadingDialogTextForPicking,
    this.loadingDialogTextForUnpicking,
    this.showLoadingDialog,
    this.onFirstItemPickCompletedHintText,
    this.onFirstItemToPickFoundHintText,
    this.onFirstItemUnpickCompletedHintText,
    this.onFirstUnmarkedItemPickCompletedHintText,
    this.showGuidelines,
    this.showHints,
    this.highlightStyle,
    this.showFinishButton,
    this.showPauseButton,
    this.showZoomButton,
    this.zoomButtonPosition,
    this.showTorchButton,
    this.torchButtonPosition,
    this.tapShutterToPauseGuidelineText,
    this.uiButtonsOffset,
    this.hardwareTriggerEnabled,
    this.hardwareTriggerKeyCode,
    this.filterHighlightSettings,
  );

  factory ViewSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final filterHighlightSettingsJson = json['filterHighlightSettings'];
    BarcodeFilterHighlightSettings? filterHighlightSettings;
    if (filterHighlightSettingsJson != null) {
      final type =
          BarcodeFilterHighlightTypeSerializer.fromJSON(filterHighlightSettingsJson['highlightType'] as String);
      if (type == BarcodeFilterHighlightType.brush) {
        filterHighlightSettings = BarcodeFilterHighlightSettingsBrush.create(
          BrushDefaults.fromJSON(filterHighlightSettingsJson['brush']).toBrush(),
        );
      }
    }

    return ViewSettingsDefaults(
        json['initialGuidelineText'] as String,
        json['moveCloserGuidelineText'] as String,
        json['loadingDialogTextForPicking'] as String,
        json['loadingDialogTextForUnpicking'] as String,
        json['showLoadingDialog'] as bool,
        json['onFirstItemPickCompletedHintText'] as String,
        json['onFirstItemToPickFoundHintText'] as String,
        json['onFirstItemUnpickCompletedHintText'] as String,
        json['onFirstUnmarkedItemPickCompletedHintText'] as String,
        json['showGuidelines'] as bool,
        json['showHints'] as bool,
        ViewHighlightStyleDefaultsHelper.getHighlightStyle(json['HighlightStyle'] as String),
        json['showFinishButton'] as bool,
        json['showPauseButton'] as bool,
        json['showZoomButton'] as bool,
        AnchorDeserializer.fromJSON(json['zoomButtonPosition'] as String),
        json['showTorchButton'] as bool,
        AnchorDeserializer.fromJSON(json['torchButtonPosition'] as String),
        json['tapShutterToPauseGuidelineText'] as String,
        json['uiButtonsOffset'] != null ? DoubleWithUnit.fromJSON(jsonDecode(json['uiButtonsOffset'] as String)) : null,
        json['hardwareTriggerEnabled'] as bool,
        json['hardwareTriggerKeyCode'] as int?,
        filterHighlightSettings);
  }
}

@immutable
class BarcodePickSettingsDefaults {
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool cachingEnabled;

  const BarcodePickSettingsDefaults(this.hapticsEnabled, this.soundEnabled, this.cachingEnabled);

  factory BarcodePickSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodePickSettingsDefaults(
      json['hapticsEnabled'] as bool,
      json['soundEnabled'] as bool,
      json['cachingEnabled'] as bool,
    );
  }
}

@immutable
class ViewHighlightStyleDefaults {
  final RectangularViewHighlightStyleDefaults rectangular;
  final RectangularWithIconsViewHighlightStyleDefaults rectangularWithIcons;
  final DotRectangularViewHighlightStyleDefaults dot;
  final DotWithIconsViewHighlightStyleDefaults dotWithIcons;
  final CustomViewHighlightStyleDefaults customView;

  const ViewHighlightStyleDefaults(
      this.rectangular, this.rectangularWithIcons, this.dot, this.dotWithIcons, this.customView);

  factory ViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    return ViewHighlightStyleDefaults(
      RectangularViewHighlightStyleDefaults.fromJSON(json),
      RectangularWithIconsViewHighlightStyleDefaults.fromJSON(json),
      DotRectangularViewHighlightStyleDefaults.fromJSON(json),
      DotWithIconsViewHighlightStyleDefaults.fromJSON(json),
      CustomViewHighlightStyleDefaults.fromJSON(json),
    );
  }
}

@immutable
class RectangularViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  const RectangularViewHighlightStyleDefaults(this.brushesForState);

  factory RectangularViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var rectangularJson = jsonDecode(json['Rectangular'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(rectangularJson);
    return RectangularViewHighlightStyleDefaults(brushesForState);
  }
}

@immutable
class RectangularWithIconsViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  final List<BrushForState> selectedBrushesForState;
  final bool styleResponseCacheEnabled;
  final BarcodePickStatusIconSettings statusIconSettings;
  final int minimumHighlightWidth;
  final int minimumHighlightHeight;

  const RectangularWithIconsViewHighlightStyleDefaults(
    this.brushesForState,
    this.selectedBrushesForState,
    this.styleResponseCacheEnabled,
    this.statusIconSettings,
    this.minimumHighlightWidth,
    this.minimumHighlightHeight,
  );

  factory RectangularWithIconsViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var rectangularWithIconsJson = jsonDecode(json['RectangularWithIcons'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(rectangularWithIconsJson);
    final styleResponseCacheEnabled = rectangularWithIconsJson['styleResponseCacheEnabled'] as bool;
    final selectedBrushesForState =
        ViewHighlightStyleDefaultsHelper.geSelectedtBrushesForState(rectangularWithIconsJson);

    BarcodePickStatusIconSettings statusIconSettings;
    if (rectangularWithIconsJson['statusIconSettings'] != null) {
      statusIconSettings = BarcodePickStatusIconSettings.fromJSON(rectangularWithIconsJson['statusIconSettings']);
    } else {
      statusIconSettings = BarcodePickStatusIconSettings();
    }

    return RectangularWithIconsViewHighlightStyleDefaults(
      brushesForState,
      selectedBrushesForState,
      styleResponseCacheEnabled,
      statusIconSettings,
      rectangularWithIconsJson['minimumHighlightWidth'] as int,
      rectangularWithIconsJson['minimumHighlightHeight'] as int,
    );
  }
}

@immutable
class DotRectangularViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  const DotRectangularViewHighlightStyleDefaults(this.brushesForState);

  factory DotRectangularViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var dotJson = jsonDecode(json['Dot'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(dotJson);
    return DotRectangularViewHighlightStyleDefaults(brushesForState);
  }
}

@immutable
class DotWithIconsViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  final List<BrushForState> selectedBrushesForState;
  final bool styleResponseCacheEnabled;

  const DotWithIconsViewHighlightStyleDefaults(
      this.brushesForState, this.selectedBrushesForState, this.styleResponseCacheEnabled);

  factory DotWithIconsViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var dotWithIconsJson = jsonDecode(json['DotWithIcons'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(dotWithIconsJson);
    final styleResponseCacheEnabled = dotWithIconsJson['styleResponseCacheEnabled'] as bool;
    final selectedBrushesForState = ViewHighlightStyleDefaultsHelper.geSelectedtBrushesForState(dotWithIconsJson);

    return DotWithIconsViewHighlightStyleDefaults(
      brushesForState,
      selectedBrushesForState,
      styleResponseCacheEnabled,
    );
  }
}

@immutable
class CustomViewHighlightStyleDefaults {
  final bool fitViewsToBarcode;
  final BarcodePickStatusIconSettings statusIconSettings;
  final int minimumHighlightWidth;
  final int minimumHighlightHeight;

  const CustomViewHighlightStyleDefaults(
    this.fitViewsToBarcode,
    this.statusIconSettings,
    this.minimumHighlightWidth,
    this.minimumHighlightHeight,
  );

  factory CustomViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var customViewJson = jsonDecode(json['CustomView'] as String);
    return CustomViewHighlightStyleDefaults(
      customViewJson['fitViewsToBarcodeEnabled'] as bool,
      BarcodePickStatusIconSettings.fromJSON(customViewJson['statusIconSettings']),
      customViewJson['minimumHighlightWidth'] as int,
      customViewJson['minimumHighlightHeight'] as int,
    );
  }
}

class BrushForState extends Serializable {
  final BarcodePickState pickState;
  Brush brush;

  BrushForState(this.pickState, this.brush);

  factory BrushForState.fromJSON(Map<String, dynamic> json) {
    var pickState = BarcodePickStateDeserializer.fromJSON(json['barcodePickState'] as String);

    var fillJson = json['brush']['fill'] as Map<String, dynamic>;
    var strokeJson = json['brush']['stroke'] as Map<String, dynamic>;

    var fillColor = ColorDeserializer.fromRgbaHex(fillJson['color'] as String);
    var strokeColor = ColorDeserializer.fromRgbaHex(strokeJson['color'] as String);
    var strokeWidth = (strokeJson['width'] as num).toDouble();

    return BrushForState(pickState, Brush(fillColor, strokeColor, strokeWidth));
  }

  @override
  Map<String, dynamic> toMap() {
    return {'brush': brush.toMap(), 'barcodePickState': pickState.toString()};
  }
}

class IconForState extends Serializable {
  final BarcodePickState pickState;
  final String base64EncodedIcon;

  IconForState(this.pickState, this.base64EncodedIcon);

  @override
  Map<String, dynamic> toMap() {
    return {'barcodePickState': pickState.toString(), 'icon': base64EncodedIcon};
  }
}

class ViewHighlightStyleDefaultsHelper {
  static List<BrushForState> getBrushesForState(Map<String, dynamic> json) {
    return (json['brushesForState'] as List<dynamic>).map((e) => BrushForState.fromJSON(e)).toList();
  }

  static List<BrushForState> geSelectedtBrushesForState(Map<String, dynamic> json) {
    return (json['selectedBrushesForState'] as List<dynamic>).map((e) => BrushForState.fromJSON(e)).toList();
  }

  static BarcodePickViewHighlightStyle getHighlightStyle(String highlightStypeJson) {
    var json = jsonDecode(highlightStypeJson);
    var type = json['type'] as String;
    if (type == 'rectangularWithIcons') {
      return BarcodePickViewHighlightStyleRectangularWithIcons.fromJSON(json);
    } else if (type == 'dot') {
      return BarcodePickViewHighlightStyleDot.fromJSON(json);
    } else if (type == 'dotWithIcons') {
      return BarcodePickViewHighlightStyleDotWithIcons.fromJSON(json);
    }

    return BarcodePickViewHighlightStyleRectangular.fromJSON(json);
  }
}

class BarcodePickStatusIconSettingsDefaults {
  final double ratioToHighlightSize;
  final int minSize;
  final int maxSize;

  const BarcodePickStatusIconSettingsDefaults(this.ratioToHighlightSize, this.minSize, this.maxSize);

  factory BarcodePickStatusIconSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodePickStatusIconSettingsDefaults(
      json['ratioToHighlightSize'] as double,
      json['minSize'] as int,
      json['maxSize'] as int,
    );
  }
}
