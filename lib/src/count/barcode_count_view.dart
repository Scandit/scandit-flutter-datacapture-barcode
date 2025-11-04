/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_count.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_toolbar_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/requests/barcode_count_status_provider_request.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/requests/barcode_count_status_provider_result.dart';
import 'package:scandit_flutter_datacapture_barcode/src/tracked_barcode.dart';
import 'package:scandit_flutter_datacapture_core/experimental.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

enum BarcodeCountViewStyle {
  icon('icon'),
  dot('dot');

  const BarcodeCountViewStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BarcodeCountViewStyleSerializer on BarcodeCountViewStyle {
  static BarcodeCountViewStyle fromJSON(String jsonValue) {
    return BarcodeCountViewStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

abstract class BarcodeCountViewListener {
  static const String _brushForRecognizedBarcodeEventName = 'BarcodeCountViewListener.brushForRecognizedBarcode';
  static const String _brushForRecognizedBarcodeNotInListEventName =
      'BarcodeCountViewListener.brushForRecognizedBarcodeNotInList';

  static const String _didTapRecognizedBarcodeEventName = 'BarcodeCountViewListener.didTapRecognizedBarcode';
  static const String _didTapFilteredBarcodeEventName = 'BarcodeCountViewListener.didTapFilteredBarcode';
  static const String _didTapRecognizedBarcodeNotInListEventName =
      'BarcodeCountViewListener.didTapRecognizedBarcodeNotInList';
  static const String _didCompleteCaptureListEventName = 'BarcodeCountViewListener.didCompleteCaptureList';

  Brush? brushForRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode);
  Brush? brushForRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode);

  void didTapRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {}
  void didTapFilteredBarcode(BarcodeCountView view, TrackedBarcode filteredBarcode);
  void didTapRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode);
  void didCompleteCaptureList(BarcodeCountView view);
}

abstract class BarcodeCountViewUiListener {
  static const String _onExitButtonTappedEventName = 'BarcodeCountViewUiListener.onExitButtonTapped';
  static const String _onListButtonTappedEventName = 'BarcodeCountViewUiListener.onListButtonTapped';
  static const String _onSingleScanButtonTappedEventName = 'BarcodeCountViewUiListener.onSingleScanButtonTapped';

  void didTapListButton(BarcodeCountView view);
  void didTapExitButton(BarcodeCountView view);
  void didTapSingleScanButton(BarcodeCountView view);
}

class BarcodeCountStatusProviderCallback {
  final _BarcodeCountViewController _controller;
  final String _requestId;

  BarcodeCountStatusProviderCallback._(this._controller, this._requestId);

  Future<void> onStatusReady(BarcodeCountStatusResult statusResult) {
    return _controller.submitBarcodeCountStatusProviderCallback(statusResult, _requestId);
  }
}

abstract class BarcodeCountStatusProvider {
  static const String _onStatusRequestedEventName = 'BarcodeCountStatusProvider.onStatusRequested';

  void onStatusRequested(List<TrackedBarcode> barcodes, BarcodeCountStatusProviderCallback providerCallback);
}

// ignore: must_be_immutable
class BarcodeCountView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  DataCaptureContext _dataCaptureContext;
  BarcodeCount _barcodeCount;
  BarcodeCountViewStyle _style;
  int _viewId = 0;

  // set from the state
  _BarcodeCountViewController? _controller;

  BarcodeCountView._(this._dataCaptureContext, this._barcodeCount, this._style) : super();

  factory BarcodeCountView.forContextWithMode(DataCaptureContext dataCaptureContext, BarcodeCount barcodeCount) {
    return BarcodeCountView._(dataCaptureContext, barcodeCount, BarcodeCountDefaults.viewDefaults.style);
  }

  factory BarcodeCountView.forContextWithModeAndStyle(
    DataCaptureContext dataCaptureContext,
    BarcodeCount barcodeCount,
    BarcodeCountViewStyle style,
  ) {
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
    _controller?.setUiListener(newValue);
  }

  BarcodeCountViewListener? _barcodeCountViewListener;

  BarcodeCountViewListener? get listener => _barcodeCountViewListener;

  set listener(BarcodeCountViewListener? newValue) {
    _barcodeCountViewListener = newValue;
    _controller?.setListener(newValue);
  }

  static Brush get defaultRecognizedBrush {
    return BarcodeCountDefaults.viewDefaults.defaultRecognizedBrush;
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
    return _controller?.clearHighlights() ?? Future.value();
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

  BarcodeCountToolbarSettings? _toolbarSettings;

  Future<void> setToolbarSettings(BarcodeCountToolbarSettings settings) {
    _toolbarSettings = settings;
    return _updateNative();
  }

  bool _shouldShowListProgressBar = BarcodeCountDefaults.viewDefaults.shouldShowListProgressBar;

  bool get shouldShowListProgressBar => _shouldShowListProgressBar;

  set shouldShowListProgressBar(bool newValue) {
    _shouldShowListProgressBar = newValue;
    _updateNative();
  }

  bool _shouldShowTorchControl = BarcodeCountDefaults.viewDefaults.shouldShowTorchControl;

  bool get shouldShowTorchControl => _shouldShowTorchControl;

  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  Anchor _torchControlPosition = BarcodeCountDefaults.viewDefaults.torchControlPosition;

  Anchor get torchControlPosition => _torchControlPosition;

  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  bool _tapToUncountEnabled = BarcodeCountDefaults.viewDefaults.tapToUncountEnabled;

  bool get tapToUncountEnabled => _tapToUncountEnabled;

  set tapToUncountEnabled(bool newValue) {
    _tapToUncountEnabled = newValue;
    _updateNative();
  }

  String _textForTapToUncountHint = BarcodeCountDefaults.viewDefaults.textForTapToUncountHint;

  String get textForTapToUncountHint => _textForTapToUncountHint;

  set textForTapToUncountHint(String newValue) {
    _textForTapToUncountHint = newValue;
    _updateNative();
  }

  bool _shouldShowStatusModeButton = BarcodeCountDefaults.viewDefaults.shouldShowStatusModeButton;

  bool get shouldShowStatusModeButton => _shouldShowStatusModeButton;

  set shouldShowStatusModeButton(bool newValue) {
    _shouldShowStatusModeButton = newValue;
    _updateNative();
  }

  BarcodeCountStatusProvider? _statusProvider;

  Future<void> setStatusProvider(BarcodeCountStatusProvider provider) {
    _statusProvider = provider;
    return _controller?.addBarcodeCountStatusProvider() ?? Future.value();
  }

  Future<void> _updateNative() {
    return _controller?.updateView() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': {
        'style': _style.toString(),
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
        'shouldShowListProgressBar': shouldShowListProgressBar,
        'shouldShowTorchControl': shouldShowTorchControl,
        'torchControlPosition': torchControlPosition.toString(),
        'tapToUncountEnabled': tapToUncountEnabled,
        'textForTapToUncountHint': textForTapToUncountHint,
        'shouldShowStatusModeButton': shouldShowStatusModeButton,
        'hasStatusProvider': _statusProvider != null,
        'hasListener': _barcodeCountViewListener != null,
        'hasUiListener': _barcodeCountViewUiListener != null,
        'viewId': _viewId,
      },
      'BarcodeCount': _barcodeCount.toMap(),
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
    if (recognizedBrush != null) {
      json['View']['recognizedBrush'] = recognizedBrush?.toMap();
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

class BarcodeCount extends DataCaptureMode {
  BarcodeCountFeedback _feedback = BarcodeCountFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeCountSettings _settings;
  final List<BarcodeCountListener> _listeners = [];
  _BarcodeCountViewController? _controller;

  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller?.setModeEnabledState(newValue);
  }

  BarcodeCountFeedback get feedback => _feedback;

  set feedback(BarcodeCountFeedback newValue) {
    _feedback = newValue;
    _controller?.updateFeedback();
  }

  static CameraSettings createRecommendedCameraSettings() {
    var defaults = BarcodeCountDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
      properties: defaults.properties,
    );
  }

  BarcodeCount._(this._settings);

  BarcodeCount(BarcodeCountSettings settings) : this._(settings);

  Future<void> applySettings(BarcodeCountSettings settings) {
    _settings = settings;
    return didChange();
  }

  void addListener(BarcodeCountListener listener) {
    _checkAndSubscribeListeners();
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void _checkAndSubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller?.subscribeModeListeners();
    }
  }

  void removeListener(BarcodeCountListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller?.unsubscribeModeListeners();
    }
  }

  Future<void> didChange() {
    return _controller?.updateMode() ?? Future.value();
  }

  Future<void> reset() {
    return _controller?.reset() ?? Future.value();
  }

  Future<void> startScanningPhase() {
    return _controller?.startScanningPhase() ?? Future.value();
  }

  Future<void> endScanningPhase() {
    return _controller?.endScanningPhase() ?? Future.value();
  }

  Future<void> setBarcodeCountCaptureList(BarcodeCountCaptureList list) {
    return _controller?.setBarcodeCountCaptureList(list) ?? Future.value();
  }

  List<Barcode> _additionalBarcodes = [];

  Future<void> setAdditionalBarcodes(List<Barcode> barcodes) {
    _additionalBarcodes = barcodes;
    return didChange();
  }

  Future<void> clearAdditionalBarcodes() {
    _additionalBarcodes = [];
    return didChange();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeCount',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'additionalBarcodes': _additionalBarcodes.map((e) => e.toMap()).toList(growable: false),
      'hasListener': _listeners.isNotEmpty,
      'isEnabled': _enabled,
    };

    return json;
  }
}

class BarcodeCountCaptureList {
  final BarcodeCountCaptureListListener _listener;
  final List<TargetBarcode> _targetBarcodes;

  BarcodeCountCaptureList._(this._listener, this._targetBarcodes);

  factory BarcodeCountCaptureList.create(BarcodeCountCaptureListListener listener, List<TargetBarcode> targetBarcodes) {
    return BarcodeCountCaptureList._(listener, targetBarcodes);
  }
}

class _BarcodeCountViewController extends BaseController {
  StreamSubscription<dynamic>? _viewEventsSubscription;

  final BarcodeCountView view;

  _BarcodeCountViewController(this.view) : super(BarcodeCountFunctionNames.methodsChannelName) {
    _initialize();
  }

  void _initialize() {
    if (view._barcodeCount._listeners.isNotEmpty) {
      subscribeModeListeners();
    }
    _subscribeToEvents();
  }

  void setUiListener(BarcodeCountViewUiListener? listener) {
    var methodToInvoke = listener != null
        ? BarcodeCountFunctionNames.addBarcodeCountViewUiListener
        : BarcodeCountFunctionNames.removeBarcodeCountViewUiListener;

    methodChannel.invokeMethod(methodToInvoke).then((value) => null, onError: onError);
  }

  void _subscribeToEvents() {
    if (_viewEventsSubscription != null) return;

    _viewEventsSubscription = BarcodePluginEvents.barcodeCountEventStream.listen((event) {
      var eventJSON = jsonDecode(event);

      final viewId = eventJSON['viewId'] as int;
      if (viewId != view._viewId) return;

      var eventName = eventJSON['event'] as String;
      switch (eventName) {
        case BarcodeCountViewListener._brushForRecognizedBarcodeEventName:
          _handleBrushForRecognizedBarcodeEvent(eventJSON);
          break;
        case BarcodeCountViewListener._brushForRecognizedBarcodeNotInListEventName:
          _handleBrushForRecognizedBarcodeNotInListEvent(eventJSON);
          break;
        case BarcodeCountViewListener._didTapFilteredBarcodeEventName:
          view.listener?.didTapFilteredBarcode(view, TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])));
          break;
        case BarcodeCountViewListener._didTapRecognizedBarcodeEventName:
          view.listener?.didTapRecognizedBarcode(
            view,
            TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])),
          );
          break;
        case BarcodeCountViewListener._didTapRecognizedBarcodeNotInListEventName:
          view.listener?.didTapRecognizedBarcodeNotInList(
            view,
            TrackedBarcode.fromJSON(jsonDecode(eventJSON['trackedBarcode'])),
          );
          break;
        case BarcodeCountViewListener._didCompleteCaptureListEventName:
          view.listener?.didCompleteCaptureList(view);
          break;
        case BarcodeCountViewUiListener._onExitButtonTappedEventName:
          view.uiListener?.didTapExitButton(view);
          break;
        case BarcodeCountViewUiListener._onListButtonTappedEventName:
          view.uiListener?.didTapListButton(view);
          break;
        case BarcodeCountViewUiListener._onSingleScanButtonTappedEventName:
          view.uiListener?.didTapSingleScanButton(view);
          break;
        case BarcodeCountStatusProvider._onStatusRequestedEventName:
          _handleOnStatusRequestedEvent(eventJSON as Map<String, dynamic>);
          break;
      }
    });
  }

  void _handleOnStatusRequestedEvent(Map<String, dynamic> json) {
    final request = BarcodeCountStatusProviderRequest.fromJSON(json);

    view._statusProvider?.onStatusRequested(request.barcodes, BarcodeCountStatusProviderCallback._(this, request.id));
  }

  Future<void> submitBarcodeCountStatusProviderCallback(BarcodeCountStatusResult statusResult, String requestId) {
    final result = BarcodeCountStatusProviderResult.create(requestId, statusResult);
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.submitBarcodeCountStatusProviderCallback, {
      'viewId': view._viewId,
      'statusJson': jsonEncode(result.toMap()),
    });
  }

  Future<void> addBarcodeCountStatusProvider() {
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.addBarcodeCountStatusProvider, {
      'viewId': view._viewId,
    });
  }

  void _handleBrushForRecognizedBarcodeEvent(dynamic json) {
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));

    var brush = view.listener?.brushForRecognizedBarcode(view, trackedBarcode);
    var argument = <String, dynamic>{'trackedBarcodeId': trackedBarcode.identifier, 'viewId': view._viewId};
    if (brush != null) {
      argument['brush'] = jsonEncode(brush.toMap());
    }

    methodChannel.invokeMethod(BarcodeCountFunctionNames.finishBrushForRecognizedBarcodeEvent, argument);
  }

  void _handleBrushForRecognizedBarcodeNotInListEvent(dynamic json) {
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(json['trackedBarcode']));

    var brush = view.listener?.brushForRecognizedBarcodeNotInList(view, trackedBarcode);
    var argument = <String, dynamic>{'trackedBarcodeId': trackedBarcode.identifier, 'viewId': view._viewId};
    if (brush != null) {
      argument['brush'] = jsonEncode(brush.toMap());
    }

    methodChannel.invokeMethod(BarcodeCountFunctionNames.finishBrushForRecognizedBarcodeNotInListEvent, argument);
  }

  Future<void> clearHighlights() {
    return methodChannel.invokeMethod(
        BarcodeCountFunctionNames.clearHighlights, {'viewId': view._viewId}).then((value) => null, onError: onError);
  }

  void setListener(BarcodeCountViewListener? listener) {
    var methodToInvoke = listener != null
        ? BarcodeCountFunctionNames.addBarcodeCountViewListener
        : BarcodeCountFunctionNames.removeBarcodeCountViewListener;

    methodChannel.invokeMethod(methodToInvoke, {'viewId': view._viewId}).then((value) => null, onError: onError);
  }

  Future<void> updateView() {
    final viewMap = view.toMap()['View'];
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.updateBarcodeCountView, {
      'viewId': view._viewId,
      'viewJson': jsonEncode(viewMap),
    });
  }

  StreamSubscription<dynamic>? _streamModeSubscription;
  BarcodeCountCaptureList? _barcodeCountCaptureList;

  void subscribeModeListeners() {
    methodChannel
        .invokeMethod(BarcodeCountFunctionNames.addBarcodeCountListener, {'viewId': view._viewId})
        .then((value) => _setupBarcodeCountSubscription())
        .onError(onError);
  }

  void _setupBarcodeCountSubscription() {
    _streamModeSubscription = BarcodePluginEvents.barcodeCountEventStream.listen((event) async {
      var eventJSON = jsonDecode(event);
      final viewId = eventJSON['viewId'] as int;
      if (viewId != view._viewId) return;

      var eventName = eventJSON['event'] as String;
      if (eventName == 'BarcodeCountListener.onScan') {
        var session = BarcodeCountSession.fromJSON(eventJSON);
        await _notifyListenersOfOnScan(session);
        methodChannel.invokeMethod(BarcodeCountFunctionNames.barcodeCountFinishOnScan, {
          'viewId': view._viewId,
          'enabled': view._barcodeCount.isEnabled,
        })
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => log(error));
      } else if (eventName == 'BarcodeCountCaptureListListener.didUpdateSession') {
        var session = BarcodeCountCaptureListSession.fromJSON(jsonDecode(eventJSON['session']));
        _notifyBarcodeCountCaptureList(session);
      }
    });
  }

  void unsubscribeModeListeners() {
    _streamModeSubscription?.cancel();
    _streamModeSubscription = null;
    methodChannel.invokeMethod(BarcodeCountFunctionNames.removeBarcodeCountListener, {'viewId': view._viewId}).then(
        (value) => null,
        onError: onError);
  }

  Future<void> reset() {
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.resetMode, {'viewId': view._viewId});
  }

  Future<void> startScanningPhase() {
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.startScanningPhase, {'viewId': view._viewId});
  }

  Future<void> endScanningPhase() {
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.endScanningPhase, {'viewId': view._viewId});
  }

  Future<void> setBarcodeCountCaptureList(BarcodeCountCaptureList list) {
    _barcodeCountCaptureList = list;
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.setBarcodeCountCaptureList, {
      'viewId': view._viewId,
      'targetBarcodes': jsonEncode(list._targetBarcodes.map((e) => e.toMap()).toList()),
    });
  }

  Future<FrameData> _getLastFrameData(BarcodeCountSession session) {
    return methodChannel
        .invokeMethod(BarcodeCountFunctionNames.getBarcodeCountLastFrameData, session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  Future<void> updateMode() {
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.updateBarcodeCountMode, {
      'viewId': view._viewId,
      'modeJson': jsonEncode(view._barcodeCount.toMap()),
    });
  }

  Future<void> updateFeedback() {
    return methodChannel.invokeMethod(BarcodeCountFunctionNames.updateFeedback, {
      'viewId': view._viewId,
      'feedbackJson': jsonEncode(view._barcodeCount.feedback.toMap()),
    });
  }

  void setModeEnabledState(bool newValue) {
    methodChannel.invokeMethod(BarcodeCountFunctionNames.setModeEnabledState,
        {'viewId': view._viewId, 'enabled': newValue}).then((value) => null, onError: onError);
  }

  Future<void> _notifyListenersOfOnScan(BarcodeCountSession session) async {
    for (var listener in view._barcodeCount._listeners) {
      await listener.didScan(view._barcodeCount, session, () => _getLastFrameData(session));
    }
  }

  void _notifyBarcodeCountCaptureList(BarcodeCountCaptureListSession session) {
    var barcodeCountCaptureList = _barcodeCountCaptureList;
    if (barcodeCountCaptureList != null) {
      _barcodeCountCaptureList?._listener.didUpdateSession(barcodeCountCaptureList, session);
    }
  }

  @override
  void dispose() {
    unsubscribeModeListeners();

    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
    super.dispose();
  }
}

class _BarcodeCountViewState extends State<BarcodeCountView> implements CameraOwner {
  final int _viewId = Random().nextInt(0x7FFFFFFF);

  _BarcodeCountViewController? _controller;
  bool _isRouteActive = true;

  @override
  String get id => 'barcode-count-view-$_viewId';

  _BarcodeCountViewState();

  @override
  void initState() {
    super.initState();
    widget._viewId = _viewId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkRouteStatus();
  }

  void _checkRouteStatus() {
    final route = ModalRoute.of(context);
    final wasActive = _isRouteActive;
    _isRouteActive = route?.isCurrent == true;

    if (wasActive != _isRouteActive) {
      if (_isRouteActive) {
        CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, this);
      } else {
        CameraOwnershipHelper.releaseOwnership(CameraPosition.worldFacing, this);
      }
    }
  }

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
            ..addOnPlatformViewCreatedListener((id) {
              _controller = _BarcodeCountViewController(widget);
              widget._controller = _controller;
              widget._barcodeCount._controller = _controller;
            })
            ..create();
          return view;
        },
      );
    } else {
      return UiKitView(
        viewType: viewType,
        creationParams: {'BarcodeCountView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _controller = _BarcodeCountViewController(widget);
          widget._controller = _controller;
          widget._barcodeCount._controller = _controller;
        },
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
