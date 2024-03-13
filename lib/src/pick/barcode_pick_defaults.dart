import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_icon_style.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view_highlight_style.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../symbology.dart';
import '../symbology_settings.dart';
import 'barcode_pick_state.dart';

class BarcodePickDefaults {
  static MethodChannel channel = MethodChannel(BarcodePickFunctionNames.methodsChannelName);

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

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod(BarcodePickFunctionNames.getDefaults);

    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _symbologySettingsDefaults = (json['SymbologySettings'] as Map<String, dynamic>).map((key, value) =>
        MapEntry(key, SymbologySettings.fromJSON(SymbologySerializer.fromJSON(key), jsonDecode(value))));
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
  final String loadingDialogText;
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

  ViewSettingsDefaults(
      this.initialGuidelineText,
      this.moveCloserGuidelineText,
      this.loadingDialogText,
      this.showLoadingDialog,
      this.onFirstItemPickCompletedHintText,
      this.onFirstItemToPickFoundHintText,
      this.onFirstItemUnpickCompletedHintText,
      this.onFirstUnmarkedItemPickCompletedHintText,
      this.showGuidelines,
      this.showHints,
      this.highlightStyle,
      this.showFinishButton,
      this.showPauseButton);

  factory ViewSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return ViewSettingsDefaults(
      json['initialGuidelineText'] as String,
      json['moveCloserGuidelineText'] as String,
      json['loadingDialogText'] as String,
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
    );
  }
}

@immutable
class BarcodePickSettingsDefaults {
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool cachingEnabled;

  BarcodePickSettingsDefaults(this.hapticsEnabled, this.soundEnabled, this.cachingEnabled);

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

  ViewHighlightStyleDefaults(
    this.rectangular,
    this.rectangularWithIcons,
    this.dot,
    this.dotWithIcons,
  );

  factory ViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    return ViewHighlightStyleDefaults(
      RectangularViewHighlightStyleDefaults.fromJSON(json),
      RectangularWithIconsViewHighlightStyleDefaults.fromJSON(json),
      DotRectangularViewHighlightStyleDefaults.fromJSON(json),
      DotWithIconsViewHighlightStyleDefaults.fromJSON(json),
    );
  }
}

@immutable
class RectangularViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  RectangularViewHighlightStyleDefaults(this.brushesForState);

  factory RectangularViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var rectangularJson = jsonDecode(json['Rectangular'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(rectangularJson);
    return RectangularViewHighlightStyleDefaults(brushesForState);
  }
}

@immutable
class RectangularWithIconsViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  final BarcodePickIconStyle iconStyle;
  RectangularWithIconsViewHighlightStyleDefaults(this.brushesForState, this.iconStyle);

  factory RectangularWithIconsViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var rectangularWithIconsJson = jsonDecode(json['RectangularWithIcons'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(rectangularWithIconsJson);
    var iconStyle = BarcodePickIconStyleDeserializer.fromJSON(rectangularWithIconsJson['iconStyle']);
    return RectangularWithIconsViewHighlightStyleDefaults(brushesForState, iconStyle);
  }
}

@immutable
class DotRectangularViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  DotRectangularViewHighlightStyleDefaults(this.brushesForState);

  factory DotRectangularViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var dotJson = jsonDecode(json['Dot'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(dotJson);
    return DotRectangularViewHighlightStyleDefaults(brushesForState);
  }
}

@immutable
class DotWithIconsViewHighlightStyleDefaults {
  final List<BrushForState> brushesForState;
  final BarcodePickIconStyle iconStyle;
  DotWithIconsViewHighlightStyleDefaults(this.brushesForState, this.iconStyle);

  factory DotWithIconsViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var dotWithIconsJson = jsonDecode(json['DotWithIcons'] as String);
    var brushesForState = ViewHighlightStyleDefaultsHelper.getBrushesForState(dotWithIconsJson);
    var iconStyle = BarcodePickIconStyleDeserializer.fromJSON(dotWithIconsJson['iconStyle']);
    return DotWithIconsViewHighlightStyleDefaults(brushesForState, iconStyle);
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
    return {
      'brush': brush.toMap(),
      'barcodePickState': pickState.toString(),
    };
  }
}

class ViewHighlightStyleDefaultsHelper {
  static List<BrushForState> getBrushesForState(Map<String, dynamic> json) {
    return (json['brushesForState'] as List<dynamic>).map((e) => BrushForState.fromJSON(e)).toList();
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
