import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_filter_highlight_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_filter_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_status_icon_settings.dart';

import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_view_highlight_style.dart';
import 'package:scandit_flutter_datacapture_barcode/src/symbology.dart';
import 'package:scandit_flutter_datacapture_barcode/src/symbology_settings.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/logo_style.dart';

import '../generated/barcode_generated_defaults.dart';
import 'barcode_pick_state.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBrushForStateObject, buildIconForStateObject;

BarcodePickSettingsDefaults _buildStaticBarcodePickSettingsDefaults() {
  return BarcodePickSettingsDefaults(
    BarcodePickSettingsGeneratedDefaults.hapticsEnabled,
    BarcodePickSettingsGeneratedDefaults.soundEnabled,
    BarcodePickSettingsGeneratedDefaults.cachingEnabled,
    // The generated filterSettings const is an empty object, i.e. a freshly
    // constructed BarcodeFilterSettings with every exclusion unset.
    BarcodeFilterSettings(),
  );
}

BarcodePickStatusIconSettingsDefaults _buildStaticBarcodePickStatusIconSettingsDefaults() {
  return BarcodePickStatusIconSettingsDefaults(
    BarcodePickStatusIconSettingsGeneratedDefaults.ratioToHighlightSize,
    BarcodePickStatusIconSettingsGeneratedDefaults.minSize,
    BarcodePickStatusIconSettingsGeneratedDefaults.maxSize,
  );
}

class BarcodePickDefaults {
  static late CameraSettingsDefaults _cameraSettingsDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static late Map<String, SymbologySettings> _symbologySettingsDefaults;

  /// Unmodifiable map, mutable values — see
  /// [BarcodeDefaults.symbologySettingsDefaults] (SDC-32039).
  static Map<String, SymbologySettings> get symbologySettingsDefaults =>
      Map<String, SymbologySettings>.unmodifiable(_symbologySettingsDefaults);

  /// A fresh copy of the defaults for [identifier] — see
  /// [BarcodeDefaults.defaultSymbologySettingsFor] (SDC-32039).
  static SymbologySettings defaultSymbologySettingsFor(String identifier) {
    final defaults = _symbologySettingsDefaults[identifier];
    if (defaults == null) {
      throw StateError('Missing symbology defaults for $identifier');
    }
    return SymbologySettings.fromJSON(defaults.symbology, defaults.toMap());
  }

  // Statically sourced from generated/barcode_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately, no
  // method-channel round trip needed. See SDC-32174.
  static final BarcodePickSettingsDefaults _barcodePickSettingsDefaults = _buildStaticBarcodePickSettingsDefaults();

  static BarcodePickSettingsDefaults get barcodePickSettings => _barcodePickSettingsDefaults;

  // BarcodePickViewHighlightStyle is intentionally NOT staticized: the
  // generated consts carry only the per-state brushes, not the
  // selectedBrushesForState lists nor the per-style statusIconSettings that
  // ViewHighlightStyleDefaults.fromJSON requires. Stays fully dynamic.
  static late ViewHighlightStyleDefaults _viewHighlightStyleDefaults;

  static ViewHighlightStyleDefaults get viewHighlightStyleDefaults => _viewHighlightStyleDefaults;

  // ViewSettings is intentionally NOT staticized: its highlightStyle field
  // needs the fully serialized style object (the generated const records only
  // the style's type name) and uiButtonsOffset needs a DoubleWithUnit (the
  // generated const records a bare number, with no unit). Stays fully dynamic.
  static late ViewSettingsDefaults _viewSettingsDefaults;

  static ViewSettingsDefaults get viewSettingsDefaults => _viewSettingsDefaults;

  static final BarcodePickStatusIconSettingsDefaults _barcodePickStatusIconSettingsDefaults =
      _buildStaticBarcodePickStatusIconSettingsDefaults();

  static BarcodePickStatusIconSettingsDefaults get barcodePickStatusIconSettingsDefaults =>
      _barcodePickStatusIconSettingsDefaults;

  static bool _isInitialized = false;

  static void initializeDefaults(Map<String, dynamic> barcodePickDefaults) {
    if (_isInitialized) return;

    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(barcodePickDefaults['RecommendedCameraSettings']);
    _symbologySettingsDefaults = (barcodePickDefaults['SymbologySettings'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, SymbologySettings.fromJSON(SymbologySerializer.fromJSON(key), jsonDecode(value))),
    );
    _viewHighlightStyleDefaults =
        ViewHighlightStyleDefaults.fromJSON(barcodePickDefaults['BarcodePickViewHighlightStyle']);
    _viewSettingsDefaults = ViewSettingsDefaults.fromJSON(barcodePickDefaults['ViewSettings']);

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
  final String highlightStyleJson;
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
  final LogoStyle logoStyle;
  final Anchor logoAnchor;

  /// Fresh per read: these defaults are one static instance, so handing out a shared mutable
  /// style let one caller's edit become everyone's default (SDC-33436, cf. SDC-32039).
  BarcodePickViewHighlightStyle get highlightStyle =>
      ViewHighlightStyleDefaultsHelper.getHighlightStyle(highlightStyleJson);

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
    this.highlightStyleJson,
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
    this.logoStyle,
    this.logoAnchor,
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
        json['HighlightStyle'] as String,
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
        filterHighlightSettings,
        LogoStyleDeserializer.fromJSON(json['logoStyle'] as String),
        AnchorDeserializer.fromJSON(json['logoAnchor'] as String));
  }
}

@immutable
class BarcodePickSettingsDefaults {
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool cachingEnabled;
  final BarcodeFilterSettings filterSettings;

  const BarcodePickSettingsDefaults(this.hapticsEnabled, this.soundEnabled, this.cachingEnabled, this.filterSettings);

  factory BarcodePickSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    return BarcodePickSettingsDefaults(
      json['hapticsEnabled'] as bool,
      json['soundEnabled'] as bool,
      json['cachingEnabled'] as bool,
      BarcodeFilterSettings.fromJSON(json['barcodeFilterSettings']),
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
  final Map<String, dynamic> styleJson;
  const RectangularViewHighlightStyleDefaults(this.styleJson);

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  List<BrushForState> get brushesForState => ViewHighlightStyleDefaultsHelper.getBrushesForState(styleJson);

  factory RectangularViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    return RectangularViewHighlightStyleDefaults(jsonDecode(json['Rectangular'] as String) as Map<String, dynamic>);
  }
}

@immutable
class RectangularWithIconsViewHighlightStyleDefaults {
  final Map<String, dynamic> styleJson;
  final bool styleResponseCacheEnabled;
  final int minimumHighlightWidth;
  final int minimumHighlightHeight;

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  List<BrushForState> get brushesForState => ViewHighlightStyleDefaultsHelper.getBrushesForState(styleJson);

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  List<BrushForState> get selectedBrushesForState =>
      ViewHighlightStyleDefaultsHelper.geSelectedtBrushesForState(styleJson);

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  BarcodePickStatusIconSettings get statusIconSettings {
    final json = styleJson['statusIconSettings'] as Map<String, dynamic>?;
    return json == null ? BarcodePickStatusIconSettings() : BarcodePickStatusIconSettings.fromJSON(json);
  }

  const RectangularWithIconsViewHighlightStyleDefaults(
    this.styleJson,
    this.styleResponseCacheEnabled,
    this.minimumHighlightWidth,
    this.minimumHighlightHeight,
  );

  factory RectangularWithIconsViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var rectangularWithIconsJson = jsonDecode(json['RectangularWithIcons'] as String) as Map<String, dynamic>;
    return RectangularWithIconsViewHighlightStyleDefaults(
      rectangularWithIconsJson,
      rectangularWithIconsJson['styleResponseCacheEnabled'] as bool,
      rectangularWithIconsJson['minimumHighlightWidth'] as int,
      rectangularWithIconsJson['minimumHighlightHeight'] as int,
    );
  }
}

@immutable
class DotRectangularViewHighlightStyleDefaults {
  final Map<String, dynamic> styleJson;
  const DotRectangularViewHighlightStyleDefaults(this.styleJson);

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  List<BrushForState> get brushesForState => ViewHighlightStyleDefaultsHelper.getBrushesForState(styleJson);

  factory DotRectangularViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    return DotRectangularViewHighlightStyleDefaults(jsonDecode(json['Dot'] as String) as Map<String, dynamic>);
  }
}

@immutable
class DotWithIconsViewHighlightStyleDefaults {
  final Map<String, dynamic> styleJson;
  final bool styleResponseCacheEnabled;

  const DotWithIconsViewHighlightStyleDefaults(this.styleJson, this.styleResponseCacheEnabled);

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  List<BrushForState> get brushesForState => ViewHighlightStyleDefaultsHelper.getBrushesForState(styleJson);

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  List<BrushForState> get selectedBrushesForState =>
      ViewHighlightStyleDefaultsHelper.geSelectedtBrushesForState(styleJson);

  factory DotWithIconsViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var dotWithIconsJson = jsonDecode(json['DotWithIcons'] as String) as Map<String, dynamic>;
    return DotWithIconsViewHighlightStyleDefaults(
      dotWithIconsJson,
      dotWithIconsJson['styleResponseCacheEnabled'] as bool,
    );
  }
}

@immutable
class CustomViewHighlightStyleDefaults {
  final bool fitViewsToBarcode;
  final Map<String, dynamic>? statusIconSettingsJson;
  final int minimumHighlightWidth;
  final int minimumHighlightHeight;

  /// Fresh per read — see [ViewSettingsDefaults.highlightStyle].
  BarcodePickStatusIconSettings get statusIconSettings => statusIconSettingsJson == null
      ? BarcodePickStatusIconSettings()
      : BarcodePickStatusIconSettings.fromJSON(statusIconSettingsJson!);

  const CustomViewHighlightStyleDefaults(
    this.fitViewsToBarcode,
    this.statusIconSettingsJson,
    this.minimumHighlightWidth,
    this.minimumHighlightHeight,
  );

  factory CustomViewHighlightStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var customViewJson = jsonDecode(json['CustomView'] as String);
    return CustomViewHighlightStyleDefaults(
      customViewJson['fitViewsToBarcodeEnabled'] as bool,
      customViewJson['statusIconSettings'] as Map<String, dynamic>?,
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
    return buildBrushForStateObject(
      brush: brush.toMap(),
      barcodePickState: pickState.toString(),
    );
  }
}

class IconForState extends Serializable {
  final BarcodePickState pickState;
  final String base64EncodedIcon;

  IconForState(this.pickState, this.base64EncodedIcon);

  @override
  Map<String, dynamic> toMap() {
    return buildIconForStateObject(
      barcodePickState: pickState.toString(),
      icon: base64EncodedIcon,
    );
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
    // Correct as-is: the defaults payload uses this key, the settings payload does not.
    return BarcodePickStatusIconSettingsDefaults(
      json['ratioToHighlightSize'] as double,
      json['minSize'] as int,
      json['maxSize'] as int,
    );
  }
}
