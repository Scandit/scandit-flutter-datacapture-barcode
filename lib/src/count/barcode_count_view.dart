/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../scandit_flutter_datacapture_barcode_tracking.dart';
import '../barcode_filter_highlight_settings.dart';
import 'barcode_count.dart';
import 'barcode_count_defaults.dart';
import 'barcode_count_function_names.dart';
import 'barcode_count_toolbar_settings.dart';

enum BarcodeCountViewStyle { icon, dot }

extension BarcodeCountViewStyleSerializer on BarcodeCountViewStyle {
  static BarcodeCountViewStyle fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'dot':
        return BarcodeCountViewStyle.dot;
      case 'icon':
        return BarcodeCountViewStyle.icon;
      default:
        throw Exception('Missing BarcodeCountViewStyle for name "$jsonValue"');
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case BarcodeCountViewStyle.dot:
        return 'dot';
      case BarcodeCountViewStyle.icon:
        return 'icon';
    }
  }
}

abstract class BarcodeCountViewListener {
  static const String _didTapRecognizedBarcodeEventName = 'barcodeCountViewListener-didTapRecognizedBarcode';
  static const String _didTapUnrecognizedBarcodeEventName = 'barcodeCountViewListener-didTapUnrecognizedBarcode';
  static const String _didTapFilteredBarcodeEventName = 'barcodeCountViewListener-didTapFilteredBarcode';
  static const String _didTapRecognizedBarcodeNotInListEventName =
      'barcodeCountViewListener-didTapRecognizedBarcodeNotInList';
  static const String _didCompleteCaptureListEventName = 'barcodeCountViewListener-didCompleteCaptureList';

  void didTapRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {}
  void didTapUnrecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode);
  void didTapFilteredBarcode(BarcodeCountView view, TrackedBarcode filteredBarcode);
  void didTapRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode);
  void didCompleteCaptureList(BarcodeCountView view);
}

abstract class BarcodeCountViewUiListener {
  static const String _onExitButtonTappedEventName = 'barcodeCountViewUiListener-onExitButtonTapped';
  static const String _onListButtonTappedEventName = 'barcodeCountViewUiListener-onListButtonTapped';
  static const String _onSingleScanButtonTappedEventName = 'barcodeCountViewUiListener-onSingleScanButtonTapped';

  void didTapListButton(BarcodeCountView view);
  void didTapExitButton(BarcodeCountView view);
  void didTapSingleScanButton(BarcodeCountView view);
}

// ignore: must_be_immutable
class BarcodeCountView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  DataCaptureContext _dataCaptureContext;
  BarcodeCount _barcodeCount;
  BarcodeCountViewStyle _style;
  late _BarcodeCountViewController _controller;

  bool _isInitialized = false;

  BarcodeCountView._(this._dataCaptureContext, this._barcodeCount, this._style) : super() {
    _controller = _BarcodeCountViewController(this);
  }

  factory BarcodeCountView.forContextWithMode(DataCaptureContext dataCaptureContext, BarcodeCount barcodeCount) {
    return BarcodeCountView._(dataCaptureContext, barcodeCount, BarcodeCountDefaults.viewDefaults.style);
  }

  factory BarcodeCountView.forContextWithModeAndStyle(
      DataCaptureContext dataCaptureContext, BarcodeCount barcodeCount, BarcodeCountViewStyle style) {
    return BarcodeCountView._(dataCaptureContext, barcodeCount, style);
  }

  bool _shouldShowUserGuidanceView = BarcodeCountDefaults.viewDefaults.shouldShowUserGuidanceView;

  bool get shouldShowUserGuidanceView => _shouldShowUserGuidanceView;

  set shouldShowUserGuidanceView(bool newValue) {
    _shouldShowUserGuidanceView = newValue;
    _updateNative();
  }

  bool _shouldShowListButton = BarcodeCountDefaults.viewDefaults.shouldShowListButton;

  bool get shouldShowListButton => _shouldShowListButton;

  set shouldShowListButton(bool newValue) {
    _shouldShowListButton = newValue;
    _updateNative();
  }

  bool _shouldShowExitButton = BarcodeCountDefaults.viewDefaults.shouldShowExitButton;

  bool get shouldShowExitButton => _shouldShowExitButton;

  set shouldShowExitButton(bool newValue) {
    _shouldShowExitButton = newValue;
    _updateNative();
  }

  bool _shouldShowShutterButton = BarcodeCountDefaults.viewDefaults.shouldShowShutterButton;

  bool get shouldShowShutterButton => _shouldShowShutterButton;

  set shouldShowShutterButton(bool newValue) {
    _shouldShowShutterButton = newValue;
    _updateNative();
  }

  bool _shouldShowHints = BarcodeCountDefaults.viewDefaults.shouldShowHints;

  bool get shouldShowHints => _shouldShowHints;

  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _updateNative();
  }

  bool _shouldShowClearHighlightsButton = BarcodeCountDefaults.viewDefaults.shouldShowClearHighlightsButton;

  bool get shouldShowClearHighlightsButton => _shouldShowClearHighlightsButton;

  set shouldShowClearHighlightsButton(bool newValue) {
    _shouldShowClearHighlightsButton = newValue;
    _updateNative();
  }

  bool _shouldShowSingleScanButton = BarcodeCountDefaults.viewDefaults.shouldShowSingleScanButton;

  bool get shouldShowSingleScanButton => _shouldShowSingleScanButton;

  set shouldShowSingleScanButton(bool newValue) {
    _shouldShowSingleScanButton = newValue;
    _updateNative();
  }

  bool _shouldShowFloatingShutterButton = BarcodeCountDefaults.viewDefaults.shouldShowFloatingShutterButton;

  bool get shouldShowFloatingShutterButton => _shouldShowFloatingShutterButton;

  set shouldShowFloatingShutterButton(bool newValue) {
    _shouldShowFloatingShutterButton = newValue;
    _updateNative();
  }

  bool _shouldShowToolbar = BarcodeCountDefaults.viewDefaults.shouldShowToolbar;

  bool get shouldShowToolbar => _shouldShowToolbar;

  set shouldShowToolbar(bool newValue) {
    _shouldShowToolbar = newValue;
    _updateNative();
  }

  BarcodeCountViewUiListener? _barcodeCountViewUiListener;

  BarcodeCountViewUiListener? get uiListener => _barcodeCountViewUiListener;

  set uiListener(BarcodeCountViewUiListener? newValue) {
    _barcodeCountViewUiListener = newValue;
    _controller.setUiListener(newValue);
  }

  BarcodeCountViewListener? _barcodeCountViewListener;

  BarcodeCountViewListener? get listener => _barcodeCountViewListener;

  set listener(BarcodeCountViewListener? newValue) {
    _barcodeCountViewListener = newValue;
    _controller.setListener(newValue);
  }

  static Brush get defaultRecognizedBrush {
    return BarcodeCountDefaults.viewDefaults.defaultRecognizedBrush;
  }

  static Brush get defaultUnrecognizedBrush {
    return BarcodeCountDefaults.viewDefaults.defaultUnrecognizedBrush;
  }

  static Brush get defaultNotInListBrush {
    return BarcodeCountDefaults.viewDefaults.defaultNotInListBrush;
  }

  Brush? _recognizedBrush = BarcodeCountDefaults.viewDefaults.defaultRecognizedBrush;

  Brush? get recognizedBrush => _recognizedBrush;

  set recognizedBrush(Brush? newValue) {
    _recognizedBrush = newValue;
    _updateNative();
  }

  Brush? _unrecognizedBrush = BarcodeCountDefaults.viewDefaults.defaultUnrecognizedBrush;

  Brush? get unrecognizedBrush => _unrecognizedBrush;

  set unrecognizedBrush(Brush? newValue) {
    _unrecognizedBrush = newValue;
    _updateNative();
  }

  Brush? _notInListBrush = BarcodeCountDefaults.viewDefaults.defaultNotInListBrush;

  Brush? get notInListBrush => _notInListBrush;

  set notInListBrush(Brush? newValue) {
    _notInListBrush = newValue;
    _updateNative();
  }

  bool _shouldShowScanAreaGuides = BarcodeCountDefaults.viewDefaults.shouldShowScanAreaGuides;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _updateNative();
  }

  BarcodeFilterHighlightSettings? _filterSettings;

  BarcodeFilterHighlightSettings? get filterSettings => _filterSettings;

  set filterSettings(BarcodeFilterHighlightSettings? newValue) {
    _filterSettings = newValue;
    _updateNative();
  }

  BarcodeCountViewStyle get style => _style;

  @override
  State<StatefulWidget> createState() => _BarcodeCountViewState();

  Future<void> clearHighlights() {
    return _controller.clearHighlights();
  }

  String _listButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.listButtonAccessibilityHint;

  String get listButtonAccessibilityHint => _listButtonAccessibilityHint;

  set listButtonAccessibilityHint(String newValue) {
    _listButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _listButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.listButtonAccessibilityLabel;

  String get listButtonAccessibilityLabel => _listButtonAccessibilityLabel;

  set listButtonAccessibilityLabel(String newValue) {
    _listButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _listButtonContentDescription = BarcodeCountDefaults.viewDefaults.listButtonContentDescription;

  String get listButtonContentDescription => _listButtonContentDescription;

  set listButtonContentDescription(String newValue) {
    _listButtonContentDescription = newValue;
    _updateNative();
  }

  String _exitButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.exitButtonAccessibilityHint;

  String get exitButtonAccessibilityHint => _exitButtonAccessibilityHint;

  set exitButtonAccessibilityHint(String newValue) {
    _exitButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _exitButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.exitButtonAccessibilityLabel;

  String get exitButtonAccessibilityLabel => _exitButtonAccessibilityLabel;

  set exitButtonAccessibilityLabel(String newValue) {
    _exitButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _exitButtonContentDescription = BarcodeCountDefaults.viewDefaults.exitButtonContentDescription;

  String get exitButtonContentDescription => _exitButtonContentDescription;

  set exitButtonContentDescription(String newValue) {
    _exitButtonContentDescription = newValue;
    _updateNative();
  }

  String _shutterButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.shutterButtonAccessibilityHint;

  String get shutterButtonAccessibilityHint => _shutterButtonAccessibilityHint;

  set shutterButtonAccessibilityHint(String newValue) {
    _shutterButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _shutterButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.shutterButtonAccessibilityLabel;

  String get shutterButtonAccessibilityLabel => _shutterButtonAccessibilityLabel;

  set shutterButtonAccessibilityLabel(String newValue) {
    _shutterButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _shutterButtonContentDescription = BarcodeCountDefaults.viewDefaults.shutterButtonContentDescription;

  String get shutterButtonContentDescription => _shutterButtonContentDescription;

  set shutterButtonContentDescription(String newValue) {
    _shutterButtonContentDescription = newValue;
    _updateNative();
  }

  String _floatingShutterButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.floatingShutterButtonAccessibilityHint;

  String get floatingShutterButtonAccessibilityHint => _floatingShutterButtonAccessibilityHint;

  set floatingShutterButtonAccessibilityHint(String newValue) {
    _floatingShutterButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _floatingShutterButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.floatingShutterButtonAccessibilityLabel;

  String get floatingShutterButtonAccessibilityLabel => _floatingShutterButtonAccessibilityLabel;

  set floatingShutterButtonAccessibilityLabel(String newValue) {
    _floatingShutterButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _floatingShutterButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.floatingShutterButtonContentDescription;

  String get floatingShutterButtonContentDescription => _floatingShutterButtonContentDescription;

  set floatingShutterButtonContentDescription(String newValue) {
    _floatingShutterButtonContentDescription = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.clearHighlightsButtonAccessibilityHint;

  String get clearHighlightsButtonAccessibilityHint => _clearHighlightsButtonAccessibilityHint;

  set clearHighlightsButtonAccessibilityHint(String newValue) {
    _clearHighlightsButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.clearHighlightsButtonAccessibilityLabel;

  String get clearHighlightsButtonAccessibilityLabel => _clearHighlightsButtonAccessibilityLabel;

  set clearHighlightsButtonAccessibilityLabel(String newValue) {
    _clearHighlightsButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.clearHighlightsButtonContentDescription;

  String get clearHighlightsButtonContentDescription => _clearHighlightsButtonContentDescription;

  set clearHighlightsButtonContentDescription(String newValue) {
    _clearHighlightsButtonContentDescription = newValue;
    _updateNative();
  }

  String _singleScanButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.singleScanButtonAccessibilityHint;

  String get singleScanButtonAccessibilityHint => _singleScanButtonAccessibilityHint;

  set singleScanButtonAccessibilityHint(String newValue) {
    _singleScanButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _singleScanButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.singleScanButtonAccessibilityLabel;

  String get singleScanButtonAccessibilityLabel => _singleScanButtonAccessibilityLabel;

  set singleScanButtonAccessibilityLabel(String newValue) {
    _singleScanButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _singleScanButtonContentDescription = BarcodeCountDefaults.viewDefaults.singleScanButtonContentDescription;

  String get singleScanButtonContentDescription => _singleScanButtonContentDescription;

  set singleScanButtonContentDescription(String newValue) {
    _singleScanButtonContentDescription = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonText = BarcodeCountDefaults.viewDefaults.clearHighlightsButtonText;

  String get clearHighlightsButtonText => _clearHighlightsButtonText;

  set clearHighlightsButtonText(String newValue) {
    _clearHighlightsButtonText = newValue;
    _updateNative();
  }

  String _exitButtonText = BarcodeCountDefaults.viewDefaults.exitButtonText;

  String get exitButtonText => _exitButtonText;

  set exitButtonText(String newValue) {
    _exitButtonText = newValue;
    _updateNative();
  }

  String _textForTapShutterToScanHint = BarcodeCountDefaults.viewDefaults.textForTapShutterToScanHint;

  String get textForTapShutterToScanHint => _textForTapShutterToScanHint;

  set textForTapShutterToScanHint(String newValue) {
    _textForTapShutterToScanHint = newValue;
    _updateNative();
  }

  String _textForScanningHint = BarcodeCountDefaults.viewDefaults.textForScanningHint;

  String get textForScanningHint => _textForScanningHint;

  set textForScanningHint(String newValue) {
    _textForScanningHint = newValue;
    _updateNative();
  }

  String _textForMoveCloserAndRescanHint = BarcodeCountDefaults.viewDefaults.textForMoveCloserAndRescanHint;

  String get textForMoveCloserAndRescanHint => _textForMoveCloserAndRescanHint;

  set textForMoveCloserAndRescanHint(String newValue) {
    _textForMoveCloserAndRescanHint = newValue;
    _updateNative();
  }

  String _textForMoveFurtherAndRescanHint = BarcodeCountDefaults.viewDefaults.textForMoveFurtherAndRescanHint;

  String get textForMoveFurtherAndRescanHint => _textForMoveFurtherAndRescanHint;

  set textForMoveFurtherAndRescanHint(String newValue) {
    _textForMoveFurtherAndRescanHint = newValue;
    _updateNative();
  }

  String _textForUnrecognizedBarcodesDetectedHint =
      BarcodeCountDefaults.viewDefaults.textForUnrecognizedBarcodesDetectedHint;

  String get textForUnrecognizedBarcodesDetectedHint => _textForUnrecognizedBarcodesDetectedHint;

  set textForUnrecognizedBarcodesDetectedHint(String newValue) {
    _textForUnrecognizedBarcodesDetectedHint = newValue;
    _updateNative();
  }

  BarcodeCountToolbarSettings? _toolbarSettings;

  void setToolbarSettings(BarcodeCountToolbarSettings settings) {
    _toolbarSettings = settings;
    _updateNative();
  }

  Future<void> _updateNative() {
    if (!_isInitialized) {
      return Future.value();
    }
    return _controller.updateView();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': {
        'style': _style.jsonValue,
        'mode': _barcodeCount.toMap(),
        'shouldShowUserGuidanceView': shouldShowUserGuidanceView,
        'shouldShowListButton': shouldShowListButton,
        'shouldShowExitButton': shouldShowExitButton,
        'shouldShowShutterButton': shouldShowShutterButton,
        'shouldShowHints': shouldShowHints,
        'shouldShowClearHighlightsButton': shouldShowClearHighlightsButton,
        'shouldShowSingleScanButton': shouldShowSingleScanButton,
        'shouldShowFloatingShutterButton': shouldShowFloatingShutterButton,
        'shouldShowToolbar': shouldShowToolbar,
        'shouldShowScanAreaGuides': shouldShowScanAreaGuides,
        'toolbarSettings': _toolbarSettings?.toMap(),
      },
      'BarcodeCount': _barcodeCount.toMap()
    };

    if (listButtonAccessibilityHint != BarcodeCountDefaults.viewDefaults.listButtonAccessibilityHint) {
      json['View']['listButtonAccessibilityHint'] = listButtonAccessibilityHint; // iOS Only
    }

    if (listButtonAccessibilityLabel != BarcodeCountDefaults.viewDefaults.listButtonAccessibilityLabel) {
      json['View']['listButtonAccessibilityLabel'] = listButtonAccessibilityLabel; // iOS Only
    }

    if (listButtonContentDescription != BarcodeCountDefaults.viewDefaults.listButtonContentDescription) {
      json['View']['listButtonContentDescription'] = listButtonContentDescription; // Android only
    }

    if (exitButtonAccessibilityHint != BarcodeCountDefaults.viewDefaults.exitButtonAccessibilityHint) {
      json['View']['exitButtonAccessibilityHint'] = exitButtonAccessibilityHint; // iOS Only
    }

    if (exitButtonAccessibilityLabel != BarcodeCountDefaults.viewDefaults.exitButtonAccessibilityLabel) {
      json['View']['exitButtonAccessibilityLabel'] = exitButtonAccessibilityLabel; // iOS Only
    }

    if (exitButtonContentDescription != BarcodeCountDefaults.viewDefaults.exitButtonContentDescription) {
      json['View']['exitButtonContentDescription'] = exitButtonContentDescription; // Android only
    }

    if (shutterButtonAccessibilityHint != BarcodeCountDefaults.viewDefaults.shutterButtonAccessibilityHint) {
      json['View']['shutterButtonAccessibilityHint'] = shutterButtonAccessibilityHint; // iOS Only
    }

    if (shutterButtonAccessibilityLabel != BarcodeCountDefaults.viewDefaults.shutterButtonAccessibilityLabel) {
      json['View']['shutterButtonAccessibilityLabel'] = shutterButtonAccessibilityLabel; // iOS Only
    }

    if (shutterButtonContentDescription != BarcodeCountDefaults.viewDefaults.shutterButtonContentDescription) {
      json['View']['shutterButtonContentDescription'] = shutterButtonContentDescription; // Android Only
    }

    if (floatingShutterButtonAccessibilityHint !=
        BarcodeCountDefaults.viewDefaults.floatingShutterButtonAccessibilityHint) {
      json['View']['floatingShutterButtonAccessibilityHint'] = floatingShutterButtonAccessibilityHint; // iOS Only
    }

    if (floatingShutterButtonAccessibilityLabel !=
        BarcodeCountDefaults.viewDefaults.floatingShutterButtonAccessibilityLabel) {
      json['View']['floatingShutterButtonAccessibilityLabel'] = floatingShutterButtonAccessibilityLabel; // iOS Only
    }

    if (floatingShutterButtonContentDescription !=
        BarcodeCountDefaults.viewDefaults.floatingShutterButtonContentDescription) {
      json['View']['floatingShutterButtonContentDescription'] = floatingShutterButtonContentDescription; // Android only
    }

    if (clearHighlightsButtonAccessibilityHint !=
        BarcodeCountDefaults.viewDefaults.clearHighlightsButtonAccessibilityHint) {
      json['View']['clearHighlightsButtonAccessibilityHint'] = clearHighlightsButtonAccessibilityHint; // iOS only
    }

    if (clearHighlightsButtonAccessibilityLabel !=
        BarcodeCountDefaults.viewDefaults.clearHighlightsButtonAccessibilityLabel) {
      json['View']['clearHighlightsButtonAccessibilityLabel'] = clearHighlightsButtonAccessibilityLabel; // iOS only
    }

    if (clearHighlightsButtonContentDescription !=
        BarcodeCountDefaults.viewDefaults.clearHighlightsButtonContentDescription) {
      json['View']['clearHighlightsButtonContentDescription'] = clearHighlightsButtonContentDescription; // Android Only
    }

    if (singleScanButtonAccessibilityHint != BarcodeCountDefaults.viewDefaults.singleScanButtonAccessibilityHint) {
      json['View']['singleScanButtonAccessibilityHint'] = singleScanButtonAccessibilityHint; // iOS Only
    }

    if (singleScanButtonAccessibilityLabel != BarcodeCountDefaults.viewDefaults.singleScanButtonAccessibilityLabel) {
      json['View']['singleScanButtonAccessibilityLabel'] = singleScanButtonAccessibilityLabel; // iOS Only
    }

    if (singleScanButtonContentDescription != BarcodeCountDefaults.viewDefaults.singleScanButtonContentDescription) {
      json['View']['singleScanButtonContentDescription'] = singleScanButtonContentDescription; // Android Only
    }

    if (clearHighlightsButtonText != BarcodeCountDefaults.viewDefaults.clearHighlightsButtonText) {
      json['View']['clearHighlightsButtonText'] = clearHighlightsButtonText;
    }

    if (exitButtonText != BarcodeCountDefaults.viewDefaults.exitButtonText) {
      json['View']['exitButtonText'] = exitButtonText;
    }

    if (textForTapShutterToScanHint != BarcodeCountDefaults.viewDefaults.textForTapShutterToScanHint) {
      json['View']['textForTapShutterToScanHint'] = textForTapShutterToScanHint;
    }

    if (textForScanningHint != BarcodeCountDefaults.viewDefaults.textForScanningHint) {
      json['View']['textForScanningHint'] = textForScanningHint;
    }

    if (textForMoveCloserAndRescanHint != BarcodeCountDefaults.viewDefaults.textForMoveCloserAndRescanHint) {
      json['View']['textForMoveCloserAndRescanHint'] = textForMoveCloserAndRescanHint;
    }

    if (textForMoveFurtherAndRescanHint != BarcodeCountDefaults.viewDefaults.textForMoveFurtherAndRescanHint) {
      json['View']['textForMoveFurtherAndRescanHint'] = textForMoveFurtherAndRescanHint;
    }

    if (textForUnrecognizedBarcodesDetectedHint !=
        BarcodeCountDefaults.viewDefaults.textForUnrecognizedBarcodesDetectedHint) {
      json['View']['textForUnrecognizedBarcodesDetectedHint'] = textForUnrecognizedBarcodesDetectedHint;
    }

    if (recognizedBrush != null) {
      json['View']['recognizedBrush'] = recognizedBrush?.toMap();
    }
    if (unrecognizedBrush != null) {
      json['View']['unrecognizedBrush'] = unrecognizedBrush?.toMap();
    }
    if (notInListBrush != null) {
      json['View']['notInListBrush'] = notInListBrush?.toMap();
    }
    if (filterSettings != null) {
      json['View']['filterSettings'] = filterSettings?.toMap();
    }

    return json;
  }
}

class _BarcodeCountViewController {
  final MethodChannel _methodChannel =
      MethodChannel('com.scandit.datacapture.barcode.capture.method/barcode_count_view_methods');

  final EventChannel _eventChannel =
      const EventChannel('com.scandit.datacapture.barcode.count.event/barcode_count_view_events');

  StreamSubscription<dynamic>? _viewEventsSubscription;

  final EventChannel _uiEventChannel =
      const EventChannel('com.scandit.datacapture.barcode.count.event/barcode_count_view_ui_events');

  StreamSubscription<dynamic>? _viewUiEventsSubscription;

  BarcodeCountViewUiListener? _uiListener;
  BarcodeCountViewListener? _listener;
  final BarcodeCountView _barcodeCountView;

  _BarcodeCountViewController(this._barcodeCountView) {
    _subscribeToEvents();
  }

  void setUiListener(BarcodeCountViewUiListener? listener) {
    _uiListener = listener;
    var methodToInvoke = listener != null
        ? BarcodeCountFunctionNames.addBarcodeCountViewUiListener
        : BarcodeCountFunctionNames.removeBarcodeCountViewUiListener;

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  void _subscribeToEvents() {
    _viewEventsSubscription = _eventChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodeCountViewListener._didTapFilteredBarcodeEventName:
          _listener?.didTapFilteredBarcode(
              _barcodeCountView, TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])));
          break;
        case BarcodeCountViewListener._didTapRecognizedBarcodeEventName:
          _listener?.didTapRecognizedBarcode(
              _barcodeCountView, TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])));
          break;
        case BarcodeCountViewListener._didTapRecognizedBarcodeNotInListEventName:
          _listener?.didTapRecognizedBarcodeNotInList(
              _barcodeCountView, TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])));
          break;
        case BarcodeCountViewListener._didTapUnrecognizedBarcodeEventName:
          _listener?.didTapUnrecognizedBarcode(
              _barcodeCountView, TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])));
          break;
        case BarcodeCountViewListener._didCompleteCaptureListEventName:
          _listener?.didCompleteCaptureList(_barcodeCountView);
          break;
      }
    });

    _viewUiEventsSubscription = _uiEventChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodeCountViewUiListener._onExitButtonTappedEventName:
          _uiListener?.didTapExitButton(_barcodeCountView);
          break;
        case BarcodeCountViewUiListener._onListButtonTappedEventName:
          _uiListener?.didTapListButton(_barcodeCountView);
          break;
        case BarcodeCountViewUiListener._onSingleScanButtonTappedEventName:
          _uiListener?.didTapSingleScanButton(_barcodeCountView);
          break;
      }
    });
  }

  Future<void> clearHighlights() {
    return _methodChannel
        .invokeMethod(BarcodeCountFunctionNames.clearHighlights)
        .then((value) => null, onError: _onError);
  }

  void setListener(BarcodeCountViewListener? listener) {
    _listener = listener;
    var methodToInvoke = listener != null
        ? BarcodeCountFunctionNames.addBarcodeCountViewListener
        : BarcodeCountFunctionNames.removeBarcodeCountViewListener;

    _methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: _onError);
  }

  Future<void> updateView() {
    return _methodChannel.invokeMethod(
        BarcodeCountFunctionNames.updateBarcodeCountView, jsonEncode(_barcodeCountView.toMap()));
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    print(error);

    if (stackTrace != null) {
      print(stackTrace);
    }

    throw error;
  }

  void dispose() {
    _viewEventsSubscription?.cancel();
    _viewUiEventsSubscription?.cancel();
  }
}

class _BarcodeCountViewState extends State<BarcodeCountView> {
  _BarcodeCountViewState();

  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.BarcodeCountView';

    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (params) {
          var view = PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: {'BarcodeCountView': jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
          widget._isInitialized = true;
          return view;
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: {'BarcodeCountView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget._isInitialized = true;
        },
      );
    }
  }

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }
}
