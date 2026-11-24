/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

// ignore_for_file: must_be_immutable - packaging injects doc comments above the
// class, which detaches a line-level ignore from the class it applies to.

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_constants.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_feedback.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_transformer.dart';
import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_view_ui_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show
        BarcodeFindListenerOnSearchPaused,
        BarcodeFindListenerOnSearchStarted,
        BarcodeFindListenerOnSearchStopped,
        BarcodeFindTransformerTransformBarcodeData,
        BarcodeFindViewUiListenerOnFinishButtonTapped;
import 'package:scandit_flutter_datacapture_core/experimental.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_find_view_settings.dart';

/// [BarcodeFind] comes with a ready-to-use search UI that uses augmented reality overlays to highlight items that match predefined criteria. The BarcodeFindView integrates with any app in just a few lines of code.
///
/// Added in version 6.22.0
class BarcodeFindView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  final DataCaptureContext _dataCaptureContext;
  final BarcodeFind _barcodeFind;
  final BarcodeFindViewSettings? _barcodeFindViewSettings;
  final CameraSettings? _cameraSettings;
  var _startSearching = false;
  int _viewId = -1;

  _BarcodeFindViewController? _controller;

  bool _isInitialized = false;

  BarcodeFindView._(this._dataCaptureContext, this._barcodeFind, this._barcodeFindViewSettings, this._cameraSettings)
      : super();

  /// Constructs a new BarcodeFind view. The view will use default settings.
  ///
  /// Added in version 6.22.0
  factory BarcodeFindView.forMode(DataCaptureContext dataCaptureContext, BarcodeFind barcodeFind) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, null, null);
  }

  factory BarcodeFindView.forModeWithViewSettings(
    DataCaptureContext dataCaptureContext,
    BarcodeFind barcodeFind,
    BarcodeFindViewSettings viewSettings,
  ) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, viewSettings, null);
  }

  factory BarcodeFindView.forModeWithViewSettingsAndCameraSettings(
    DataCaptureContext dataCaptureContext,
    BarcodeFind barcodeFind,
    BarcodeFindViewSettings viewSettings,
    CameraSettings cameraSettings,
  ) {
    return BarcodeFindView._(dataCaptureContext, barcodeFind, viewSettings, cameraSettings);
  }

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 6.22.0
  @override
  State<StatefulWidget> createState() => _BarcodeFindViewState();

  /// Method to call for stopping the mode. For instance, it can be called when the view controller containing BarcodeFindView is about to disappear (i.e., UIViewController’s viewWillDisappear).
  ///
  /// Added in version 6.22.0
  Future<void> stopSearching() {
    _startSearching = false;
    return _controller?.stopViewSearching() ?? Future.value();
  }

  /// Starts the searching process. You can call this method if you want to trigger the searching process without any user interaction.
  ///
  /// Added in version 6.22.0
  Future<void> startSearching() {
    _startSearching = true;
    return _controller?.startViewSearching() ?? Future.value();
  }

  /// Pauses the searching process. You can call this method if you want to trigger pausing the searching process without any user interaction.
  ///
  /// Added in version 6.22.0
  Future<void> pauseSearching() {
    _startSearching = false;
    return _controller?.pauseViewSearching() ?? Future.value();
  }

  BarcodeFindViewUiListener? _barcodeFindViewUiListener;

  /// Sets the listener which is called whenever the finish button is tapped from the view.
  ///
  /// Added in version 6.22.0
  BarcodeFindViewUiListener? get uiListener => _barcodeFindViewUiListener;

  /// Sets the listener which is called whenever the finish button is tapped from the view.
  ///
  /// Added in version 6.22.0
  set uiListener(BarcodeFindViewUiListener? newValue) {
    _barcodeFindViewUiListener = newValue;
    _controller?.setUiListener(newValue);
  }

  bool _shouldShowUserGuidanceView = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowUserGuidanceView;

  /// Indicates whether guidance should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowUserGuidanceView => _shouldShowUserGuidanceView;

  /// Indicates whether guidance should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  set shouldShowUserGuidanceView(bool newValue) {
    _shouldShowUserGuidanceView = newValue;
    _updateNative();
  }

  bool _shouldShowHints = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowHints;

  /// Indicates whether hints should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowHints => _shouldShowHints;

  /// Indicates whether hints should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _updateNative();
  }

  bool _shouldShowCarousel = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowCarousel;

  /// Indicates whether the item carousel should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowCarousel => _shouldShowCarousel;

  /// Indicates whether the item carousel should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  set shouldShowCarousel(bool newValue) {
    _shouldShowCarousel = newValue;
    _updateNative();
  }

  bool _shouldShowPauseButton = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowPauseButton;

  /// Indicates whether the pause button should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowPauseButton => _shouldShowPauseButton;

  /// Indicates whether the pause button should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  set shouldShowPauseButton(bool newValue) {
    _shouldShowPauseButton = newValue;
    _updateNative();
  }

  bool _shouldShowFinishButton = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowFinishButton;

  /// Indicates whether the finish button should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowFinishButton => _shouldShowFinishButton;

  /// Indicates whether the finish button should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.22.0
  set shouldShowFinishButton(bool newValue) {
    _shouldShowFinishButton = newValue;
    _updateNative();
  }

  bool _shouldShowProgressBar = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowProgressBar;

  /// Indicates whether the progress bar should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowProgressBar => _shouldShowProgressBar;

  /// Indicates whether the progress bar should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.22.0
  set shouldShowProgressBar(bool newValue) {
    _shouldShowProgressBar = newValue;
    _updateNative();
  }

  bool _shouldShowTorchControl = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowTorchControl;

  /// Indicates whether the torch control button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.22.0
  bool get shouldShowTorchControl => _shouldShowTorchControl;

  /// Indicates whether the torch control button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.22.0
  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  bool _shouldShowZoomControl = BarcodeFindDefaults.barcodeFindViewDefaults.shouldShowZoomControl;

  /// Indicates whether the zoom control should be shown to the user, allowing them to switch between the normal and ultra-wide lenses.
  ///
  /// Default is *false*.
  ///
  /// The zoom control requires a device with an ultra-wide camera. On devices without an ultra-wide camera, setting this property to *true* has no effect.
  ///
  /// Added in version 8.5.0
  bool get shouldShowZoomControl => _shouldShowZoomControl;

  /// Indicates whether the zoom control should be shown to the user, allowing them to switch between the normal and ultra-wide lenses.
  ///
  /// Default is *false*.
  ///
  /// The zoom control requires a device with an ultra-wide camera. On devices without an ultra-wide camera, setting this property to *true* has no effect.
  ///
  /// Added in version 8.5.0
  set shouldShowZoomControl(bool newValue) {
    _shouldShowZoomControl = newValue;
    _updateNative();
  }

  /// Returns whether the device supports listening for hardware button events. This is true for devices with api >= 28.
  ///
  /// This method is only supported on Android devices.
  ///
  /// Added in version 8.5.0
  static bool get hardwareTriggerSupported => BarcodeFindDefaults.barcodeFindViewDefaults.hardwareTriggerSupported;

  Anchor _torchControlPosition = BarcodeFindDefaults.barcodeFindViewDefaults.torchControlPosition;

  /// Updates the position of the torch control button.
  ///
  /// Only [Anchor.topLeft], [Anchor.topCenter], [Anchor.topRight] and [Anchor.bottomLeft] are supported.
  ///
  /// Any other value will default to [Anchor.topLeft].
  ///
  /// Added in version 6.22.0
  Anchor get torchControlPosition => _torchControlPosition;

  /// Updates the position of the torch control button.
  ///
  /// Only [Anchor.topLeft], [Anchor.topCenter], [Anchor.topRight] and [Anchor.bottomLeft] are supported.
  ///
  /// Any other value will default to [Anchor.topLeft].
  ///
  /// Added in version 6.22.0
  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  LogoStyle _logoStyle = BarcodeFindDefaults.barcodeFindViewDefaults.logoStyle;

  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.extended].
  ///
  /// Added in version 8.6.0
  LogoStyle get logoStyle => _logoStyle;

  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.extended].
  ///
  /// Added in version 8.6.0
  set logoStyle(LogoStyle newValue) {
    _logoStyle = newValue;
    _updateNative();
  }

  Anchor _logoAnchor = BarcodeFindDefaults.barcodeFindViewDefaults.logoAnchor;

  /// The anchor point used to position the Scandit logo.
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 8.6.0
  Anchor get logoAnchor => _logoAnchor;

  /// The anchor point used to position the Scandit logo.
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 8.6.0
  set logoAnchor(Anchor newValue) {
    _logoAnchor = newValue;
    _updateNative();
  }

  /// The desired camera state when BarcodeFind stops searching.
  ///
  /// iOS only — this property has no effect on Android.
  FrameSourceState _cameraStateOnStop = BarcodeFindDefaults.barcodeFindViewDefaults.cameraStateOnStop;

  /// Specifies the desired camera state when BarcodeFind stops searching. This property allows optimization of camera transitions when switching between different capture modes.
  ///
  /// On Flutter, Capacitor, Cordova and React Native this property is only effective on iOS; it is ignored on Android.
  ///
  /// For example, setting this to [FrameSourceState.standby] instead of the default [FrameSourceState.off] can improve camera startup times when transitioning to another mode (such as SparkScan) that uses standby state, as it avoids the On→Off→Standby transition sequence.
  ///
  /// Default is [FrameSourceState.off].
  ///
  /// Added in version 8.6.0
  FrameSourceState get cameraStateOnStop => _cameraStateOnStop;

  /// Specifies the desired camera state when BarcodeFind stops searching. This property allows optimization of camera transitions when switching between different capture modes.
  ///
  /// On Flutter, Capacitor, Cordova and React Native this property is only effective on iOS; it is ignored on Android.
  ///
  /// For example, setting this to [FrameSourceState.standby] instead of the default [FrameSourceState.off] can improve camera startup times when transitioning to another mode (such as SparkScan) that uses standby state, as it avoids the On→Off→Standby transition sequence.
  ///
  /// Default is [FrameSourceState.off].
  ///
  /// Added in version 8.6.0
  set cameraStateOnStop(FrameSourceState newValue) {
    _cameraStateOnStop = newValue;
    _updateNative();
  }

  String? _textForCollapseCardsButton = BarcodeFindDefaults.barcodeFindViewDefaults.textForCollapseCardsButton;

  /// Overrides the default text displayed in the button for collapsing the item carousel.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  String? get textForCollapseCardsButton => _textForCollapseCardsButton;

  /// Overrides the default text displayed in the button for collapsing the item carousel.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  set textForCollapseCardsButton(String? newValue) {
    _textForCollapseCardsButton = newValue;
    _updateNative();
  }

  String? _textForAllItemsFoundSuccessfullyHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForAllItemsFoundSuccessfullyHint;

  /// Overrides the default text displayed in the green confirmation view shown when all items have been found.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  String? get textForAllItemsFoundSuccessfullyHint => _textForAllItemsFoundSuccessfullyHint;

  /// Overrides the default text displayed in the green confirmation view shown when all items have been found.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  set textForAllItemsFoundSuccessfullyHint(String? newValue) {
    _textForAllItemsFoundSuccessfullyHint = newValue;
    _updateNative();
  }

  String? _textForPointAtBarcodesToSearchHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForPointAtBarcodesToSearchHint;

  /// Overrides the default text for the “Point at barcodes to search” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  String? get textForPointAtBarcodesToSearchHint => _textForPointAtBarcodesToSearchHint;

  /// Overrides the default text for the “Point at barcodes to search” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  set textForPointAtBarcodesToSearchHint(String? newValue) {
    _textForPointAtBarcodesToSearchHint = newValue;
    _updateNative();
  }

  String? _textForMoveCloserToBarcodesHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForMoveCloserToBarcodesHint;

  /// Overrides the default text for the “Move closer” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  String? get textForMoveCloserToBarcodesHint => _textForMoveCloserToBarcodesHint;

  /// Overrides the default text for the “Move closer” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  set textForMoveCloserToBarcodesHint(String? newValue) {
    _textForMoveCloserToBarcodesHint = newValue;
    _updateNative();
  }

  String? _textForTapShutterToPauseScreenHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForTapShutterToPauseScreenHint;

  /// Overrides the default text for “Tap shutter to pause” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  String? get textForTapShutterToPauseScreenHint => _textForTapShutterToPauseScreenHint;

  /// Overrides the default text for “Tap shutter to pause” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  set textForTapShutterToPauseScreenHint(String? newValue) {
    _textForTapShutterToPauseScreenHint = newValue;
    _updateNative();
  }

  String? _textForTapShutterToResumeSearchHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForTapShutterToResumeSearchHint;

  /// Overrides the default text for “Tap shutter to resume” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  String? get textForTapShutterToResumeSearchHint => _textForTapShutterToResumeSearchHint;

  /// Overrides the default text for “Tap shutter to resume” hint.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.22.0
  set textForTapShutterToResumeSearchHint(String? newValue) {
    _textForTapShutterToResumeSearchHint = newValue;
    _updateNative();
  }

  String? _textForItemListUpdatedHint = BarcodeFindDefaults.barcodeFindViewDefaults.textForItemListUpdatedHint;

  /// Overrides the default text displayed in the confirmation view shown when the item list has been updated.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.24.0
  String? get textForItemListUpdatedHint => _textForItemListUpdatedHint;

  /// Overrides the default text displayed in the confirmation view shown when the item list has been updated.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.24.0
  set textForItemListUpdatedHint(String? newValue) {
    _textForItemListUpdatedHint = newValue;
    _updateNative();
  }

  String? _textForItemListUpdatedWhenPausedHint =
      BarcodeFindDefaults.barcodeFindViewDefaults.textForItemListUpdatedWhenPausedHint;

  /// Overrides the default text displayed in the confirmation view shown when the item list has been updated and search is paused.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.24.0
  String? get textForItemListUpdatedWhenPausedHint => _textForItemListUpdatedWhenPausedHint;

  /// Overrides the default text displayed in the confirmation view shown when the item list has been updated and search is paused.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.24.0
  set textForItemListUpdatedWhenPausedHint(String? newValue) {
    _textForItemListUpdatedWhenPausedHint = newValue;
    _updateNative();
  }

  Future<void> _updateNative() {
    if (!_isInitialized) {
      return Future.value();
    }
    return _controller?.updateView() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'View': {
        'viewId': _viewId,
        'shouldShowUserGuidanceView': shouldShowUserGuidanceView,
        'shouldShowHints': shouldShowHints,
        'shouldShowCarousel': shouldShowCarousel,
        'shouldShowPauseButton': shouldShowPauseButton,
        'shouldShowFinishButton': shouldShowFinishButton,
        'shouldShowProgressBar': shouldShowProgressBar,
        'shouldShowTorchControl': shouldShowTorchControl,
        'shouldShowZoomControl': shouldShowZoomControl,
        'torchControlPosition': torchControlPosition.toString(),
        'logoStyle': logoStyle.toString(),
        'logoAnchor': logoAnchor.toString(),
        // cameraStateOnStop is an iOS-only native API on BarcodeFindView.
        if (Platform.isIOS) 'cameraStateOnStop': cameraStateOnStop.toString(),
        'textForCollapseCardsButton': textForCollapseCardsButton,
        'textForAllItemsFoundSuccessfullyHint': textForAllItemsFoundSuccessfullyHint,
        'textForPointAtBarcodesToSearchHint': textForPointAtBarcodesToSearchHint,
        'textForMoveCloserToBarcodesHint': textForMoveCloserToBarcodesHint,
        'textForTapShutterToPauseScreenHint': textForTapShutterToPauseScreenHint,
        'textForTapShutterToResumeSearchHint': textForTapShutterToResumeSearchHint,
        'startSearching': _startSearching,
        'textForItemListUpdatedHint': textForItemListUpdatedHint,
        'textForItemListUpdatedWhenPausedHint': textForItemListUpdatedWhenPausedHint,
        'hasListener': _barcodeFindViewUiListener != null,
      },
      'BarcodeFind': _barcodeFind.toMap(),
    };

    if (_barcodeFindViewSettings != null) {
      json['View']['viewSettings'] = _barcodeFindViewSettings.toMap();
    }

    if (_cameraSettings != null) {
      json['View']['cameraSettings'] = _cameraSettings.toMap();
    }

    return json;
  }
}

/// Capture mode that implements BarcodeFind.
///
/// Added in version 6.22.0
class BarcodeFind extends DataCaptureMode {
  BarcodeFindFeedback _feedback = BarcodeFindFeedback.defaultFeedback;
  bool _enabled = true;
  BarcodeFindSettings _settings;
  final List<BarcodeFindListener> _listeners = [];

  BarcodeFindTransformer? _barcodeTransformer;

  _BarcodeFindViewController? _controller;

  Set<BarcodeFindItem> _itemsToFind = {};

  BarcodeFind._(this._settings) {
    _feedback.addListener(_updateFeedbackHandler);
  }

  void _updateFeedbackHandler() {
    _controller?.updateFeedback();
  }

  /// Constructs a new BarcodeFind mode with the provided settings.
  ///
  /// Added in version 6.22.0
  BarcodeFind(BarcodeFindSettings settings) : this._(settings);

  /// Returns the recommended camera settings to use with the mode.
  ///
  /// Added in version 7.6.0
  static CameraSettings createRecommendedCameraSettings() {
    var defaults = BarcodeFindDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
      properties: defaults.properties,
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  /// Instance of [BarcodeFindFeedback] that is used by the barcode scanner to notify users about Found events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// Added in version 6.22.0
  BarcodeFindFeedback get feedback => _feedback;

  /// Instance of [BarcodeFindFeedback] that is used by the barcode scanner to notify users about Found events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// Added in version 6.22.0
  set feedback(BarcodeFindFeedback newValue) {
    // Remove old listener
    _feedback.removeListener(_updateFeedbackHandler);
    _feedback = newValue;
    // Add new listener
    _feedback.addListener(_updateFeedbackHandler);
    // Update feedback
    _controller?.updateFeedback();
  }

  /// Asynchronously applies the new settings to the barcode scanner. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 6.22.0
  Future<void> applySettings(BarcodeFindSettings settings) {
    _settings = settings;
    return _didChange();
  }

  /// Adds the listener to this BarcodeFind instance.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.22.0
  void addListener(BarcodeFindListener listener) {
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

  /// Removes a previously added listener from this BarcodeFind instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.22.0
  void removeListener(BarcodeFindListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller?.unsubscribeModeListeners();
    }
  }

  /// Sets the list of items to search. This method runs asynchronously.
  ///
  /// Added in version 6.22.0
  Future<void> setItemList(Set<BarcodeFindItem> items) {
    _itemsToFind = items;
    return _controller?.setItemList(items) ?? Future.value();
  }

  /// Starts or resumes the search process.
  ///
  /// Added in version 6.22.0
  Future<void> start() {
    return _controller?.modeStart() ?? Future.value();
  }

  /// Pauses the search process.
  ///
  /// Added in version 6.22.0
  Future<void> pause() {
    return _controller?.modePause() ?? Future.value();
  }

  /// Stops the search process and clears the list of found items. If this is not called, the BarcodeFind instance will remember all found items.
  ///
  /// Added in version 6.22.0
  Future<void> stop() {
    return _controller?.modeStop() ?? Future.value();
  }

  Future<void> _didChange() {
    return _controller?.updateMode() ?? Future.value();
  }

  /// Sets a transformer for this instance of BarcodeFind.
  ///
  /// Added in version 6.23.0
  Future<void> setBarcodeTransformer(BarcodeFindTransformer barcodeTransformer) {
    _barcodeTransformer = barcodeTransformer;
    return _controller?.setBarcodeTransformer() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'barcodeFind',
      'feedback': _feedback.toMap(),
      'settings': _settings.toMap(),
      'itemsToFind': jsonEncode(_itemsToFind.map((e) => e.toMap()).toList()),
      'hasBarcodeTransformer': _barcodeTransformer != null,
      'hasListeners': _listeners.isNotEmpty,
    };

    return json;
  }

  /// This flag indicates whether the BarcodeFind mode is currently processing frames to recognise barcodes.
  ///
  /// Changing this property from *false* to *true* causes the connected [BarcodeFindView] to start its scanning flow.
  ///
  /// Changing this property from *true* to *false* causes the connected [BarcodeFindView] to stop its scanning flow and go to idle mode.
  ///
  /// Added in version 6.22.0
  @override
  bool get isEnabled => _enabled;

  /// This flag indicates whether the BarcodeFind mode is currently processing frames to recognise barcodes.
  ///
  /// Changing this property from *false* to *true* causes the connected [BarcodeFindView] to start its scanning flow.
  ///
  /// Changing this property from *true* to *false* causes the connected [BarcodeFindView] to stop its scanning flow and go to idle mode.
  ///
  /// Added in version 6.22.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller?.setModeEnabledState(newValue);
  }
}

class _BarcodeFindViewController extends BaseController {
  StreamSubscription<dynamic>? _viewEventsSubscription;
  late final BarcodeMethodHandler barcodeMethodHandler;
  final Set<String> _warnedSchemaValidationEvents = {};

  final BarcodeFindView view;

  _BarcodeFindViewController(this.view) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    initialize();
  }

  void initialize() {
    if (view.uiListener != null) {
      subscribeToViewEvents();
    }

    if (view._barcodeFind._listeners.isNotEmpty) {
      subscribeModeListenersEvents();
    }

    if (view._barcodeFind._barcodeTransformer != null) {
      subscribeBarcodeTransformerEvents();
    }
  }

  void subscribeToViewEvents() {
    if (_viewEventsSubscription != null) {
      return;
    }

    _viewEventsSubscription = BarcodePluginEvents.barcodeFindEventStream.forView(view._viewId).listen((event) {
      // `FlutterEvent.payload` throws FormatException on undecodable JSON
      // (`flutter_event.dart`), and an uncaught throw here escapes into the stream
      // listener. The tolerant parse below only covers a payload we already decoded.
      try {
        if (event.isEvent(BarcodeFindConstants.onFinishButtonTappedEventName)) {
          _handleOnFinishButtonTapped(event.payload);
        }
      } catch (error) {
        developer.log('BarcodeFind event dispatch failed: $error');
      }
    });
  }

  void unsubscribeFromViewEvents() {
    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
  }

  void _handleOnFinishButtonTapped(Map<String, dynamic> json) {
    final payload = _parsePayloadTolerantly<BarcodeFindViewUiListenerOnFinishButtonTapped>(
      json,
      (raw) => BarcodeFindViewUiListenerOnFinishButtonTapped.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        return BarcodeFindViewUiListenerOnFinishButtonTapped(
          foundItems: _coerceStringList(map['foundItems']),
          viewId: _coerceInt(map['viewId']),
          event: BarcodeFindConstants.onFinishButtonTappedEventName,
        );
      },
      'onFinishButtonTapped',
    );
    view._barcodeFindViewUiListener?.didTapFinishButton(_rehydrateFoundItems(payload.foundItems));
  }

  // Mirrors the jsmobile controller's `rehydrateFoundItems`: filter the known item list by
  // membership instead of looking each reported barcodeData up with `firstWhere`, which throws
  // StateError when `_itemsToFind` no longer contains a reported barcode - reachable if
  // `setItemList` runs between the search and the event. The TS side has always been
  // non-throwing here (it uses `filter`); Dart now matches (SDC-32667).
  Set<BarcodeFindItem> _rehydrateFoundItems(List<String> foundItemsData) {
    return view._barcodeFind._itemsToFind
        .where((item) => foundItemsData.contains(item.searchOptions.barcodeData))
        .toSet();
  }

  // ACK-owing note (subscribeBarcodeTransformerEvents below): native blocks on the ack call
  // there, so a schema-parse failure must not prevent it - parse tolerantly (fall back to
  // reading the raw map) rather than throw, so the ack still fires promptly instead of
  // surfacing only after the native-side timeout.
  //
  // Copied (near-)verbatim from BarcodeSelection's `_parsePayloadTolerantly` (SDC-32666), which
  // documents why the Dart copy diverges from the TS `EventDataParser.parseIfShouldHandle`
  // pattern: Dart's generated schema types are real classes with required fields, so an
  // unchecked `raw as unknown as T` reinterpret isn't expressible here - `fallback` hand-builds
  // a best-effort T from the raw map instead.
  // The `fallback` builders passed to [_parsePayloadTolerantly] run precisely when the strict
  // generated parser has already rejected the payload, so they must not throw themselves: a throw
  // escapes into the stream listener, and on the ack-owing transformer path it would strand a
  // native caller that waits without a timeout. Coerce defensively, and take `event` from the
  // known constant for the branch rather than re-reading the field the parser just rejected
  // (SDC-32667).
  static List<String> _coerceStringList(Object? value) => value is List ? value.map((e) => '$e').toList() : <String>[];

  static int _coerceInt(Object? value) => value is int
      ? value
      : value is num
          ? value.toInt()
          : -1;

  T _parsePayloadTolerantly<T>(
    Map<String, dynamic> raw,
    T Function(Object?) parse,
    T Function(Object?) fallback,
    String event,
  ) {
    try {
      return parse(raw);
    } catch (error) {
      if (_warnedSchemaValidationEvents.add(event)) {
        developer.log('BarcodeFind $event payload failed schema validation: $error');
      }
      return fallback(raw);
    }
  }

  Future<void> updateView() {
    return barcodeMethodHandler
        .updateFindView(viewId: view._viewId, barcodeFindViewJson: jsonEncode(view.toMap()))
        .onError(onError);
  }

  Future<void> stopViewSearching() {
    return barcodeMethodHandler.barcodeFindViewStopSearching(viewId: view._viewId).onError(onError);
  }

  Future<void> setItemList(Set<BarcodeFindItem> items) {
    return barcodeMethodHandler
        .barcodeFindSetItemList(viewId: view._viewId, itemsJson: jsonEncode(items.map((e) => e.toMap()).toList()))
        .onError(onError);
  }

  Future<void> startViewSearching() {
    return barcodeMethodHandler.barcodeFindViewStartSearching(viewId: view._viewId).onError(onError);
  }

  Future<void> pauseViewSearching() {
    return barcodeMethodHandler.barcodeFindViewPauseSearching(viewId: view._viewId).onError(onError);
  }

  void setUiListener(BarcodeFindViewUiListener? listener) {
    if (listener != null) {
      barcodeMethodHandler.registerBarcodeFindViewListener(viewId: view._viewId).onError(onError);
      subscribeToViewEvents();
    } else {
      barcodeMethodHandler.unregisterBarcodeFindViewListener(viewId: view._viewId).onError(onError);
      unsubscribeFromViewEvents();
    }
  }

  // Mode

  StreamSubscription<dynamic>? _modeEventsSubscription;
  StreamSubscription<dynamic>? _barcodeTransformerSubscription;

  Future<void> updateMode() {
    return barcodeMethodHandler
        .updateFindMode(viewId: view._viewId, barcodeFindJson: jsonEncode(view._barcodeFind.toMap()))
        .onError(onError);
  }

  Future<void> modeStart() {
    return barcodeMethodHandler.barcodeFindModeStart(viewId: view._viewId).onError(onError);
  }

  Future<void> modePause() {
    return barcodeMethodHandler.barcodeFindModePause(viewId: view._viewId).onError(onError);
  }

  Future<void> modeStop() {
    return barcodeMethodHandler.barcodeFindModeStop(viewId: view._viewId).onError(onError);
  }

  void subscribeModeListeners() {
    barcodeMethodHandler.registerBarcodeFindListener(viewId: view._viewId).onError(onError);
    subscribeModeListenersEvents();
  }

  void subscribeModeListenersEvents() {
    if (_modeEventsSubscription != null) {
      return;
    }

    _modeEventsSubscription = BarcodePluginEvents.barcodeFindEventStream.forView(view._viewId).listen((event) {
      // `FlutterEvent.payload` throws FormatException on undecodable JSON
      // (`flutter_event.dart`), and an uncaught throw here escapes into the stream
      // listener. The tolerant parse below only covers a payload we already decoded.
      try {
        if (event.isEvent(BarcodeFindConstants.onTransformBarcodeData)) {
          // handled separately
          return;
        }

        if (event.isEvent(BarcodeFindConstants.onSearchStartedEvent)) {
          // The mode-listener stream is already filtered `.forView(view._viewId)`, so the parsed
          // payload carries no extra information beyond schema validation itself - parsing it is
          // what makes a schema regression on this event visible via the fallback path.
          _parsePayloadTolerantly<BarcodeFindListenerOnSearchStarted>(
            event.payload,
            (raw) => BarcodeFindListenerOnSearchStarted.fromJson(raw),
            (raw) {
              final map = raw is Map ? raw : const <String, dynamic>{};
              return BarcodeFindListenerOnSearchStarted(
                viewId: _coerceInt(map['viewId']),
                event: BarcodeFindConstants.onSearchStartedEvent,
              );
            },
            'onSearchStarted',
          );
          for (var listener in view._barcodeFind._listeners.toList()) {
            listener.didStartSearch();
          }
          return;
        }

        if (event.isEvent(BarcodeFindConstants.onSearchPausedEvent)) {
          final payload = _parsePayloadTolerantly<BarcodeFindListenerOnSearchPaused>(
            event.payload,
            (raw) => BarcodeFindListenerOnSearchPaused.fromJson(raw),
            (raw) {
              final map = raw is Map ? raw : const <String, dynamic>{};
              return BarcodeFindListenerOnSearchPaused(
                foundItems: _coerceStringList(map['foundItems']),
                viewId: _coerceInt(map['viewId']),
                event: BarcodeFindConstants.onSearchPausedEvent,
              );
            },
            'onSearchPaused',
          );
          final foundItems = _rehydrateFoundItems(payload.foundItems);
          for (var listener in view._barcodeFind._listeners.toList()) {
            listener.didPauseSearch(foundItems);
          }
          return;
        }

        if (event.isEvent(BarcodeFindConstants.onSearchStoppedEvent)) {
          final payload = _parsePayloadTolerantly<BarcodeFindListenerOnSearchStopped>(
            event.payload,
            (raw) => BarcodeFindListenerOnSearchStopped.fromJson(raw),
            (raw) {
              final map = raw is Map ? raw : const <String, dynamic>{};
              return BarcodeFindListenerOnSearchStopped(
                foundItems: _coerceStringList(map['foundItems']),
                viewId: _coerceInt(map['viewId']),
                event: BarcodeFindConstants.onSearchStoppedEvent,
              );
            },
            'onSearchStopped',
          );
          final foundItems = _rehydrateFoundItems(payload.foundItems);
          for (var listener in view._barcodeFind._listeners.toList()) {
            listener.didStopSearch(foundItems);
          }
          return;
        }
      } catch (error) {
        developer.log('BarcodeFind event dispatch failed: $error');
      }
    });
  }

  void setModeEnabledState(bool newValue) {
    barcodeMethodHandler.setBarcodeFindModeEnabledState(viewId: view._viewId, enabled: newValue).onError(onError);
  }

  Future<void> updateFeedback() {
    return barcodeMethodHandler
        .updateBarcodeFindFeedback(viewId: view._viewId, feedbackJson: jsonEncode(view._barcodeFind.feedback.toMap()))
        .onError(onError);
  }

  void unsubscribeModeListeners() {
    _modeEventsSubscription?.cancel();
    _modeEventsSubscription = null;
    barcodeMethodHandler.unregisterBarcodeFindListener(viewId: view._viewId).onError(onError);
  }

  Future<void> setBarcodeTransformer() {
    return barcodeMethodHandler.setBarcodeTransformer(viewId: view._viewId).onError(onError);
  }

  void subscribeBarcodeTransformerEvents() {
    barcodeMethodHandler.registerBarcodeFindListener(viewId: view._viewId).onError(onError);
    _barcodeTransformerSubscription =
        BarcodePluginEvents.barcodeFindEventStream.forView(view._viewId).listen((event) async {
      if (event.isEvent(BarcodeFindConstants.onTransformBarcodeData)) {
        // ACK-owing: native blocks waiting for submitBarcodeFindTransformerResult, so a
        // schema-parse failure - or any failure downstream of it - must not strand native.
        // The previous code acked unconditionally already (single statement, no try/catch), but
        // that meant a parse throw here would propagate up through the stream listener and skip
        // the ack; do the work in `try`, ack in `finally`, same as barcode_selection.dart.
        String? result;
        try {
          final payload = _parsePayloadTolerantly<BarcodeFindTransformerTransformBarcodeData>(
            event.payload,
            (raw) => BarcodeFindTransformerTransformBarcodeData.fromJson(raw),
            (raw) {
              final map = raw is Map ? raw : const <String, dynamic>{};
              return BarcodeFindTransformerTransformBarcodeData(
                data: map['data'] is String ? map['data'] as String : null,
                viewId: _coerceInt(map['viewId']),
                event: BarcodeFindConstants.onTransformBarcodeData,
              );
            },
            'transformBarcodeData',
          );
          // Seed with the incoming value so a customer transformer that THROWS degrades to
          // "unchanged" rather than "no data": null is a distinct value here (the native
          // transformer returns the original data when disabled), and substituting it would stop
          // the barcode matching any item. A transformer that legitimately returns null still
          // acks null.
          result = payload.data;
          // Only overwrite the seed when a transformer actually ran: with none set (or one being
          // unset mid-search) `?.` yields null, which would ack "no data" instead of unchanged.
          final transformer = view._barcodeFind._barcodeTransformer;
          if (transformer != null) {
            result = transformer.transformBarcodeData(payload.data);
          }
        } catch (error) {
          developer.log('BarcodeFind transformBarcodeData failed: $error');
        } finally {
          await barcodeMethodHandler
              .submitBarcodeFindTransformerResult(viewId: view._viewId, transformedBarcode: result)
              .onError(onError);
        }
      }
    });
  }

  @override
  void dispose() {
    unsubscribeModeListeners();
    unsubscribeFromViewEvents();
    _barcodeTransformerSubscription?.cancel();
    _barcodeTransformerSubscription = null;
    super.dispose();
  }
}

// ignore: experimental_member_use
class _BarcodeFindViewState extends State<BarcodeFindView> implements CameraOwner {
  _BarcodeFindViewState();

  final _viewId = Random().nextInt(0x7FFFFFFF);
  bool _isRouteActive = true;

  late _BarcodeFindViewController _controller;

  @override
  String get id => 'barcode-find-view-$_viewId';

  @override
  void initState() {
    super.initState();
    widget._viewId = _viewId;

    _controller = _BarcodeFindViewController(widget);

    widget._controller = _controller;
    widget._barcodeFind._controller = _controller;
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
        // ignore: experimental_member_use
        CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, this);
      } else {
        // ignore: experimental_member_use
        CameraOwnershipHelper.releaseOwnership(CameraPosition.worldFacing, this);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const viewType = 'com.scandit.BarcodeFindView';

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
            creationParams: {'BarcodeFindView': jsonEncode(widget.toMap())},
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
        creationParams: {'BarcodeFindView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget._isInitialized = true;
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
