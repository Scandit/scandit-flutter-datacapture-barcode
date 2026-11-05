/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

// ignore_for_file: must_be_immutable - packaging injects doc comments above the
// class, which detaches a line-level ignore from the class it applies to.

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show
        SparkScanFeedbackDelegateFeedbackForBarcode,
        SparkScanFeedbackDelegateFeedbackForScannedItem,
        SparkScanListenerDidScan,
        SparkScanListenerDidUpdateSession,
        SparkScanViewUiListenerBarcodeCountButtonTapped,
        SparkScanViewUiListenerBarcodeFindButtonTapped,
        SparkScanViewUiListenerDidChangeScanningMode,
        SparkScanViewUiListenerDidChangeViewState,
        SparkScanViewUiListenerLabelCaptureButtonTapped;
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_feedback_delegate.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_license_info.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view_capture_mode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view_ui_listener.dart';
import 'package:scandit_flutter_datacapture_barcode/src/usi/scanned_item.dart';
import 'package:scandit_flutter_datacapture_core/experimental.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

import '../barcode.dart';
import '../barcode_plugin_events.dart';

import 'spark_scan_view_settings.dart';
import 'spark_scan_defaults.dart';
import 'spark_scan_view_state.dart';

/// Capture mode that implements SparkScan.
///
/// This capture mode uses the *barcode scanning* capability. It cannot be used together with other capture modes that require the same capabilities, e.g. [BarcodeCapture].
///
/// Added in version 6.20.0
class SparkScan extends DataCaptureMode {
  bool _enabled = true;
  bool _isInCallback = false;
  SparkScanSettings _settings;
  final List<SparkScanListener> _listeners = [];

  _SparkScanViewController? _controller;

  SparkScan._(this._settings);

  /// Constructs a new SparkScan mode with the provided settings.
  ///
  /// Added in version 6.20.0
  SparkScan({SparkScanSettings? settings}) : this._(settings ?? SparkScanSettings());

  /// This flag indicates whether the SparkScan mode is currently processing frames to recognise barcodes.
  ///
  /// Changing this property from *false* to *true* causes the connected [SparkScanView] to start its scanning flow.
  ///
  /// Changing this property from *true* to *false* causes the connected [SparkScanView] to stop its scanning flow and go to idle mode.
  ///
  /// Added in version 6.20.0
  @override
  bool get isEnabled => _enabled;

  /// This flag indicates whether the SparkScan mode is currently processing frames to recognise barcodes.
  ///
  /// Changing this property from *false* to *true* causes the connected [SparkScanView] to start its scanning flow.
  ///
  /// Changing this property from *true* to *false* causes the connected [SparkScanView] to stop its scanning flow and go to idle mode.
  ///
  /// Added in version 6.20.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    if (_isInCallback) {
      return;
    }
    _controller?.setModeEnabledState(newValue);
  }

  /// Asynchronously applies the new settings to the barcode scanner. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 6.20.0
  Future<void> applySettings(SparkScanSettings settings) {
    _settings = settings;
    return _didChange();
  }

  /// Adds the listener to this SparkScan instance.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.20.0
  void addListener(SparkScanListener listener) {
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously added listener from this SparkScan instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.20.0
  void removeListener(SparkScanListener listener) {
    _listeners.remove(listener);
  }

  Future<void> _didChange() {
    return _controller?.updateSparkScanMode() ?? Future.value();
  }

  /// Async getter for the SparkScan license info. Returns *null* until the mode has been added to a [DataCaptureContext] with a license that covers SparkScan.
  ///
  /// Added in version 8.6.0
  Future<SparkScanLicenseInfo?> getSparkScanLicenseInfo() {
    return _controller?.getSparkScanLicenseInfo() ?? Future.value(null);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'sparkScan',
      'enabled': _enabled,
      'settings': _settings.toMap(),
      'hasListeners': _listeners.isNotEmpty || _settings.itemDefinitions?.isNotEmpty == true,
    };
  }
}

/// [SparkScan] comes with a ready-to-use UI and scanning modes that are purpose-built to tackle high-volume scanning at close range. The SparkScanView integrates with any app without requiring app redesign or customization. It includes:
///
/// camera preview screenlarge-sized scan buttonquick access toolbar to adjust scanning settings
///
/// Added in version 6.20.0
class SparkScanView extends StatefulWidget implements Serializable {
  final Widget _child;
  final SparkScan _sparkScan;
  SparkScanViewSettings _settings;
  SparkScanViewUiListener? _uiListener;
  SparkScanFeedbackDelegate? _feedbackDelegate;
  SparkScanFeedbackExtendedDelegate? _feedbackExtendedDelegate;

  bool _viewWasCreated = false;
  // set from the state
  _SparkScanViewController? _controller;

  SparkScanView._(
    this._child,
    this._sparkScan,
    SparkScanViewSettings settings, {
    bool? torchControlVisible,
    bool? previewCloseControlVisible,
    bool? scanningBehaviorButtonVisible,
    bool? barcodeCountButtonVisible,
    bool? barcodeFindButtonVisible,
    bool? targetModeButtonVisible,
    bool? selectionModeButtonVisible,
    bool? labelCaptureButtonVisible,
    bool? zoomSwitchControlVisible,
    bool? cameraSwitchButtonVisible,
    bool? previewSizeControlVisible,
    bool? triggerButtonVisible,
    Color? toolbarBackgroundColor,
    Color? toolbarIconActiveTintColor,
    Color? toolbarIconInactiveTintColor,
    Color? triggerButtonCollapsedColor,
    Color? triggerButtonExpandedColor,
    Color? triggerButtonAnimationColor,
    Color? triggerButtonTintColor,
    SparkScanViewUiListener? uiListener,
    SparkScanFeedbackDelegate? feedbackDelegate,
    SparkScanFeedbackExtendedDelegate? feedbackExtendedDelegate,
  })  : _settings = settings,
        super() {
    if (torchControlVisible != null) _torchControlVisible = torchControlVisible;
    if (previewCloseControlVisible != null) _previewCloseControlVisible = previewCloseControlVisible;
    if (scanningBehaviorButtonVisible != null) _scanningBehaviorButtonVisible = scanningBehaviorButtonVisible;
    if (barcodeCountButtonVisible != null) _barcodeCountButtonVisible = barcodeCountButtonVisible;
    if (barcodeFindButtonVisible != null) _barcodeFindButtonVisible = barcodeFindButtonVisible;
    if (targetModeButtonVisible != null) _targetModeButtonVisible = targetModeButtonVisible;
    // selectionModeButtonVisible shares the same underlying state and wins when both are set,
    // matching the native deserializer behaviour.
    if (selectionModeButtonVisible != null) _targetModeButtonVisible = selectionModeButtonVisible;
    if (labelCaptureButtonVisible != null) _labelCaptureButtonVisible = labelCaptureButtonVisible;
    if (zoomSwitchControlVisible != null) _zoomSwitchControlVisible = zoomSwitchControlVisible;
    if (cameraSwitchButtonVisible != null) _cameraSwitchButtonVisible = cameraSwitchButtonVisible;
    if (previewSizeControlVisible != null) _previewSizeControlVisible = previewSizeControlVisible;
    if (triggerButtonVisible != null) _triggerButtonVisible = triggerButtonVisible;
    if (toolbarBackgroundColor != null) _toolbarBackgroundColor = toolbarBackgroundColor;
    if (toolbarIconActiveTintColor != null) _toolbarIconActiveTintColor = toolbarIconActiveTintColor;
    if (toolbarIconInactiveTintColor != null) _toolbarIconInactiveTintColor = toolbarIconInactiveTintColor;
    if (triggerButtonCollapsedColor != null) _triggerButtonCollapsedColor = triggerButtonCollapsedColor;
    if (triggerButtonExpandedColor != null) _triggerButtonExpandedColor = triggerButtonExpandedColor;
    if (triggerButtonAnimationColor != null) _triggerButtonAnimationColor = triggerButtonAnimationColor;
    if (triggerButtonTintColor != null) _triggerButtonTintColor = triggerButtonTintColor;
    _uiListener = uiListener;
    _feedbackDelegate = feedbackDelegate;
    _feedbackExtendedDelegate = feedbackExtendedDelegate;
  }

  /// Constructs a new SparkScan view using a declarative style. All view configuration — button visibility, toolbar colors, and delegates — can be supplied directly as named constructor parameters. Any parameter left as `null` uses the SDK default for that property.
  ///
  /// Prefer this constructor when building reactive UIs where the view configuration is derived from state: pass updated values on each rebuild and the view will reconcile them automatically.
  ///
  /// ```dart
  /// SparkScanView(
  ///   yourWidgetBody,
  ///   dataCaptureContext,
  ///   sparkScan,
  ///   viewSettings,
  ///   torchControlVisible: true,
  ///   barcodeCountButtonVisible: false,
  ///   toolbarBackgroundColor: Colors.black,
  ///   feedbackExtendedDelegate: myFeedbackDelegate,
  ///   uiListener: myUiListener,
  /// );
  /// ```
  ///
  /// Added in version 8.4.0
  SparkScanView(
    Widget child,
    DataCaptureContext dataCaptureContext,
    SparkScan sparkScan,
    SparkScanViewSettings? viewSettings, {
    bool? torchControlVisible,
    bool? previewCloseControlVisible,
    bool? scanningBehaviorButtonVisible,
    bool? barcodeCountButtonVisible,
    bool? barcodeFindButtonVisible,
    bool? targetModeButtonVisible,
    bool? selectionModeButtonVisible,
    bool? labelCaptureButtonVisible,
    bool? zoomSwitchControlVisible,
    bool? cameraSwitchButtonVisible,
    bool? previewSizeControlVisible,
    bool? triggerButtonVisible,
    Color? toolbarBackgroundColor,
    Color? toolbarIconActiveTintColor,
    Color? toolbarIconInactiveTintColor,
    Color? triggerButtonCollapsedColor,
    Color? triggerButtonExpandedColor,
    Color? triggerButtonAnimationColor,
    Color? triggerButtonTintColor,
    SparkScanViewUiListener? uiListener,
    SparkScanFeedbackDelegate? feedbackDelegate,
    SparkScanFeedbackExtendedDelegate? feedbackExtendedDelegate,
  }) : this._(
          child,
          sparkScan,
          viewSettings ?? SparkScanViewSettings(),
          torchControlVisible: torchControlVisible,
          previewCloseControlVisible: previewCloseControlVisible,
          scanningBehaviorButtonVisible: scanningBehaviorButtonVisible,
          barcodeCountButtonVisible: barcodeCountButtonVisible,
          barcodeFindButtonVisible: barcodeFindButtonVisible,
          targetModeButtonVisible: targetModeButtonVisible,
          selectionModeButtonVisible: selectionModeButtonVisible,
          labelCaptureButtonVisible: labelCaptureButtonVisible,
          zoomSwitchControlVisible: zoomSwitchControlVisible,
          cameraSwitchButtonVisible: cameraSwitchButtonVisible,
          previewSizeControlVisible: previewSizeControlVisible,
          triggerButtonVisible: triggerButtonVisible,
          toolbarBackgroundColor: toolbarBackgroundColor,
          toolbarIconActiveTintColor: toolbarIconActiveTintColor,
          toolbarIconInactiveTintColor: toolbarIconInactiveTintColor,
          triggerButtonCollapsedColor: triggerButtonCollapsedColor,
          triggerButtonExpandedColor: triggerButtonExpandedColor,
          triggerButtonAnimationColor: triggerButtonAnimationColor,
          triggerButtonTintColor: triggerButtonTintColor,
          uiListener: uiListener,
          feedbackDelegate: feedbackDelegate,
          feedbackExtendedDelegate: feedbackExtendedDelegate,
        );

  SparkScanView.forContext(
    Widget child,
    DataCaptureContext dataCaptureContext,
    SparkScan sparkScan,
    SparkScanViewSettings? settings,
  )
  // we require the DCContext only to make sure the user created/initialized it
  : this._(child, sparkScan, settings ?? SparkScanViewSettings());

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 6.20.0
  @override
  State<StatefulWidget> createState() {
    return _SparkScanViewState();
  }

  /// Returns the default brush used by the overlay.
  ///
  /// Added in version 6.20.0
  static Brush get defaultBrush {
    return SparkScanDefaults.sparkScanViewDefaults.defaultBrush;
  }

  /// Returns whether the device supports listening for hardware button events. This is true for devices with api >= 28.
  ///
  /// This method is only supported on Android devices.
  ///
  /// Added in version 6.20.0
  static bool get hardwareTriggerSupported {
    return SparkScanDefaults.sparkScanViewDefaults.hardwareTriggerSupported;
  }

  bool _torchControlVisible = SparkScanDefaults.sparkScanViewDefaults.torchControlVisible;

  /// Indicates whether the torch control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// If [SparkScanViewSettings.defaultTorchState] is set to [TorchState.auto], torch control is hidden.
  ///
  /// Added in version 7.0.0
  bool get torchControlVisible {
    return _torchControlVisible;
  }

  /// Indicates whether the torch control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// If [SparkScanViewSettings.defaultTorchState] is set to [TorchState.auto], torch control is hidden.
  ///
  /// Added in version 7.0.0
  set torchControlVisible(bool newValue) {
    _torchControlVisible = newValue;
    _update();
  }

  bool _previewCloseControlVisible = SparkScanDefaults.sparkScanViewDefaults.previewCloseControlVisible;

  /// Indicates whether the mini preview close control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 7.0.0
  bool get previewCloseControlVisible {
    return _previewCloseControlVisible;
  }

  /// Indicates whether the mini preview close control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 7.0.0
  set previewCloseControlVisible(bool newValue) {
    _previewCloseControlVisible = newValue;
    _update();
  }

  bool _scanningBehaviorButtonVisible = SparkScanDefaults.sparkScanViewDefaults.scanningBehaviorButtonVisible;

  /// Indicates whether the scanning behavior button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.20.0
  bool get scanningBehaviorButtonVisible {
    return _scanningBehaviorButtonVisible;
  }

  /// Indicates whether the scanning behavior button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.20.0
  set scanningBehaviorButtonVisible(bool newValue) {
    _scanningBehaviorButtonVisible = newValue;
    _update();
  }

  Color? _toolbarBackgroundColor = SparkScanDefaults.sparkScanViewDefaults.toolbarBackgroundColor;

  /// Sets the toolbar background color.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  Color? get toolbarBackgroundColor {
    return _toolbarBackgroundColor;
  }

  /// Sets the toolbar background color.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  set toolbarBackgroundColor(Color? newValue) {
    _toolbarBackgroundColor = newValue;
    _update();
  }

  Color? _toolbarIconActiveTintColor = SparkScanDefaults.sparkScanViewDefaults.toolbarIconActiveTintColor;

  /// Sets the toolbar icon active color.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  Color? get toolbarIconActiveTintColor {
    return _toolbarIconActiveTintColor;
  }

  /// Sets the toolbar icon active color.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  set toolbarIconActiveTintColor(Color? newValue) {
    _toolbarIconActiveTintColor = newValue;
    _update();
  }

  Color? _toolbarIconInactiveTintColor = SparkScanDefaults.sparkScanViewDefaults.toolbarIconInactiveTintColor;

  /// Sets the toolbar icon inactive color.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  Color? get toolbarIconInactiveTintColor {
    return _toolbarIconInactiveTintColor;
  }

  /// Sets the toolbar icon inactive color.
  ///
  /// Default is *null*.
  ///
  /// Added in version 6.20.0
  set toolbarIconInactiveTintColor(Color? newValue) {
    _toolbarIconInactiveTintColor = newValue;
    _update();
  }

  bool _barcodeCountButtonVisible = SparkScanDefaults.sparkScanViewDefaults.barcodeCountButtonVisible;

  /// Indicates whether the barcode count button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.20.0
  bool get barcodeCountButtonVisible {
    return _barcodeCountButtonVisible;
  }

  /// Indicates whether the barcode count button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.20.0
  set barcodeCountButtonVisible(bool newValue) {
    _barcodeCountButtonVisible = newValue;
    _update();
  }

  bool _barcodeFindButtonVisible = SparkScanDefaults.sparkScanViewDefaults.barcodeFindButtonVisible;

  /// Indicates whether the barcode find button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.26.0
  bool get barcodeFindButtonVisible {
    return _barcodeFindButtonVisible;
  }

  /// Indicates whether the barcode find button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.26.0
  set barcodeFindButtonVisible(bool newValue) {
    _barcodeFindButtonVisible = newValue;
    _update();
  }

  // targetModeButtonVisible and selectionModeButtonVisible are the same underlying
  // native state; both accessors share one backing field.
  bool _targetModeButtonVisible = SparkScanDefaults.sparkScanViewDefaults.selectionModeButtonVisible;

  /// Indicates whether the target mode button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.20.0
  @Deprecated('Use selectionModeButtonVisible instead. Will be removed in 9.0.')
  bool get targetModeButtonVisible {
    return _targetModeButtonVisible;
  }

  /// Indicates whether the target mode button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.20.0
  @Deprecated('Use selectionModeButtonVisible instead. Will be removed in 9.0.')
  set targetModeButtonVisible(bool newValue) {
    _targetModeButtonVisible = newValue;
    _update();
  }

  /// Indicates whether the selection mode button should be shown to the user. The button toggles [SparkScanSettings.selectionMode] between [SelectionMode.on] and [SelectionMode.off].
  ///
  /// Renamed replacement for the deprecated [SparkScanView.targetModeButtonVisible]. Both properties share the same underlying state; when a deserialised JSON snapshot contains both keys, `selectionModeButtonVisible` wins.
  ///
  /// Default is *false*.
  ///
  /// Added in version 8.5.0
  bool get selectionModeButtonVisible {
    return _targetModeButtonVisible;
  }

  /// Indicates whether the selection mode button should be shown to the user. The button toggles [SparkScanSettings.selectionMode] between [SelectionMode.on] and [SelectionMode.off].
  ///
  /// Renamed replacement for the deprecated [SparkScanView.targetModeButtonVisible]. Both properties share the same underlying state; when a deserialised JSON snapshot contains both keys, `selectionModeButtonVisible` wins.
  ///
  /// Default is *false*.
  ///
  /// Added in version 8.5.0
  set selectionModeButtonVisible(bool newValue) {
    _targetModeButtonVisible = newValue;
    _update();
  }

  bool _labelCaptureButtonVisible = SparkScanDefaults.sparkScanViewDefaults.labelCaptureButtonVisible;

  /// Indicates whether the label capture button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 7.4.0
  bool get labelCaptureButtonVisible {
    return _labelCaptureButtonVisible;
  }

  /// Indicates whether the label capture button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 7.4.0
  set labelCaptureButtonVisible(bool newValue) {
    _labelCaptureButtonVisible = newValue;
    _update();
  }

  bool _zoomSwitchControlVisible = SparkScanDefaults.sparkScanViewDefaults.zoomSwitchControlVisible;

  /// Indicates whether the zoom switch control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.20.0
  bool get zoomSwitchControlVisible {
    return _zoomSwitchControlVisible;
  }

  /// Indicates whether the zoom switch control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.20.0
  set zoomSwitchControlVisible(bool newValue) {
    _zoomSwitchControlVisible = newValue;
    _update();
  }

  /// Sets the listener which is called whenever a barcode find button or barcode count button is tapped from the toolbar.
  ///
  /// Added in version 6.20.0
  void setListener(SparkScanViewUiListener? listener) {
    if (listener != null) {
      _controller?.subscribeUiListeners();
    } else {
      _controller?.unsubscribeUiListeners();
    }
    _uiListener = listener;
    _update();
  }

  /// Sets the feedback delegate. If no delegate is set, the default SparkScanBarcodeFeedback.Success ([Success]) feedback is emitted.
  ///
  /// Added in version 6.23.0
  SparkScanFeedbackDelegate? get feedbackDelegate => _feedbackDelegate;

  /// Sets the feedback delegate. If no delegate is set, the default SparkScanBarcodeFeedback.Success ([Success]) feedback is emitted.
  ///
  /// Added in version 6.23.0
  set feedbackDelegate(SparkScanFeedbackDelegate? newValue) {
    _feedbackDelegate = newValue;
    if (newValue != null) {
      _controller?.subscribeToFeedbackDelegateEvents();
    } else {
      _controller?.unsubscribeFromFeedbackDelegateEvents();
    }
    _controller?.setFeedbackDelegate(newValue != null);
  }

  /// Sets the feedback extended delegate. This is an extension of [SparkScanFeedbackDelegate] that adds support for SparkScanFeedbackExtendedDelegate.feedbackForScannedItem(). This interface was introduced to avoid breaking changes for existing implementations. Users should use either [SparkScanView.feedbackDelegate] or [SparkScanView.feedbackExtendedDelegate], but not both. If no delegate is set, the default SparkScanBarcodeFeedback.Success ([Success]) feedback is emitted. This property will be removed in a future release.
  ///
  /// Added in version 8.2.0
  SparkScanFeedbackExtendedDelegate? get feedbackExtendedDelegate => _feedbackExtendedDelegate;

  /// Sets the feedback extended delegate. This is an extension of [SparkScanFeedbackDelegate] that adds support for SparkScanFeedbackExtendedDelegate.feedbackForScannedItem(). This interface was introduced to avoid breaking changes for existing implementations. Users should use either [SparkScanView.feedbackDelegate] or [SparkScanView.feedbackExtendedDelegate], but not both. If no delegate is set, the default SparkScanBarcodeFeedback.Success ([Success]) feedback is emitted. This property will be removed in a future release.
  ///
  /// Added in version 8.2.0
  set feedbackExtendedDelegate(SparkScanFeedbackExtendedDelegate? newValue) {
    _feedbackExtendedDelegate = newValue;
    if (newValue != null) {
      _controller?.subscribeToFeedbackDelegateEvents();
    } else {
      _controller?.unsubscribeFromFeedbackDelegateEvents();
    }
    _controller?.setFeedbackDelegate(newValue != null);
  }

  bool _previewSizeControlVisible = SparkScanDefaults.sparkScanViewDefaults.previewSizeControlVisible;

  /// Indicates whether the mini preview size control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.23.0
  bool get previewSizeControlVisible => _previewSizeControlVisible;

  /// Indicates whether the mini preview size control should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 6.23.0
  set previewSizeControlVisible(bool newValue) {
    _previewSizeControlVisible = newValue;
    _update();
  }

  bool _cameraSwitchButtonVisible = SparkScanDefaults.sparkScanViewDefaults.cameraSwitchButtonVisible;

  /// Indicates whether the camera switch button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// This API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 6.24.0
  bool get cameraSwitchButtonVisible {
    return _cameraSwitchButtonVisible;
  }

  /// Indicates whether the camera switch button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// This API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 6.24.0
  set cameraSwitchButtonVisible(bool newValue) {
    _cameraSwitchButtonVisible = newValue;
    _update();
  }

  Color? _triggerButtonCollapsedColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonCollapsedColor;

  /// Sets the background color of the trigger button when button is collapsed.
  ///
  /// Added in version 7.0.0
  Color? get triggerButtonCollapsedColor {
    return _triggerButtonCollapsedColor;
  }

  /// Sets the background color of the trigger button when button is collapsed.
  ///
  /// Added in version 7.0.0
  set triggerButtonCollapsedColor(Color? newValue) {
    _triggerButtonCollapsedColor = newValue;
    _update();
  }

  Color? _triggerButtonExpandedColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonExpandedColor;

  /// Sets the background color of the trigger button when button is expanded.
  ///
  /// Added in version 7.0.0
  Color? get triggerButtonExpandedColor {
    return _triggerButtonExpandedColor;
  }

  /// Sets the background color of the trigger button when button is expanded.
  ///
  /// Added in version 7.0.0
  set triggerButtonExpandedColor(Color? newValue) {
    _triggerButtonExpandedColor = newValue;
    _update();
  }

  Color? _triggerButtonAnimationColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonAnimationColor;

  /// Sets the color of the pulsing animation around the trigger button, which is shown when the scanner is active.
  ///
  /// Added in version 7.0.0
  Color? get triggerButtonAnimationColor {
    return _triggerButtonAnimationColor;
  }

  /// Sets the color of the pulsing animation around the trigger button, which is shown when the scanner is active.
  ///
  /// Added in version 7.0.0
  set triggerButtonAnimationColor(Color? newValue) {
    _triggerButtonAnimationColor = newValue;
    _update();
  }

  Color? _triggerButtonTintColor = SparkScanDefaults.sparkScanViewDefaults.triggerButtonTintColor;

  /// Sets the trigger button tint color.
  ///
  /// Added in version 7.0.0
  Color? get triggerButtonTintColor {
    return _triggerButtonTintColor;
  }

  /// Sets the trigger button tint color.
  ///
  /// Added in version 7.0.0
  set triggerButtonTintColor(Color? newValue) {
    _triggerButtonTintColor = newValue;
    _update();
  }

  bool _triggerButtonVisible = SparkScanDefaults.sparkScanViewDefaults.triggerButtonVisible;

  /// Indicates whether the trigger button should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 7.0.0
  bool get triggerButtonVisible {
    return _triggerButtonVisible;
  }

  /// Indicates whether the trigger button should be shown to the user.
  ///
  /// Default is *true*.
  ///
  /// Added in version 7.0.0
  set triggerButtonVisible(bool newValue) {
    _triggerButtonVisible = newValue;
    _update();
  }

  /// Starts the scanning process. You can call this method if you want to trigger the scanning process without any user interaction.
  ///
  /// Added in version 6.20.0
  Future<void> startScanning() async {
    return _controller?.startScanning() ?? Future.value(null);
  }

  /// Pauses the scanning process. You can call this method if you want to trigger pausing the scanning process without any user interaction.
  ///
  /// Added in version 6.20.0
  Future<void> pauseScanning() async {
    await _controller?.pauseScanning();
  }

  /// Added in version 7.6.2
  Future<void> stopScanning() async {
    await _controller?.stopScanning();
  }

  /// Shows a toast with text inside the mini preview.
  ///
  /// Added in version 6.20.0
  Future<void> showToast(String text) async {
    await _controller?.showToast(text);
  }

  /// Returns the currently used SparkScanScanningMode.
  ///
  /// Added in version 8.7.0
  Future<SparkScanScanningMode> getScanningMode() async {
    return await _controller?.getScanningMode() ?? _settings.defaultScanningMode;
  }

  Future<void> _update() async {
    await _controller?.updateView();
  }

  Future<void> _bringViewToFront() async {
    await _controller?._bringViewToFront();
  }

  String? _triggerButtonImage = SparkScanDefaults.sparkScanViewDefaults.triggerButtonImage;

  /// The image displayed in the trigger button.
  ///
  /// Added in version 7.0.0
  Image? get triggerButtonImage {
    var base64EncodedImage = _triggerButtonImage;
    if (base64EncodedImage == null) return null;
    // Remove whitespaces to avoid errors when decoding
    final normalized = base64EncodedImage.replaceAll(RegExp(r'\s+'), '');
    return Image.memory(base64Decode(normalized));
  }

  /// The image displayed in the trigger button.
  ///
  /// Added in version 7.0.0
  set triggerButtonImage(Image? newValue) {
    if (newValue == null) {
      _triggerButtonImage = null;
      _controller?.updateView();
      return;
    }

    newValue.base64String.then((base64EncodedImage) {
      _triggerButtonImage = base64EncodedImage;
      return _controller?.updateView() ?? Future.value(null);
    });
  }

  /// Sets the image to use for the trigger button.
  ///
  /// Added in version 7.0.0
  Future<void> setTriggerButtonImage(Uint8List image) {
    _triggerButtonImage = base64Encode(image);
    return _controller?.updateView() ?? Future.value(null);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'SparkScanView': {
        'viewSettings': _settings.toMap(),
        'torchControlVisible': torchControlVisible,
        'scanningBehaviorButtonVisible': scanningBehaviorButtonVisible,
        'toolbarBackgroundColor': toolbarBackgroundColor?.jsonValue,
        'barcodeCountButtonVisible': barcodeCountButtonVisible,
        'barcodeFindButtonVisible': barcodeFindButtonVisible,
        'labelCaptureButtonVisible': labelCaptureButtonVisible,
        // ignore: deprecated_member_use_from_same_package
        'targetModeButtonVisible': targetModeButtonVisible,
        'selectionModeButtonVisible': selectionModeButtonVisible,
        'toolbarIconActiveTintColor': toolbarIconActiveTintColor?.jsonValue,
        'toolbarIconInactiveTintColor': toolbarIconInactiveTintColor?.jsonValue,
        'zoomSwitchControlVisible': zoomSwitchControlVisible,
        'previewSizeControlVisible': previewSizeControlVisible,
        'cameraSwitchButtonVisible': cameraSwitchButtonVisible,
        'triggerButtonImage': _triggerButtonImage,
        'triggerButtonVisible': triggerButtonVisible,
        'previewCloseControlVisible': previewCloseControlVisible,
        'triggerButtonCollapsedColor': triggerButtonCollapsedColor?.jsonValue,
        'triggerButtonExpandedColor': triggerButtonExpandedColor?.jsonValue,
        'triggerButtonAnimationColor': triggerButtonAnimationColor?.jsonValue,
        'triggerButtonTintColor': triggerButtonTintColor?.jsonValue,
        'hasFeedbackDelegate': _feedbackDelegate != null || _feedbackExtendedDelegate != null,
        'hasUiListener': _uiListener != null,
        'viewId': _controller?._viewId ?? 0,
      },
      'SparkScan': _sparkScan.toMap(),
    };
  }
}

// ignore: experimental_member_use
class _SparkScanViewState extends State<SparkScanView> implements CameraOwner {
  late Widget platformView;
  final int _viewId = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();
  late _SparkScanViewController _controller;
  bool _isRouteActive = true;

  @override
  String get id => 'spark-scan-view-$_viewId';

  _SparkScanViewState();

  @override
  void initState() {
    super.initState();
    // initialize controller in initState to avoid multiple instances of the
    // controller in the same view
    _controller = _SparkScanViewController._(widget, _viewId);
    // initialize controller in View and Mode
    widget._controller = _controller;
    widget._sparkScan._controller = _controller;
    _initializePlatformView();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkRouteStatus();
  }

  void _checkRouteStatus() {
    // Detect route changes and manage native view visibility accordingly.
    // When the user navigates to another screen, this route becomes non-current
    // and we hide the native SparkScanView. When navigating back, the route
    // becomes current again and we show the native view to sync visibility
    // between the Dart widget and the underlying native platform view.
    final route = ModalRoute.of(context);
    final wasActive = _isRouteActive;
    _isRouteActive = route?.isCurrent == true;

    if (wasActive != _isRouteActive) {
      if (_isRouteActive) {
        _controller.showView();
        // ignore: experimental_member_use
        CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, this);
      } else {
        // ignore: experimental_member_use
        CameraOwnershipHelper.releaseOwnership(CameraPosition.worldFacing, this);
        _controller.hideView();
      }
    }
  }

  void _initializePlatformView() {
    const viewType = 'com.scandit.SparkScanView';

    if (Platform.isAndroid) {
      platformView = PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.translucent,
          );
        },
        onCreatePlatformView: (params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: {'SparkScanView': jsonEncode(widget.toMap())},
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () {
              params.onFocusChanged(true);
            },
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener((id) {
              widget._viewWasCreated = true;
            })
            ..create();
        },
      );
    } else {
      platformView = UiKitView(
        viewType: viewType,
        hitTestBehavior: PlatformViewHitTestBehavior.translucent,
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        creationParams: {'SparkScanView': jsonEncode(widget.toMap())},
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: TextDirection.ltr,
        onPlatformViewCreated: (id) {
          widget._viewWasCreated = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget._bringViewToFront();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkRouteStatus();
    });
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(top: 0, left: 0, right: 0, bottom: 0, child: platformView),
        Positioned.fill(child: widget._child),
      ],
    );
  }

  @override
  void didUpdateWidget(SparkScanView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller's view reference FIRST — all subsequent controller
    // calls (updateView, stream callbacks) must operate on the new widget.
    _controller.view = widget;
    // Wire controller and viewWasCreated flag to the new widget instance.
    widget._controller = _controller;
    widget._viewWasCreated = oldWidget._viewWasCreated;
    if (oldWidget._sparkScan != widget._sparkScan) {
      oldWidget._sparkScan._controller = null;
      widget._sparkScan._controller = _controller;
    }

    // Handle feedback delegate subscription changes.
    final hadDelegate = oldWidget._feedbackDelegate != null || oldWidget._feedbackExtendedDelegate != null;
    final hasDelegate = widget._feedbackDelegate != null || widget._feedbackExtendedDelegate != null;
    if (hadDelegate != hasDelegate) {
      _controller.setFeedbackDelegate(hasDelegate);
      if (hasDelegate) {
        _controller.subscribeToFeedbackDelegateEvents();
      } else {
        _controller.unsubscribeFromFeedbackDelegateEvents();
      }
    }

    // Handle UI listener subscription changes.
    if (oldWidget._uiListener != widget._uiListener) {
      if (widget._uiListener != null) {
        _controller.subscribeUiListeners();
      } else {
        _controller.unsubscribeUiListeners();
      }
    }

    // Sync all view properties to native.
    widget._update();
    widget._bringViewToFront();
  }

  @override
  void dispose() {
    // cleanup controller
    _controller.dispose();
    widget._controller = null;
    widget._sparkScan._controller = null;
    super.dispose();
  }
}

class _SparkScanViewController extends BaseController {
  StreamSubscription<dynamic>? _sparkScanViewSubscription;
  StreamSubscription<dynamic>? _sparkScanDelegateFeedbackSubscription;
  StreamSubscription<dynamic>? _sparkScanListenerSubscription;
  SparkScanView view;
  final int _viewId;
  late final BarcodeMethodHandler barcodeMethodHandler;

  _SparkScanViewController._(this.view, this._viewId) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    _initialize();
  }

  void _initialize() {
    subscribeSparkScanListener();

    if (view._feedbackDelegate != null || view._feedbackExtendedDelegate != null) {
      subscribeToFeedbackDelegateEvents();
    }

    if (view._uiListener != null) {
      subscribeUiListeners();
    }
  }

  void subscribeUiListeners() {
    if (_sparkScanViewSubscription != null) return;
    _sparkScanViewSubscription = BarcodePluginEvents.sparkScanEventStream.forView(_viewId).listen((event) {
      if (event.isEvent('SparkScanViewUiListener.barcodeCountButtonTapped')) {
        SparkScanViewUiListenerBarcodeCountButtonTapped.fromJson(event.payload);
        view._uiListener?.didTapBarcodeCountButton(view);
      } else if (event.isEvent('SparkScanViewUiListener.barcodeFindButtonTapped')) {
        SparkScanViewUiListenerBarcodeFindButtonTapped.fromJson(event.payload);
        view._uiListener?.didTapBarcodeFindButton(view);
      } else if (event.isEvent('SparkScanViewUiListener.didChangeViewState')) {
        final payload = SparkScanViewUiListenerDidChangeViewState.fromJson(event.payload);
        final newState = SparkScanViewStateSerializer.fromJSON(payload.state);
        view._uiListener?.didChangeViewState(newState);
      } else if (event.isEvent('SparkScanViewUiListener.labelCaptureButtonTapped')) {
        SparkScanViewUiListenerLabelCaptureButtonTapped.fromJson(event.payload);
        view._uiListener?.didTapLabelCaptureButton(view);
      } else if (event.isEvent('SparkScanViewUiListener.didChangeScanningMode')) {
        final payload = SparkScanViewUiListenerDidChangeScanningMode.fromJson(event.payload);
        final scanningModeJson = jsonDecode(payload.scanningMode) as Map<String, dynamic>;
        final newScanningMode = SparkScanScanningModeSerializer.fromJSON(scanningModeJson);
        if (view._uiListener is SparkScanViewUiExtendedListener) {
          (view._uiListener as SparkScanViewUiExtendedListener).didChangeScanningMode(newScanningMode);
        }
      }
    });
  }

  void unsubscribeUiListeners() {
    _sparkScanViewSubscription?.cancel();
    _sparkScanViewSubscription = null;
  }

  Future<void> startScanning() {
    return barcodeMethodHandler.startSparkScanViewScanning(viewId: _viewId).onError(onError);
  }

  Future<void> updateView() {
    if (!view._viewWasCreated) return Future.value();

    return barcodeMethodHandler
        .updateSparkScanView(viewId: _viewId, viewJson: jsonEncode(view.toMap()))
        .onError(onError);
  }

  Future<void> pauseScanning() {
    return barcodeMethodHandler.pauseSparkScanViewScanning(viewId: _viewId).onError(onError);
  }

  Future<void> stopScanning() {
    return barcodeMethodHandler.stopSparkScanViewScanning(viewId: _viewId).onError(onError);
  }

  Future<void> showToast(String text) {
    return barcodeMethodHandler.showSparkScanViewToast(viewId: _viewId, text: text).onError(onError);
  }

  void subscribeToFeedbackDelegateEvents() {
    if (_sparkScanDelegateFeedbackSubscription != null) return;
    _sparkScanDelegateFeedbackSubscription =
        BarcodePluginEvents.sparkScanEventStream.forView(_viewId).listen((event) async {
      if (event.isEvent('SparkScanFeedbackDelegate.feedbackForBarcode')) {
        // Blocks a native thread awaiting a reply: parse tolerantly, and submit in a `finally`
        // so the ack always fires.
        String? feedbackJson;
        try {
          final payload = _parsePayloadTolerantly<SparkScanFeedbackDelegateFeedbackForBarcode?>(
            event.payload,
            (raw) => SparkScanFeedbackDelegateFeedbackForBarcode.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              return map.containsKey('barcode')
                  ? SparkScanFeedbackDelegateFeedbackForBarcode(barcode: map['barcode'] as String, viewId: _viewId)
                  : null;
            },
            'feedbackForBarcode',
          );
          if (payload != null) {
            var barcode = Barcode.fromJSON(jsonDecode(payload.barcode));
            var feedback = view._feedbackDelegate?.feedbackForBarcode(barcode) ??
                view._feedbackExtendedDelegate?.feedbackForBarcode(barcode);
            if (feedback != null) {
              feedbackJson = jsonEncode(feedback.toMap());
            }
          }
        } catch (error) {
          log('SparkScanView feedbackForBarcode failed: $error');
        } finally {
          barcodeMethodHandler
              .submitSparkScanFeedbackForBarcode(viewId: _viewId, feedbackJson: feedbackJson)
              .onError(onError);
        }
      }
      if (event.isEvent('SparkScanFeedbackDelegate.feedbackForScannedItem')) {
        // Blocks a native thread awaiting a reply: parse tolerantly, and submit in a `finally`
        // so the ack always fires.
        String? feedbackJson;
        try {
          final payload = _parsePayloadTolerantly<SparkScanFeedbackDelegateFeedbackForScannedItem?>(
            event.payload,
            (raw) => SparkScanFeedbackDelegateFeedbackForScannedItem.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              return map.containsKey('scannedItem')
                  ? SparkScanFeedbackDelegateFeedbackForScannedItem(
                      scannedItem: map['scannedItem'] as String, viewId: _viewId)
                  : null;
            },
            'feedbackForScannedItem',
          );
          if (payload != null) {
            var scannedItem = ScannedItem.fromJSON(jsonDecode(payload.scannedItem));
            var feedback = view._feedbackExtendedDelegate?.feedbackForScannedItem(scannedItem);
            if (feedback != null) {
              feedbackJson = jsonEncode(feedback.toMap());
            }
          }
        } catch (error) {
          log('SparkScanView feedbackForScannedItem failed: $error');
        } finally {
          barcodeMethodHandler
              .submitSparkScanFeedbackForScannedItem(viewId: _viewId, feedbackJson: feedbackJson)
              .onError(onError);
        }
      }
    });
  }

  // Tolerant parsing is limited to the four events that block a native thread awaiting a reply
  // (feedbackForBarcode, feedbackForScannedItem, didUpdateSession, didScan): a payload that
  // fails schema validation is logged and passed through unvalidated (the caller re-derives
  // what it needs straight from the raw map) rather than thrown, so the ack still fires
  // promptly instead of surfacing only after the native-side timeout.
  T _parsePayloadTolerantly<T>(
    Map<String, dynamic> raw,
    T Function(Object?) parse,
    T Function(Object?) fallback,
    String event,
  ) {
    try {
      return parse(raw);
    } catch (error) {
      log('SparkScanView $event payload failed schema validation: $error');
      return fallback(raw);
    }
  }

  void unsubscribeFromFeedbackDelegateEvents() {
    _sparkScanDelegateFeedbackSubscription?.cancel();
    _sparkScanDelegateFeedbackSubscription = null;
  }

  Future<void> _bringViewToFront() {
    if (Platform.isIOS) {
      return barcodeMethodHandler.bringSparkScanViewToFront(viewId: _viewId).onError(onError);
    }
    return Future.value();
  }

  void setModeEnabledState(bool newValue) {
    barcodeMethodHandler.setSparkScanModeEnabledState(viewId: _viewId, isEnabled: newValue).onError(onError);
  }

  void subscribeSparkScanListener() {
    _setupModeListenerSubscription();
    barcodeMethodHandler.registerSparkScanListenerForEvents(viewId: _viewId).onError(onError);
  }

  void _setupModeListenerSubscription() {
    if (_sparkScanListenerSubscription != null) return;
    _sparkScanListenerSubscription = BarcodePluginEvents.sparkScanEventStream.forView(_viewId).listen((event) async {
      if (event.isEvent('SparkScanListener.didScan')) {
        // Blocks a native thread for 2000 ms on failure to reply: parse tolerantly, and finish
        // in a `finally` so the ack always fires.
        try {
          final parsed = _parsePayloadTolerantly<SparkScanListenerDidScan>(
            event.payload,
            (raw) => SparkScanListenerDidScan.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              return SparkScanListenerDidScan(
                session: map['session'] as String,
                frameId: map['frameId'] as String?,
                viewId: _viewId,
              );
            },
            'didScan',
          );
          var session = SparkScanSession.fromJSON({'session': parsed.session, 'frameId': parsed.frameId}, _viewId);
          await _notifyListenersOfDidScan(session);

          if (session.newlyRecognizedItems.isNotEmpty) {
            for (final definition in view._sparkScan._settings.itemDefinitions ?? []) {
              final onScan = definition.onScan;
              if (onScan == null) {
                continue;
              }

              final recognizedItems = session.newlyRecognizedItems
                  .where((item) => item.definitionIdentifier != null)
                  .map((item) => MapEntry(item, item.definitionIdentifier!.toMap()['identifier']))
                  .where((entry) => entry.value == definition.identifier.toMap()['identifier'])
                  .map((entry) => entry.key)
                  .toList();

              if (recognizedItems.isNotEmpty) {
                for (final recognizedItem in recognizedItems) {
                  onScan(recognizedItem);
                }
              }
            }
          }
        } catch (error) {
          log('SparkScanView didScan failed: $error');
        } finally {
          barcodeMethodHandler
              .finishSparkScanDidScan(viewId: _viewId, isEnabled: view._sparkScan.isEnabled)
              .onError(onError);
        }
      } else if (event.isEvent('SparkScanListener.didUpdateSession')) {
        // Blocks a native thread for 2000 ms on failure to reply: parse tolerantly, and finish
        // in a `finally` so the ack always fires.
        try {
          final parsed = _parsePayloadTolerantly<SparkScanListenerDidUpdateSession>(
            event.payload,
            (raw) => SparkScanListenerDidUpdateSession.fromJson(raw),
            (raw) {
              final map = raw as Map<String, dynamic>;
              return SparkScanListenerDidUpdateSession(
                session: map['session'] as String,
                frameId: map['frameId'] as String?,
                viewId: _viewId,
              );
            },
            'didUpdateSession',
          );
          var session = SparkScanSession.fromJSON({'session': parsed.session, 'frameId': parsed.frameId}, _viewId);
          await _notifyListenersOfDidUpateSession(session);
        } catch (error) {
          log('SparkScanView didUpdateSession failed: $error');
        } finally {
          barcodeMethodHandler
              .finishSparkScanDidUpdateSession(viewId: _viewId, isEnabled: view._sparkScan.isEnabled)
              .onError(onError);
        }
      }
    });
  }

  Future<void> _notifyListenersOfDidScan(SparkScanSession session) async {
    view._sparkScan._isInCallback = true;
    for (var listener in view._sparkScan._listeners.toList()) {
      await listener.didScan(view._sparkScan, session, () => _getLastFrameData(session));
    }
    view._sparkScan._isInCallback = false;
  }

  Future<void> _notifyListenersOfDidUpateSession(SparkScanSession session) async {
    view._sparkScan._isInCallback = true;
    // Iterate backwards to avoid allocation and handle concurrent modifications safely
    // This is called frequently so we avoid creating a copy
    for (var i = view._sparkScan._listeners.length - 1; i >= 0; i--) {
      if (i < view._sparkScan._listeners.length) {
        await view._sparkScan._listeners[i]
            .didUpdateSession(view._sparkScan, session, () => _getLastFrameData(session));
      }
    }
    view._sparkScan._isInCallback = false;
  }

  Future<FrameData> _getLastFrameData(SparkScanSession session) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: session.frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  void unsubscribeSparkScanListener() {
    _sparkScanListenerSubscription?.cancel();
    _sparkScanListenerSubscription = null;
    barcodeMethodHandler.unregisterSparkScanListenerForEvents(viewId: _viewId).onError(onError);
  }

  Future<void> updateSparkScanMode() {
    return barcodeMethodHandler
        .updateSparkScanMode(viewId: _viewId, modeJson: jsonEncode(view._sparkScan.toMap()))
        .onError(onError);
  }

  Future<SparkScanLicenseInfo?> getSparkScanLicenseInfo() async {
    // executeBarcode returns Future<dynamic>; the generated wrapper would
    // declare Future<String> and crash on a null result, so call it directly.
    final result =
        await barcodeMethodHandler.executeBarcode('SparkScanModule', 'getSparkScanLicenseInfo', {'viewId': _viewId});
    if (result == null) return null;
    return SparkScanLicenseInfo.fromJSON(jsonDecode(result as String) as Map<String, dynamic>);
  }

  Future<SparkScanScanningMode?> getScanningMode() async {
    final result = await barcodeMethodHandler.getSparkScanScanningMode(viewId: _viewId);
    if (result == null) return null;
    return SparkScanScanningModeSerializer.fromJSON(jsonDecode(result) as Map<String, dynamic>);
  }

  @override
  void dispose() {
    unsubscribeSparkScanListener();
    unsubscribeFromFeedbackDelegateEvents();
    unsubscribeUiListeners();
    super.dispose();
  }

  void setFeedbackDelegate(bool isRegister) {
    if (isRegister) {
      barcodeMethodHandler.registerSparkScanFeedbackDelegateForEvents(viewId: _viewId).onError(onError);
    } else {
      barcodeMethodHandler.unregisterSparkScanFeedbackDelegateForEvents(viewId: _viewId).onError(onError);
    }
  }

  void showView() {
    barcodeMethodHandler.showSparkScanView(viewId: _viewId).onError(onError);
  }

  void hideView() {
    barcodeMethodHandler.hideSparkScanView(viewId: _viewId).onError(onError);
  }
}
