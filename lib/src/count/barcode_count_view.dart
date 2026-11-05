/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

// ignore_for_file: must_be_immutable - packaging injects doc comments above the
// class, which detaches a line-level ignore from the class it applies to.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/adaptive_recognition.dart'
    show AdaptiveRecognitionErrorReason, AdaptiveRecognitionFrameMetadata, AdaptiveRecognitionServiceListener;
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_count.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_data_transformer.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_filter_highlight_settings.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_plugin_events.dart';
import 'package:scandit_flutter_datacapture_barcode/src/cluster.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/barcode_count_defaults.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/requests/barcode_count_status_provider_request.dart';
import 'package:scandit_flutter_datacapture_barcode/src/count/requests/barcode_count_status_provider_result.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show
        buildBarcodeCountView,
        BarcodeCountViewListenerBrushForRecognizedBarcode,
        BarcodeCountViewListenerBrushForRecognizedBarcodeNotInList,
        BarcodeCountViewListenerIconForRecognizedBarcode,
        BarcodeCountViewListenerIconForRecognizedBarcodeNotInList,
        BarcodeCountViewListenerIconForAcceptedBarcode,
        BarcodeCountViewListenerIconForRejectedBarcode,
        BarcodeCountViewListenerDidTapFilteredBarcode,
        BarcodeCountViewListenerDidTapRecognizedBarcode,
        BarcodeCountViewListenerDidTapRecognizedBarcodeNotInList,
        BarcodeCountViewListenerDidCompleteCaptureList,
        BarcodeCountViewListenerDidTapCluster,
        BarcodeCountViewUiListenerOnExitButtonTapped,
        BarcodeCountViewUiListenerOnListButtonTapped,
        BarcodeCountViewUiListenerOnSingleScanButtonTapped,
        BarcodeCountListenerOnScan,
        BarcodeCountListenerDidUpdateSession,
        BarcodeCountCaptureListListenerDidUpdateSession,
        BarcodeCountCaptureListListenerDidCompleteCaptureList,
        BarcodeCountAdaptiveRecognitionListenerDispatchStarted,
        BarcodeCountAdaptiveRecognitionListenerResponse,
        BarcodeCountAdaptiveRecognitionListenerError,
        buildBarcodeCount;
import 'package:scandit_flutter_datacapture_barcode/src/tracked_barcode.dart';
import 'package:scandit_flutter_datacapture_core/experimental.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_core/internal.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';

const List<String> _barcodeCountViewUiListenerEvents = [
  'BarcodeCountViewUiListener.onListButtonTapped',
  'BarcodeCountViewUiListener.onExitButtonTapped',
  'BarcodeCountViewUiListener.onSingleScanButtonTapped'
];

/// The style of the [BarcodeCountView]
///
/// Added in version 6.17.0
enum BarcodeCountViewStyle {
  /// Style that draws the highlights as icons and adds an animation for when a code newly appears.
  ///
  /// Added in version 6.17.0
  icon('icon'),
  /// Style that draws the highlights as a dot and adds an animation for when a code newly appears.
  ///
  /// Added in version 6.17.0
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

/// Added in version 6.17.0
abstract class BarcodeCountViewListener {
  static const String _brushForRecognizedBarcodeEventName = 'BarcodeCountViewListener.brushForRecognizedBarcode';
  static const String _brushForRecognizedBarcodeNotInListEventName =
      'BarcodeCountViewListener.brushForRecognizedBarcodeNotInList';

  static const String _didTapRecognizedBarcodeEventName = 'BarcodeCountViewListener.didTapRecognizedBarcode';
  static const String _didTapFilteredBarcodeEventName = 'BarcodeCountViewListener.didTapFilteredBarcode';
  static const String _didTapRecognizedBarcodeNotInListEventName =
      'BarcodeCountViewListener.didTapRecognizedBarcodeNotInList';
  static const String _didCompleteCaptureListEventName = 'BarcodeCountViewListener.didCompleteCaptureList';

  /// This method is called only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Callback method that can be used to set a [Brush] for a recognized barcode. When setting a [BarcodeCountCaptureList] to the mode, this brush will be used for recognized barcodes that are part of the target list. It is called when a new recognized barcode appears. Called from the rendering thread. If the callback returns *null*, then no visualization will be drawn for the recognized barcode. Additionally, tapping on the barcode will have no effect - the action defined by didTapRecognizedBarcode() callback will not be performed.
  ///
  /// Added in version 6.17.0
  Brush? brushForRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode);
  /// This method is called only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Callback method that can be used to set a [Brush] for a recognized barcode that’s not part of the target [BarcodeCountCaptureList]. It is called when a new recognized barcode that is not part of the target :type:barcode.count.BarcodeCountCaptureList appears. When [BarcodeCountCaptureList] is not set, this method will never be called. Called from the rendering thread. If the callback returns *null*, then no visualization will be drawn for the recognized barcode. Additionally, tapping on the barcode will have no effect - the action defined by didTapRecognizedBarcodeNotInList() callback will not be performed.
  ///
  /// Added in version 6.17.0
  Brush? brushForRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode);

  /// Callback method that can be used to define an action that should be performed once a recognized barcode is tapped. When setting a [BarcodeCountCaptureList] to the mode, this method will be called only when tapping recognized barcodes that are part of the target list. Called from the main thread.
  ///
  /// Added in version 6.17.0
  void didTapRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {}
  /// Callback method that can be used to define an action that should be performed once a filtered barcode is tapped. Called from the main thread.
  ///
  /// Added in version 6.17.0
  void didTapFilteredBarcode(BarcodeCountView view, TrackedBarcode filteredBarcode);
  /// Callback method that can be used to define an action that should be performed once a recognized barcode that’s not part of the target [BarcodeCountCaptureList] is tapped. When [BarcodeCountCaptureList] is not set, this method will never be called. Called from the main thread.
  ///
  /// Added in version 6.17.0
  void didTapRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode);
  /// Callback method that can be used to define an action that should be performed when all the items of a capture list have been correctly scanned. If there is no capture list set, this method will never be called. Called from the main thread.
  ///
  /// Added in version 6.17.0
  void didCompleteCaptureList(BarcodeCountView view);
}

/// Extended listener interface that adds new methods to [BarcodeCountViewListener] without breaking existing implementations.
///
/// Added in version 8.3.0
abstract class BarcodeCountViewExtendedListener extends BarcodeCountViewListener {
  static const String _didTapClusterEventName = 'BarcodeCountViewListener.didTapCluster';

  static const String _iconForRecognizedBarcodeEventName = 'BarcodeCountViewListener.iconForRecognizedBarcode';
  static const String _iconForRecognizedBarcodeNotInListEventName =
      'BarcodeCountViewListener.iconForRecognizedBarcodeNotInList';
  static const String _iconForAcceptedBarcodeEventName = 'BarcodeCountViewListener.iconForAcceptedBarcode';
  static const String _iconForRejectedBarcodeEventName = 'BarcodeCountViewListener.iconForRejectedBarcode';

  /// Callback method that can be used to define an action that should be performed once a cluster is tapped. Called from the main thread.
  ///
  /// This method is only available in [BarcodeCountViewExtendedListener]. To use it, implement the extended listener instead of the base listener.
  ///
  /// Added in version 8.3.0
  void didTapCluster(BarcodeCountView view, Cluster cluster) {}

  /// Callback method that can be used to set a [BarcodeCountIcon] for a recognized barcode. Only used when the view [BarcodeCountView.style] is [BarcodeCountViewStyle.icon]. If the callback returns *null*, no icon is drawn for that barcode. Returns the default recognized icon when not overridden.
  ///
  /// Added in version 8.6.0
  BarcodeCountIcon? iconForRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) =>
      BarcodeCountView.defaultRecognizedIcon;
  /// Callback method that can be used to set a [BarcodeCountIcon] for a recognized barcode that’s not part of the target [BarcodeCountCaptureList]. Only used when the view [BarcodeCountView.style] is [BarcodeCountViewStyle.icon]. If the callback returns *null*, no icon is drawn for that barcode. Returns the default not-in-list icon when not overridden.
  ///
  /// Added in version 8.6.0
  BarcodeCountIcon? iconForRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode) =>
      BarcodeCountView.defaultNotInListIcon;
  /// Callback method that can be used to set a [BarcodeCountIcon] for an accepted barcode. Used regardless of the view [BarcodeCountView.style]. If the callback returns *null*, no icon is drawn for that barcode. Returns the default accepted icon when not overridden.
  ///
  /// Added in version 8.6.0
  BarcodeCountIcon? iconForAcceptedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) =>
      BarcodeCountView.defaultAcceptedIcon;
  /// Callback method that can be used to set a [BarcodeCountIcon] for a rejected barcode. Used regardless of the view [BarcodeCountView.style]. If the callback returns *null*, no icon is drawn for that barcode. Returns the default rejected icon when not overridden.
  ///
  /// Added in version 8.6.0
  BarcodeCountIcon? iconForRejectedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) =>
      BarcodeCountView.defaultRejectedIcon;
}

/// Added in version 6.17.0
abstract class BarcodeCountViewUiListener {
  static const String _onExitButtonTappedEventName = 'BarcodeCountViewUiListener.onExitButtonTapped';
  static const String _onListButtonTappedEventName = 'BarcodeCountViewUiListener.onListButtonTapped';
  static const String _onSingleScanButtonTappedEventName = 'BarcodeCountViewUiListener.onSingleScanButtonTapped';

  /// Callback for the list button tap.
  ///
  /// Deprecated: implement [BarcodeCountViewUiExtendedListener] and use
  /// [BarcodeCountViewUiExtendedListener.didTapListButtonWithSnapshot], which also receives the
  /// [BarcodeCountSessionSnapshot] taken at the moment of the tap.
  ///
  /// Callback method that can be used to define an action that should be performed once the list button is tapped. Called from the main thread.
  ///
  /// Added in version 6.17.0
  @Deprecated('Use BarcodeCountViewUiExtendedListener.didTapListButtonWithSnapshot instead. Will be removed in 9.0.')
  void didTapListButton(BarcodeCountView view);

  /// Callback for the exit button tap.
  ///
  /// Deprecated: implement [BarcodeCountViewUiExtendedListener] and use
  /// [BarcodeCountViewUiExtendedListener.didTapExitButtonWithSnapshot], which also receives the
  /// [BarcodeCountSessionSnapshot] taken at the moment of the tap.
  ///
  /// Callback method that can be used to define an action that should be performed once the exit button is tapped. Called from the main thread.
  ///
  /// Added in version 6.17.0
  @Deprecated('Use BarcodeCountViewUiExtendedListener.didTapExitButtonWithSnapshot instead. Will be removed in 9.0.')
  void didTapExitButton(BarcodeCountView view);

  /// Callback method that can be used to define an action that should be performed once the single scan button is tapped. Called from the main thread.
  ///
  /// Added in version 6.17.0
  void didTapSingleScanButton(BarcodeCountView view);
}

/// An absent or unparseable snapshot must surface as `null`, never as an
/// empty [BarcodeCountSessionSnapshot] - "no session cached yet" and
/// "session present but empty" are different states on the native side.
BarcodeCountSessionSnapshot? _parseBarcodeCountSessionSnapshot(String? snapshotJson) {
  if (snapshotJson == null) {
    return null;
  }
  try {
    return BarcodeCountSessionSnapshot.fromJSON(jsonDecode(snapshotJson) as Map<String, dynamic>);
  } catch (error) {
    // Both an absent key and an unreadable payload surface as null to the listener, so log the
    // latter to keep the two distinguishable when diagnosing.
    dev.log('BarcodeCountView: could not read the session snapshot payload: $error');
    return null;
  }
}

/// Extends [BarcodeCountViewUiListener] with tap callbacks that also carry the
/// [BarcodeCountSessionSnapshot] captured at the moment of the tap.
///
/// [didTapListButtonWithSnapshot] and [didTapExitButtonWithSnapshot] **replace**
/// the inherited [BarcodeCountViewUiListener.didTapListButton] and
/// [BarcodeCountViewUiListener.didTapExitButton]: once a listener implements this
/// class, only the snapshot-carrying variants are invoked. When migrating an
/// existing listener, move the bodies of the two base callbacks into them rather
/// than leaving them behind - the base bodies still compile but never run.
/// [BarcodeCountViewUiListener.didTapSingleScanButton] is unaffected.
///
/// The base [BarcodeCountViewUiListener] methods are non-nullable and already
/// implemented by production code, so adding a member there would be a
/// source-breaking change for every existing implementer. A snapshot may
/// legitimately be `null` - e.g. no session has been cached yet - which is a
/// different state from a present-but-empty session, so callers must not
/// coalesce the two.
///
/// Extended version of [BarcodeCountViewUiListener] that delivers a [BarcodeCountSessionSnapshot] with the list and exit button taps. On Dart the base interface’s methods cannot take an additional parameter without breaking existing implementations, so the snapshot-carrying callbacks live here instead.
///
/// On this interface BarcodeCountViewUiListener.didTapListButton() and BarcodeCountViewUiListener.didTapExitButton() are never invoked — the `WithSnapshot` variants below receive those taps instead. Overriding either of them here has no effect. BarcodeCountViewUiListener.didTapSingleScanButton() is inherited and behaves as usual. It adds the following:
///
/// Added in version 8.7.0
abstract class BarcodeCountViewUiExtendedListener extends BarcodeCountViewUiListener {
  /// Receives the list button tap instead of the inherited [didTapListButton], which is never
  /// invoked on an extended listener.
  ///
  /// Callback method that can be used to define an action that should be performed once the list button is tapped. Replaces BarcodeCountViewUiListener.didTapListButton() on this interface. Receives an immutable [BarcodeCountSessionSnapshot] of the session at the moment of the tap, or `null` when the SDK has no session cached yet. Called from the main thread.
  ///
  /// Added in version 8.7.0
  void didTapListButtonWithSnapshot(BarcodeCountView view, BarcodeCountSessionSnapshot? snapshot);

  /// Receives the exit button tap instead of the inherited [didTapExitButton], which is never
  /// invoked on an extended listener.
  ///
  /// Callback method that can be used to define an action that should be performed once the exit button is tapped. Replaces BarcodeCountViewUiListener.didTapExitButton() on this interface. Receives an immutable [BarcodeCountSessionSnapshot] of the session at the moment of the tap, or `null` when the SDK has no session cached yet. Called from the main thread.
  ///
  /// Added in version 8.7.0
  void didTapExitButtonWithSnapshot(BarcodeCountView view, BarcodeCountSessionSnapshot? snapshot);
}

/// When BarcodeCount queries for a status list with [BarcodeCountStatusProvider.onStatusRequested], an instance of this interface is provided to inform BarcodeCount of the result.
///
/// Added in version 7.0.0
class BarcodeCountStatusProviderCallback {
  final _BarcodeCountViewController _controller;
  final String _requestId;

  BarcodeCountStatusProviderCallback._(this._controller, this._requestId);

  /// This method must be called with the [BarcodeCountStatusResult] in order to enter status mode.
  ///
  /// Added in version 7.0.0
  Future<void> onStatusReady(BarcodeCountStatusResult statusResult) {
    return _controller.submitBarcodeCountStatusProviderCallback(statusResult, _requestId);
  }
}

/// When enabling status mode, an instance of this interface must be provided.
///
/// Added in version 7.0.0
abstract class BarcodeCountStatusProvider {
  static const String _onStatusRequestedEventName = 'BarcodeCountStatusProvider.onStatusRequested';

  /// This method will be called when the status for a group of barcodes is required. The implementation must call the callback to provide the status list.
  ///
  /// Added in version 7.0.0
  void onStatusRequested(List<TrackedBarcode> barcodes, BarcodeCountStatusProviderCallback providerCallback);
}

/// [BarcodeCount] comes with a ready-to-use UI. Add [BarcodeCountView] to the view hierarchy. Please note that this view should be presented full screen.
///
/// Added in version 6.17.0
class BarcodeCountView extends StatefulWidget implements Serializable {
  // We require that to exist doesn't mean it must be used here.
  // ignore: unused_field
  DataCaptureContext _dataCaptureContext;
  BarcodeCount _barcodeCount;
  BarcodeCountViewStyle _style;
  int _viewId = 0;
  BarcodeCountMappingFlowSettings? _mappingFlowSettings;

  // set from the state
  _BarcodeCountViewController? _controller;

  BarcodeCountView._(this._dataCaptureContext, this._barcodeCount, this._style, this._mappingFlowSettings) : super();

  factory BarcodeCountView.forContextWithMode(DataCaptureContext dataCaptureContext, BarcodeCount barcodeCount) {
    return BarcodeCountView._(dataCaptureContext, barcodeCount, BarcodeCountDefaults.viewDefaults.style, null);
  }

  factory BarcodeCountView.forContextWithModeAndStyle(
    DataCaptureContext dataCaptureContext,
    BarcodeCount barcodeCount,
    BarcodeCountViewStyle style,
  ) {
    return BarcodeCountView._(dataCaptureContext, barcodeCount, style, null);
  }

  /// Constructs a new barcode count view to use with the grid mapping flow.
  ///
  /// The grid mapping flow only supports grids of 4 rows by 2 columns.
  ///
  /// Added in version 8.3.0
  factory BarcodeCountView.forMapping(
    DataCaptureContext dataCaptureContext,
    BarcodeCount barcodeCount,
    BarcodeCountViewStyle style,
    BarcodeCountMappingFlowSettings mappingFlowSettings,
  ) {
    return BarcodeCountView._(dataCaptureContext, barcodeCount, style, mappingFlowSettings);
  }

  bool _shouldShowUserGuidanceView = BarcodeCountDefaults.viewDefaults.shouldShowUserGuidanceView;

  /// When set to *true*, user guidance and the loading view will be shown to the user. The user guidance prompts the user to scan, and to move closer or further away from the target barcodes in order to scan them properly.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowUserGuidanceView => _shouldShowUserGuidanceView;

  /// When set to *true*, user guidance and the loading view will be shown to the user. The user guidance prompts the user to scan, and to move closer or further away from the target barcodes in order to scan them properly.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  set shouldShowUserGuidanceView(bool newValue) {
    _shouldShowUserGuidanceView = newValue;
    _updateNative();
  }

  bool _shouldShowListButton = BarcodeCountDefaults.viewDefaults.shouldShowListButton;

  /// When set to *true*, a list button will be shown to the user in the lower left hand corner of the screen. When tapped, this button will freeze the mode. This button triggers a call to BarcodeCountViewUiListener.didTapListButton().
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowListButton => _shouldShowListButton;

  /// When set to *true*, a list button will be shown to the user in the lower left hand corner of the screen. When tapped, this button will freeze the mode. This button triggers a call to BarcodeCountViewUiListener.didTapListButton().
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  set shouldShowListButton(bool newValue) {
    _shouldShowListButton = newValue;
    _updateNative();
  }

  bool _shouldShowExitButton = BarcodeCountDefaults.viewDefaults.shouldShowExitButton;

  /// When set to *true*, an exit button will be shown in the lower right hand corner of the screen. The behavior for this button is left entirely to the developer, and does nothing by default. When clicked, this button triggers a call to BarcodeCountViewUiListener.didTapExitButton().
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowExitButton => _shouldShowExitButton;

  /// When set to *true*, an exit button will be shown in the lower right hand corner of the screen. The behavior for this button is left entirely to the developer, and does nothing by default. When clicked, this button triggers a call to BarcodeCountViewUiListener.didTapExitButton().
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  set shouldShowExitButton(bool newValue) {
    _shouldShowExitButton = newValue;
    _updateNative();
  }

  bool _shouldShowShutterButton = BarcodeCountDefaults.viewDefaults.shouldShowShutterButton;

  /// When set to *true*, a shutter button will be shown to the user centered in the bottom of the screen. This button triggers the processing of the current video feed. The same functionality can be triggered by calling [BarcodeCount.startScanningPhase].
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowShutterButton => _shouldShowShutterButton;

  /// When set to *true*, a shutter button will be shown to the user centered in the bottom of the screen. This button triggers the processing of the current video feed. The same functionality can be triggered by calling [BarcodeCount.startScanningPhase].
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  set shouldShowShutterButton(bool newValue) {
    _shouldShowShutterButton = newValue;
    _updateNative();
  }

  bool _shouldShowHints = BarcodeCountDefaults.viewDefaults.shouldShowHints;

  /// When set to *true*, this view will show some messages about currently scanned barcodes.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowHints => _shouldShowHints;

  /// When set to *true*, this view will show some messages about currently scanned barcodes.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  set shouldShowHints(bool newValue) {
    _shouldShowHints = newValue;
    _updateNative();
  }

  bool _shouldShowClearHighlightsButton = BarcodeCountDefaults.viewDefaults.shouldShowClearHighlightsButton;

  /// When set to *true*, a button will be shown above the default shutter button. This button clears all currently shown barcodes highlights.
  ///
  /// Added in version 6.17.0
  bool get shouldShowClearHighlightsButton => _shouldShowClearHighlightsButton;

  /// When set to *true*, a button will be shown above the default shutter button. This button clears all currently shown barcodes highlights.
  ///
  /// Added in version 6.17.0
  set shouldShowClearHighlightsButton(bool newValue) {
    _shouldShowClearHighlightsButton = newValue;
    _updateNative();
  }

  bool _shouldShowSingleScanButton = BarcodeCountDefaults.viewDefaults.shouldShowSingleScanButton;

  /// When set to *true*, a button will be shown to the user in the lower left corner of the preview. The behavior for this button is left entirely to the developer, and does nothing by default. When clicked, this button triggers a call to BarcodeCountViewUiListener.didTapSingleScanButton().
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowSingleScanButton => _shouldShowSingleScanButton;

  /// When set to *true*, a button will be shown to the user in the lower left corner of the preview. The behavior for this button is left entirely to the developer, and does nothing by default. When clicked, this button triggers a call to BarcodeCountViewUiListener.didTapSingleScanButton().
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.17.0
  set shouldShowSingleScanButton(bool newValue) {
    _shouldShowSingleScanButton = newValue;
    _updateNative();
  }

  bool _shouldShowFloatingShutterButton = BarcodeCountDefaults.viewDefaults.shouldShowFloatingShutterButton;

  /// When set to *true*, a floating shutter button will be visible on screen. This button can be dragged to any position and, when tapped, will trigger the processing of the current video feed.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowFloatingShutterButton => _shouldShowFloatingShutterButton;

  /// When set to *true*, a floating shutter button will be visible on screen. This button can be dragged to any position and, when tapped, will trigger the processing of the current video feed.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.17.0
  set shouldShowFloatingShutterButton(bool newValue) {
    _shouldShowFloatingShutterButton = newValue;
    _updateNative();
  }

  bool _shouldShowToolbar = BarcodeCountDefaults.viewDefaults.shouldShowToolbar;

  /// When set to *true*, a collapsable toolbar will be visible at the top of the preview. This toolbar contains a set of convenience buttons for easy preference setting during scanning.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowToolbar => _shouldShowToolbar;

  /// When set to *true*, a collapsable toolbar will be visible at the top of the preview. This toolbar contains a set of convenience buttons for easy preference setting during scanning.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.17.0
  set shouldShowToolbar(bool newValue) {
    _shouldShowToolbar = newValue;
    _updateNative();
  }

  BarcodeCountViewUiListener? _barcodeCountViewUiListener;

  /// The listener which is called whenever the exit or list button of the view did receive a tap.
  ///
  /// Using this listener requires the MatrixScan AR add-on.
  ///
  /// Added in version 6.17.0
  BarcodeCountViewUiListener? get uiListener => _barcodeCountViewUiListener;

  /// The listener which is called whenever the exit or list button of the view did receive a tap.
  ///
  /// Using this listener requires the MatrixScan AR add-on.
  ///
  /// Added in version 6.17.0
  set uiListener(BarcodeCountViewUiListener? newValue) {
    _barcodeCountViewUiListener = newValue;
    _controller?.setUiListener(newValue);
  }

  BarcodeCountViewListener? _barcodeCountViewListener;

  /// The listener which is called whenever a new [TrackedBarcode] is newly tracked or newly recognized.
  ///
  /// Using this listener requires the MatrixScan AR add-on.
  ///
  /// Added in version 6.17.0
  BarcodeCountViewListener? get listener => _barcodeCountViewListener;

  /// The listener which is called whenever a new [TrackedBarcode] is newly tracked or newly recognized.
  ///
  /// Using this listener requires the MatrixScan AR add-on.
  ///
  /// Added in version 6.17.0
  set listener(BarcodeCountViewListener? newValue) {
    _barcodeCountViewListener = newValue;
    _controller?.setListener(newValue);
  }

  /// Returns the default brush to use for a recognized barcode. When setting a [BarcodeCountCaptureList] to the mode, this brush will be used for recognized barcodes that are part of the target list. Only used when setting the view [BarcodeCountView.style] to [BarcodeCountViewStyle.dot].
  ///
  /// Added in version 6.17.0
  static Brush get defaultRecognizedBrush {
    return BarcodeCountDefaults.viewDefaults.defaultRecognizedBrush;
  }

  /// Returns the default brush to use for a recognized barcode that’s not part of the target [BarcodeCountCaptureList]. Only used when setting the view [BarcodeCountView.style] to [BarcodeCountViewStyle.dot].
  ///
  /// Added in version 6.17.0
  static Brush get defaultNotInListBrush {
    return BarcodeCountDefaults.viewDefaults.defaultNotInListBrush;
  }

  /// Returns the default [BarcodeCountIcon] used for a recognized barcode. When setting a [BarcodeCountCaptureList] to the mode, this icon will be used for recognized barcodes that are part of the target list. Only used when the view [BarcodeCountView.style] is [BarcodeCountViewStyle.icon].
  ///
  /// Added in version 8.6.0
  static BarcodeCountIcon get defaultRecognizedIcon {
    return BarcodeCountDefaults.viewDefaults.defaultRecognizedIcon;
  }

  /// Returns the default [BarcodeCountIcon] used for a recognized barcode that’s not part of the target [BarcodeCountCaptureList]. Only used when the view [BarcodeCountView.style] is [BarcodeCountViewStyle.icon].
  ///
  /// Added in version 8.6.0
  static BarcodeCountIcon get defaultNotInListIcon {
    return BarcodeCountDefaults.viewDefaults.defaultNotInListIcon;
  }

  /// Returns the default [BarcodeCountIcon] used for an accepted barcode. Used regardless of the view [BarcodeCountView.style].
  ///
  /// Added in version 8.6.0
  static BarcodeCountIcon get defaultAcceptedIcon {
    return BarcodeCountDefaults.viewDefaults.defaultAcceptedIcon;
  }

  /// Returns the default [BarcodeCountIcon] used for a rejected barcode. Used regardless of the view [BarcodeCountView.style].
  ///
  /// Added in version 8.6.0
  static BarcodeCountIcon get defaultRejectedIcon {
    return BarcodeCountDefaults.viewDefaults.defaultRejectedIcon;
  }

  Brush? _recognizedBrush = BarcodeCountDefaults.viewDefaults.defaultRecognizedBrush;

  /// The brush applied to recognized tracked barcodes if [BarcodeCountViewListener] is not implemented. When setting a [BarcodeCountCaptureList] to the mode, this brush will be used for recognized barcodes that are part of the target list. Setting this brush to *null* hides all tracked barcodes.
  ///
  /// Defaults to a yellow-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 6.17.0
  Brush? get recognizedBrush => _recognizedBrush;

  /// The brush applied to recognized tracked barcodes if [BarcodeCountViewListener] is not implemented. When setting a [BarcodeCountCaptureList] to the mode, this brush will be used for recognized barcodes that are part of the target list. Setting this brush to *null* hides all tracked barcodes.
  ///
  /// Defaults to a yellow-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 6.17.0
  set recognizedBrush(Brush? newValue) {
    _recognizedBrush = newValue;
    _updateNative();
  }

  Brush? _notInListBrush = BarcodeCountDefaults.viewDefaults.defaultNotInListBrush;

  /// The brush applied to recognized tracked barcodes that are not part of the target [BarcodeCountCaptureList], and only if [BarcodeCountViewListener] is not implemented. When [BarcodeCountCaptureList] is not set, this method will never be called. Setting this brush to *null* hides all tracked barcodes.
  ///
  /// Defaults to a red-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 6.17.0
  Brush? get notInListBrush => _notInListBrush;

  /// The brush applied to recognized tracked barcodes that are not part of the target [BarcodeCountCaptureList], and only if [BarcodeCountViewListener] is not implemented. When [BarcodeCountCaptureList] is not set, this method will never be called. Setting this brush to *null* hides all tracked barcodes.
  ///
  /// Defaults to a red-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 6.17.0
  set notInListBrush(Brush? newValue) {
    _notInListBrush = newValue;
    _updateNative();
  }

  Brush? _acceptedBrush = BarcodeCountDefaults.viewDefaults.defaultAcceptedBrush;

  /// The brush applied to accepted tracked barcodes if [BarcodeCountViewListener] is not implemented. Setting this brush to *null* hides all accepted barcodes.
  ///
  /// Defaults to a green-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  Brush? get acceptedBrush => _acceptedBrush;

  /// The brush applied to accepted tracked barcodes if [BarcodeCountViewListener] is not implemented. Setting this brush to *null* hides all accepted barcodes.
  ///
  /// Defaults to a green-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  set acceptedBrush(Brush? newValue) {
    _acceptedBrush = newValue;
    _updateNative();
  }

  Brush? _rejectedBrush = BarcodeCountDefaults.viewDefaults.defaultRejectedBrush;

  /// The brush applied to rejected tracked barcodes if [BarcodeCountViewListener] is not implemented. Setting this brush to *null* hides all rejected barcodes.
  ///
  /// Defaults to a red-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  Brush? get rejectedBrush => _rejectedBrush;

  /// The brush applied to rejected tracked barcodes if [BarcodeCountViewListener] is not implemented. Setting this brush to *null* hides all rejected barcodes.
  ///
  /// Defaults to a red-colored Brush.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  set rejectedBrush(Brush? newValue) {
    _rejectedBrush = newValue;
    _updateNative();
  }

  bool _shouldShowScanAreaGuides = BarcodeCountDefaults.viewDefaults.shouldShowScanAreaGuides;

  /// When set to *true*, this view will visualize the active scan area used for BarcodeCount. This is useful to check margins ([DataCaptureView.scanAreaMargins]) defined on the [DataCaptureView] are set correctly. This property is meant for debugging during development and is not intended for use in production.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.17.0
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  /// When set to *true*, this view will visualize the active scan area used for BarcodeCount. This is useful to check margins ([DataCaptureView.scanAreaMargins]) defined on the [DataCaptureView] are set correctly. This property is meant for debugging during development and is not intended for use in production.
  ///
  /// By default this property is *false*.
  ///
  /// Added in version 6.17.0
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _updateNative();
  }

  BarcodeFilterHighlightSettings? _filterSettings;

  /// Use this property to access or modify the current view settings for barcode filtering.
  ///
  /// Added in version 6.17.0
  BarcodeFilterHighlightSettings? get filterSettings => _filterSettings;

  /// Use this property to access or modify the current view settings for barcode filtering.
  ///
  /// Added in version 6.17.0
  set filterSettings(BarcodeFilterHighlightSettings? newValue) {
    _filterSettings = newValue;
    _updateNative();
  }

  /// The view style. Defaults to [BarcodeCountViewStyle.dot].
  ///
  /// Added in version 6.17.0
  BarcodeCountViewStyle get style => _style;

  BarcodeCountNotInListActionSettings _barcodeNotInListActionSettings = BarcodeCountNotInListActionSettings();

  /// Use this object to customize barcode not in list actions.
  ///
  /// Added in version 8.3.0
  BarcodeCountNotInListActionSettings get barcodeNotInListActionSettings => _barcodeNotInListActionSettings;

  /// Use this object to customize barcode not in list actions.
  ///
  /// Added in version 8.3.0
  set barcodeNotInListActionSettings(BarcodeCountNotInListActionSettings newValue) {
    _barcodeNotInListActionSettings = newValue;
    _updateNative();
  }

  bool _hardwareTriggerEnabled = false;

  /// Enables the [BarcodeCountView] to react to clicks of the volume button.
  ///
  /// Added in version 8.3.0
  bool get hardwareTriggerEnabled => _hardwareTriggerEnabled;

  /// Enables the [BarcodeCountView] to react to clicks of the volume button.
  ///
  /// Added in version 8.3.0
  set hardwareTriggerEnabled(bool newValue) {
    _hardwareTriggerEnabled = newValue;
    _updateNative();
  }

  /// Returns whether the device supports listening for hardware button events. This is true for devices with api >= 28.
  ///
  /// This method is only supported on Android devices.
  ///
  /// Added in version 8.3.0
  static bool get hardwareTriggerSupported => BarcodeCountDefaults.viewDefaults.hardwareTriggerSupported;

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 6.17.0
  @override
  State<StatefulWidget> createState() => _BarcodeCountViewState();

  /// Clear all currently shown barcodes highlights. This only affects screen rendering, and all detected barcodes will still be available in the [BarcodeCountSession].
  ///
  /// Added in version 6.17.0
  Future<void> clearHighlights() {
    return _controller?.clearHighlights() ?? Future.value();
  }

  /// Sets a [Brush] to be used for a particular recognized [TrackedBarcode]. This will override any other applicable brush for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  Future<void> setBrushForRecognizedBarcode(TrackedBarcode trackedBarcode, Brush? brush) {
    return _controller?.setBrushForRecognizedBarcode(trackedBarcode, brush) ?? Future.value();
  }

  /// Sets a [Brush] to be used for a particular recognized [TrackedBarcode] that doesn’t belong to the capture list. This will only be applicable when using a capture list, and will override any other applicable brush for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  Future<void> setBrushForRecognizedBarcodeNotInList(TrackedBarcode trackedBarcode, Brush? brush) {
    return _controller?.setBrushForRecognizedBarcodeNotInList(trackedBarcode, brush) ?? Future.value();
  }

  /// Sets a [Brush] to be used for a particular accepted [TrackedBarcode]. This will override any other applicable brush for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  Future<void> setBrushForAcceptedBarcode(TrackedBarcode trackedBarcode, Brush? brush) {
    return _controller?.setBrushForAcceptedBarcode(trackedBarcode, brush) ?? Future.value();
  }

  /// Sets a [Brush] to be used for a particular rejected [TrackedBarcode]. This will override any other applicable brush for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.dot] style.
  ///
  /// Added in version 8.3.0
  Future<void> setBrushForRejectedBarcode(TrackedBarcode trackedBarcode, Brush? brush) {
    return _controller?.setBrushForRejectedBarcode(trackedBarcode, brush) ?? Future.value();
  }

  /// Sets a [BarcodeCountIcon] to be used for a particular recognized [TrackedBarcode]. This will override any other applicable icon for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.icon] style.
  ///
  /// On iOS, passing *null* suppresses the highlight for the given barcode. On Android, passing *null* removes the override, so the barcode reverts to its default or listener-provided icon.
  ///
  /// The icon is applied while answering the corresponding view listener callback for that barcode. Calling this method at another time resolves without changing the icon, as the pre-existing brush setters do.
  ///
  /// Added in version 8.7.0
  Future<void> setIconForRecognizedBarcode(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return _controller?.setIconForRecognizedBarcode(trackedBarcode, icon) ?? Future.value();
  }

  /// Sets a [BarcodeCountIcon] to be used for a particular recognized [TrackedBarcode] that doesn’t belong to the capture list. This will only be applicable when using a capture list, and will override any other applicable icon for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.icon] style.
  ///
  /// On iOS, passing *null* suppresses the highlight for the given barcode. On Android, passing *null* removes the override, so the barcode reverts to its default or listener-provided icon.
  ///
  /// The icon is applied while answering the corresponding view listener callback for that barcode. Calling this method at another time resolves without changing the icon, as the pre-existing brush setters do.
  ///
  /// Added in version 8.7.0
  Future<void> setIconForRecognizedBarcodeNotInList(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return _controller?.setIconForRecognizedBarcodeNotInList(trackedBarcode, icon) ?? Future.value();
  }

  /// Sets a [BarcodeCountIcon] to be used for a particular accepted [TrackedBarcode]. This will override any other applicable icon for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.icon] style.
  ///
  /// On iOS, passing *null* suppresses the highlight for the given barcode. On Android, passing *null* removes the override, so the barcode reverts to its default or listener-provided icon.
  ///
  /// The icon is applied while answering the corresponding view listener callback for that barcode. Calling this method at another time resolves without changing the icon, as the pre-existing brush setters do.
  ///
  /// Added in version 8.7.0
  Future<void> setIconForAcceptedBarcode(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return _controller?.setIconForAcceptedBarcode(trackedBarcode, icon) ?? Future.value();
  }

  /// Sets a [BarcodeCountIcon] to be used for a particular rejected [TrackedBarcode]. This will override any other applicable icon for this particular barcode.
  ///
  /// Used only when the view uses the [BarcodeCountViewStyle.icon] style.
  ///
  /// On iOS, passing *null* suppresses the highlight for the given barcode. On Android, passing *null* removes the override, so the barcode reverts to its default or listener-provided icon.
  ///
  /// The icon is applied while answering the corresponding view listener callback for that barcode. Calling this method at another time resolves without changing the icon, as the pre-existing brush setters do.
  ///
  /// Added in version 8.7.0
  Future<void> setIconForRejectedBarcode(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return _controller?.setIconForRejectedBarcode(trackedBarcode, icon) ?? Future.value();
  }

  /// Added in version 8.3.0
  Future<void> enableHardwareTrigger(int? hardwareTriggerKeyCode) {
    return _controller?.enableHardwareTrigger(hardwareTriggerKeyCode) ?? Future.value();
  }

  String _listButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.listButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the list button provided by the view.
  ///
  /// Default value is “List button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get listButtonAccessibilityHint => _listButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the list button provided by the view.
  ///
  /// Default value is “List button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set listButtonAccessibilityHint(String newValue) {
    _listButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _listButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.listButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the list button provided by the view.
  ///
  /// Default value is “List button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get listButtonAccessibilityLabel => _listButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the list button provided by the view.
  ///
  /// Default value is “List button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set listButtonAccessibilityLabel(String newValue) {
    _listButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _listButtonContentDescription = BarcodeCountDefaults.viewDefaults.listButtonContentDescription;

  /// Use this property to access or modify the content description of the list button provided by the view.
  ///
  /// Default value is “List button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  String get listButtonContentDescription => _listButtonContentDescription;

  /// Use this property to access or modify the content description of the list button provided by the view.
  ///
  /// Default value is “List button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  set listButtonContentDescription(String newValue) {
    _listButtonContentDescription = newValue;
    _updateNative();
  }

  String _exitButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.exitButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the exit button provided by the view.
  ///
  /// Default value is “Exit button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get exitButtonAccessibilityHint => _exitButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the exit button provided by the view.
  ///
  /// Default value is “Exit button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set exitButtonAccessibilityHint(String newValue) {
    _exitButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _exitButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.exitButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the exit button provided by the view.
  ///
  /// Default value is “Exit button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get exitButtonAccessibilityLabel => _exitButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the exit button provided by the view.
  ///
  /// Default value is “Exit button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set exitButtonAccessibilityLabel(String newValue) {
    _exitButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _exitButtonContentDescription = BarcodeCountDefaults.viewDefaults.exitButtonContentDescription;

  /// Use this property to access or modify the content description of the exit button provided by the view.
  ///
  /// Default value is “Exit button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  String get exitButtonContentDescription => _exitButtonContentDescription;

  /// Use this property to access or modify the content description of the exit button provided by the view.
  ///
  /// Default value is “Exit button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  set exitButtonContentDescription(String newValue) {
    _exitButtonContentDescription = newValue;
    _updateNative();
  }

  String _shutterButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.shutterButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the shutter button provided by the view.
  ///
  /// Default value is “Shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get shutterButtonAccessibilityHint => _shutterButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the shutter button provided by the view.
  ///
  /// Default value is “Shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set shutterButtonAccessibilityHint(String newValue) {
    _shutterButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _shutterButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.shutterButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the shutter button provided by the view.
  ///
  /// Default value is “Shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get shutterButtonAccessibilityLabel => _shutterButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the shutter button provided by the view.
  ///
  /// Default value is “Shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set shutterButtonAccessibilityLabel(String newValue) {
    _shutterButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _shutterButtonContentDescription = BarcodeCountDefaults.viewDefaults.shutterButtonContentDescription;

  /// Use this property to access or modify the content description of the shutter button provided by the view.
  ///
  /// Default value is “Shutter button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  String get shutterButtonContentDescription => _shutterButtonContentDescription;

  /// Use this property to access or modify the content description of the shutter button provided by the view.
  ///
  /// Default value is “Shutter button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  set shutterButtonContentDescription(String newValue) {
    _shutterButtonContentDescription = newValue;
    _updateNative();
  }

  String _floatingShutterButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.floatingShutterButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the floating shutter button provided by the view.
  ///
  /// Default value is “Floating shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get floatingShutterButtonAccessibilityHint => _floatingShutterButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the floating shutter button provided by the view.
  ///
  /// Default value is “Floating shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set floatingShutterButtonAccessibilityHint(String newValue) {
    _floatingShutterButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _floatingShutterButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.floatingShutterButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the floating shutter button provided by the view.
  ///
  /// Default value is “Floating shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get floatingShutterButtonAccessibilityLabel => _floatingShutterButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the floating shutter button provided by the view.
  ///
  /// Default value is “Floating shutter button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set floatingShutterButtonAccessibilityLabel(String newValue) {
    _floatingShutterButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _floatingShutterButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.floatingShutterButtonContentDescription;

  /// Use this property to access or modify the content description for the floating shutter button provided by the view.
  ///
  /// Default value is “Floating shutter button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  String get floatingShutterButtonContentDescription => _floatingShutterButtonContentDescription;

  /// Use this property to access or modify the content description for the floating shutter button provided by the view.
  ///
  /// Default value is “Floating shutter button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  set floatingShutterButtonContentDescription(String newValue) {
    _floatingShutterButtonContentDescription = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonAccessibilityHint =
      BarcodeCountDefaults.viewDefaults.clearHighlightsButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the clear highlights button provided by the view.
  ///
  /// Default value is “Clear highlights button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get clearHighlightsButtonAccessibilityHint => _clearHighlightsButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the clear highlights button provided by the view.
  ///
  /// Default value is “Clear highlights button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set clearHighlightsButtonAccessibilityHint(String newValue) {
    _clearHighlightsButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonAccessibilityLabel =
      BarcodeCountDefaults.viewDefaults.clearHighlightsButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the clear highlights button provided by the view.
  ///
  /// Default value is “Clear highlights button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get clearHighlightsButtonAccessibilityLabel => _clearHighlightsButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the clear highlights button provided by the view.
  ///
  /// Default value is “Clear highlights button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set clearHighlightsButtonAccessibilityLabel(String newValue) {
    _clearHighlightsButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonContentDescription =
      BarcodeCountDefaults.viewDefaults.clearHighlightsButtonContentDescription;

  /// Use this property to access or modify the content description of the “clear highlights” button provided by the view.
  ///
  /// Default value is “Clear highlights button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  String get clearHighlightsButtonContentDescription => _clearHighlightsButtonContentDescription;

  /// Use this property to access or modify the content description of the “clear highlights” button provided by the view.
  ///
  /// Default value is “Clear highlights button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  set clearHighlightsButtonContentDescription(String newValue) {
    _clearHighlightsButtonContentDescription = newValue;
    _updateNative();
  }

  String _singleScanButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.singleScanButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the single scan button provided by the view.
  ///
  /// Default value is “Single scan button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get singleScanButtonAccessibilityHint => _singleScanButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the single scan button provided by the view.
  ///
  /// Default value is “Single scan button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set singleScanButtonAccessibilityHint(String newValue) {
    _singleScanButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _singleScanButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.singleScanButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the single scan button provided by the view.
  ///
  /// Default value is “Single scan button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  String get singleScanButtonAccessibilityLabel => _singleScanButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the single scan button provided by the view.
  ///
  /// Default value is “Single scan button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 6.17.0
  set singleScanButtonAccessibilityLabel(String newValue) {
    _singleScanButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _singleScanButtonContentDescription = BarcodeCountDefaults.viewDefaults.singleScanButtonContentDescription;

  /// Use this property to access or modify the content description of the “single scan” button provided by the view.
  ///
  /// Default value is “Single scan button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  String get singleScanButtonContentDescription => _singleScanButtonContentDescription;

  /// Use this property to access or modify the content description of the “single scan” button provided by the view.
  ///
  /// Default value is “Single scan button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 6.17.0
  set singleScanButtonContentDescription(String newValue) {
    _singleScanButtonContentDescription = newValue;
    _updateNative();
  }

  String _statusModeButtonAccessibilityHint = BarcodeCountDefaults.viewDefaults.statusModeButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the status mode button provided by the view.
  ///
  /// Default value is “Status mode button”.
  ///
  /// Added in version 8.3.0
  String get statusModeButtonAccessibilityHint => _statusModeButtonAccessibilityHint;

  /// Use this property to access or modify the accessibility hint for the status mode button provided by the view.
  ///
  /// Default value is “Status mode button”.
  ///
  /// Added in version 8.3.0
  set statusModeButtonAccessibilityHint(String newValue) {
    _statusModeButtonAccessibilityHint = newValue;
    _updateNative();
  }

  String _statusModeButtonAccessibilityLabel = BarcodeCountDefaults.viewDefaults.statusModeButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the single status mode button provided by the view.
  ///
  /// Default value is “Status mode button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 8.3.0
  String get statusModeButtonAccessibilityLabel => _statusModeButtonAccessibilityLabel;

  /// Use this property to access or modify the accessibility label for the single status mode button provided by the view.
  ///
  /// Default value is “Status mode button”.
  ///
  /// This property has effect only when running on iOS.
  ///
  /// Added in version 8.3.0
  set statusModeButtonAccessibilityLabel(String newValue) {
    _statusModeButtonAccessibilityLabel = newValue;
    _updateNative();
  }

  String _statusModeButtonContentDescription = BarcodeCountDefaults.viewDefaults.statusModeButtonContentDescription;

  /// Gets or sets the content description for the status mode button provided by the view.
  ///
  /// Default value is “Status mode button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 8.3.0
  String get statusModeButtonContentDescription => _statusModeButtonContentDescription;

  /// Gets or sets the content description for the status mode button provided by the view.
  ///
  /// Default value is “Status mode button”.
  ///
  /// This property has effect only when running on Android.
  ///
  /// Added in version 8.3.0
  set statusModeButtonContentDescription(String newValue) {
    _statusModeButtonContentDescription = newValue;
    _updateNative();
  }

  String _clearHighlightsButtonText = BarcodeCountDefaults.viewDefaults.clearHighlightsButtonText;

  /// Use this property to access or modify the text of the clear button label provided by the view.
  ///
  /// Default value is “Clear screen”.
  ///
  /// Added in version 6.17.0
  String get clearHighlightsButtonText => _clearHighlightsButtonText;

  /// Use this property to access or modify the text of the clear button label provided by the view.
  ///
  /// Default value is “Clear screen”.
  ///
  /// Added in version 6.17.0
  set clearHighlightsButtonText(String newValue) {
    _clearHighlightsButtonText = newValue;
    _updateNative();
  }

  String _exitButtonText = BarcodeCountDefaults.viewDefaults.exitButtonText;

  /// Use this property to access or modify the text of the exit button label provided by the view.
  ///
  /// Default value is “Finish”.
  ///
  /// Added in version 6.17.0
  String get exitButtonText => _exitButtonText;

  /// Use this property to access or modify the text of the exit button label provided by the view.
  ///
  /// Default value is “Finish”.
  ///
  /// Added in version 6.17.0
  set exitButtonText(String newValue) {
    _exitButtonText = newValue;
    _updateNative();
  }

  String _textForTapShutterToScanHint = BarcodeCountDefaults.viewDefaults.textForTapShutterToScanHint;

  /// Use this property to access or modify the text of the hint which suggests to tap the shutter button.
  ///
  /// Default value is “Tap shutter to scan items”.
  ///
  /// Added in version 6.17.0
  String get textForTapShutterToScanHint => _textForTapShutterToScanHint;

  /// Use this property to access or modify the text of the hint which suggests to tap the shutter button.
  ///
  /// Default value is “Tap shutter to scan items”.
  ///
  /// Added in version 6.17.0
  set textForTapShutterToScanHint(String newValue) {
    _textForTapShutterToScanHint = newValue;
    _updateNative();
  }

  String _textForScanningHint = BarcodeCountDefaults.viewDefaults.textForScanningHint;

  /// Use this property to access or modify the text of the hint displayed while scanning is in progress.
  ///
  /// Default value is “Scanning”.
  ///
  /// Added in version 6.17.0
  String get textForScanningHint => _textForScanningHint;

  /// Use this property to access or modify the text of the hint displayed while scanning is in progress.
  ///
  /// Default value is “Scanning”.
  ///
  /// Added in version 6.17.0
  set textForScanningHint(String newValue) {
    _textForScanningHint = newValue;
    _updateNative();
  }

  String _textForMoveCloserAndRescanHint = BarcodeCountDefaults.viewDefaults.textForMoveCloserAndRescanHint;

  /// Use this property to access or modify the text of the hint displayed when camera should be moved closer to rescan.
  ///
  /// Default value is “Move closer and tap shutter”.
  ///
  /// Added in version 6.17.0
  String get textForMoveCloserAndRescanHint => _textForMoveCloserAndRescanHint;

  /// Use this property to access or modify the text of the hint displayed when camera should be moved closer to rescan.
  ///
  /// Default value is “Move closer and tap shutter”.
  ///
  /// Added in version 6.17.0
  set textForMoveCloserAndRescanHint(String newValue) {
    _textForMoveCloserAndRescanHint = newValue;
    _updateNative();
  }

  String _textForMoveFurtherAndRescanHint = BarcodeCountDefaults.viewDefaults.textForMoveFurtherAndRescanHint;

  /// Use this property to access or modify the text of the hint displayed when camera should be further away to rescan.
  ///
  /// Default value is “Step back and tap shutter”.
  ///
  /// Added in version 6.17.0
  String get textForMoveFurtherAndRescanHint => _textForMoveFurtherAndRescanHint;

  /// Use this property to access or modify the text of the hint displayed when camera should be further away to rescan.
  ///
  /// Default value is “Step back and tap shutter”.
  ///
  /// Added in version 6.17.0
  set textForMoveFurtherAndRescanHint(String newValue) {
    _textForMoveFurtherAndRescanHint = newValue;
    _updateNative();
  }

  String _textForBarcodesNotInListDetectedHint = BarcodeCountDefaults.viewDefaults.textForBarcodesNotInListDetectedHint;

  /// Use this property to access or modify the text of the hint displayed when a barcode not in list is scanned.
  ///
  /// Default value is “Wrong barcodes detected!”.
  ///
  /// Added in version 8.3.0
  String get textForBarcodesNotInListDetectedHint => _textForBarcodesNotInListDetectedHint;

  /// Use this property to access or modify the text of the hint displayed when a barcode not in list is scanned.
  ///
  /// Default value is “Wrong barcodes detected!”.
  ///
  /// Added in version 8.3.0
  set textForBarcodesNotInListDetectedHint(String newValue) {
    _textForBarcodesNotInListDetectedHint = newValue;
    _updateNative();
  }

  String _textForScreenCleanedUpHint = BarcodeCountDefaults.viewDefaults.textForScreenCleanedUpHint;

  /// Use this property to access or modify the text of the hint displayed when screen is cleaned.
  ///
  /// Default value is “Screen cleaned up. All items saved.”.
  ///
  /// Added in version 8.3.0
  String get textForScreenCleanedUpHint => _textForScreenCleanedUpHint;

  /// Use this property to access or modify the text of the hint displayed when screen is cleaned.
  ///
  /// Default value is “Screen cleaned up. All items saved.”.
  ///
  /// Added in version 8.3.0
  set textForScreenCleanedUpHint(String newValue) {
    _textForScreenCleanedUpHint = newValue;
    _updateNative();
  }

  String _textForClusteringGestureHint = BarcodeCountDefaults.viewDefaults.textForClusteringGestureHint;

  /// Use this property to access or modify the text of the hint that suggests the user to use gestures to form clusters. Shown only when [BarcodeCountSettings.clusteringMode] is [ClusteringMode.manual] or [ClusteringMode.autoWithManualCorrection].
  ///
  /// Default value is “Swipe or circle codes to group together.”.
  ///
  /// Added in version 8.3.0
  String get textForClusteringGestureHint => _textForClusteringGestureHint;

  /// Use this property to access or modify the text of the hint that suggests the user to use gestures to form clusters. Shown only when [BarcodeCountSettings.clusteringMode] is [ClusteringMode.manual] or [ClusteringMode.autoWithManualCorrection].
  ///
  /// Default value is “Swipe or circle codes to group together.”.
  ///
  /// Added in version 8.3.0
  set textForClusteringGestureHint(String newValue) {
    _textForClusteringGestureHint = newValue;
    _updateNative();
  }

  BarcodeCountToolbarSettings? _toolbarSettings;

  /// Pass an instance of [BarcodeCountToolbarSettings] to configure the text and accessibility options for the toolbar.
  ///
  /// Added in version 6.17.0
  Future<void> setToolbarSettings(BarcodeCountToolbarSettings settings) {
    _toolbarSettings = settings;
    return _updateNative();
  }

  bool _shouldShowListProgressBar = BarcodeCountDefaults.viewDefaults.shouldShowListProgressBar;

  /// When set to *true*, a progress bar will be shown to the user when a capture list has been set using [BarcodeCount.setBarcodeCountCaptureList], indicating how many of the barcodes in the list have been scanned.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.25.0
  bool get shouldShowListProgressBar => _shouldShowListProgressBar;

  /// When set to *true*, a progress bar will be shown to the user when a capture list has been set using [BarcodeCount.setBarcodeCountCaptureList], indicating how many of the barcodes in the list have been scanned.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 6.25.0
  set shouldShowListProgressBar(bool newValue) {
    _shouldShowListProgressBar = newValue;
    _updateNative();
  }

  bool _shouldShowTorchControl = BarcodeCountDefaults.viewDefaults.shouldShowTorchControl;

  /// Indicates whether the torch control button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.28.0
  bool get shouldShowTorchControl => _shouldShowTorchControl;

  /// Indicates whether the torch control button should be shown to the user.
  ///
  /// Default is *false*.
  ///
  /// Added in version 6.28.0
  set shouldShowTorchControl(bool newValue) {
    _shouldShowTorchControl = newValue;
    _updateNative();
  }

  Anchor _torchControlPosition = BarcodeCountDefaults.viewDefaults.torchControlPosition;

  /// Updates the position of the torch control button.
  ///
  /// Only [Anchor.topLeft], [Anchor.topRight], [Anchor.bottomLeft] and [Anchor.bottomRight], are supported.
  ///
  /// Any other value will default to [Anchor.topLeft].
  ///
  /// Added in version 6.28.0
  Anchor get torchControlPosition => _torchControlPosition;

  /// Updates the position of the torch control button.
  ///
  /// Only [Anchor.topLeft], [Anchor.topRight], [Anchor.bottomLeft] and [Anchor.bottomRight], are supported.
  ///
  /// Any other value will default to [Anchor.topLeft].
  ///
  /// Added in version 6.28.0
  set torchControlPosition(Anchor newValue) {
    _torchControlPosition = newValue;
    _updateNative();
  }

  bool _tapToUncountEnabled = BarcodeCountDefaults.viewDefaults.tapToUncountEnabled;

  /// Enables this feature to be able to deselect items by tapping on the highlights.
  ///
  /// Default value is *false*.
  ///
  /// Added in version 7.0.0
  bool get tapToUncountEnabled => _tapToUncountEnabled;

  /// Enables this feature to be able to deselect items by tapping on the highlights.
  ///
  /// Default value is *false*.
  ///
  /// Added in version 7.0.0
  set tapToUncountEnabled(bool newValue) {
    _tapToUncountEnabled = newValue;
    _updateNative();
  }

  String _textForTapToUncountHint = BarcodeCountDefaults.viewDefaults.textForTapToUncountHint;

  /// Text of the hint displayed when the user deselects an item.
  ///
  /// Default value is “Barcode removed”.
  ///
  /// Added in version 7.0.0
  String get textForTapToUncountHint => _textForTapToUncountHint;

  /// Text of the hint displayed when the user deselects an item.
  ///
  /// Default value is “Barcode removed”.
  ///
  /// Added in version 7.0.0
  set textForTapToUncountHint(String newValue) {
    _textForTapToUncountHint = newValue;
    _updateNative();
  }

  bool _shouldShowStatusModeButton = BarcodeCountDefaults.viewDefaults.shouldShowStatusModeButton;

  /// When set to *true*, a button will be shown to the user in the lower right corner of the preview. This button toggles “status mode”, in which the normal barcode highlights will be replaced by status indicators for each barcode.
  ///
  /// Added in version 7.0.0
  bool get shouldShowStatusModeButton => _shouldShowStatusModeButton;

  /// When set to *true*, a button will be shown to the user in the lower right corner of the preview. This button toggles “status mode”, in which the normal barcode highlights will be replaced by status indicators for each barcode.
  ///
  /// Added in version 7.0.0
  set shouldShowStatusModeButton(bool newValue) {
    _shouldShowStatusModeButton = newValue;
    _updateNative();
  }

  bool _shouldShowStatusIconsOnScan = BarcodeCountDefaults.viewDefaults.shouldShowStatusIconsOnScan;

  /// When enabled, status icons will be loaded immediately after barcodes are scanned, without requiring manual activation of status mode.
  ///
  /// Added in version 8.3.0
  bool get shouldShowStatusIconsOnScan => _shouldShowStatusIconsOnScan;

  /// When enabled, status icons will be loaded immediately after barcodes are scanned, without requiring manual activation of status mode.
  ///
  /// Added in version 8.3.0
  set shouldShowStatusIconsOnScan(bool newValue) {
    _shouldShowStatusIconsOnScan = newValue;
    _updateNative();
  }

  bool _shouldDisableModeOnExitButtonTapped = BarcodeCountDefaults.viewDefaults.shouldDisableModeOnExitButtonTapped;

  /// When set to *true*, the mode will disable automatically when the default exit button is tapped.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 8.3.0
  bool get shouldDisableModeOnExitButtonTapped => _shouldDisableModeOnExitButtonTapped;

  /// When set to *true*, the mode will disable automatically when the default exit button is tapped.
  ///
  /// By default this property is *true*.
  ///
  /// Added in version 8.3.0
  set shouldDisableModeOnExitButtonTapped(bool newValue) {
    _shouldDisableModeOnExitButtonTapped = newValue;
    _updateNative();
  }

  LogoStyle _logoStyle = BarcodeCountDefaults.viewDefaults.logoStyle;

  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.minimal].
  ///
  /// Added in version 8.5.0
  LogoStyle get logoStyle => _logoStyle;

  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.minimal].
  ///
  /// Added in version 8.5.0
  set logoStyle(LogoStyle newValue) {
    _logoStyle = newValue;
    _updateNative();
  }

  Anchor _logoAnchor = BarcodeCountDefaults.viewDefaults.logoAnchor;

  /// The anchor point used to position the Scandit logo.
  ///
  /// Default is [Anchor.bottomLeft].
  ///
  /// Added in version 8.5.0
  Anchor get logoAnchor => _logoAnchor;

  /// The anchor point used to position the Scandit logo.
  ///
  /// Default is [Anchor.bottomLeft].
  ///
  /// Added in version 8.5.0
  set logoAnchor(Anchor newValue) {
    _logoAnchor = newValue;
    _updateNative();
  }

  BarcodeCountStatusProvider? _statusProvider;

  /// Sets a [BarcodeCountStatusProvider] for this view. This provider will be queried when the “status mode” button is clicked.
  ///
  /// The Barcode Count status mode API is still in beta and may change in future versions of Scandit Data Capture SDK.
  ///
  /// Added in version 7.0.0
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
      'View': buildBarcodeCountView(
        style: _style.toString(),
        shouldShowUserGuidanceView: shouldShowUserGuidanceView,
        shouldShowListButton: shouldShowListButton,
        shouldShowExitButton: shouldShowExitButton,
        shouldShowShutterButton: shouldShowShutterButton,
        shouldShowHints: shouldShowHints,
        shouldShowClearHighlightsButton: shouldShowClearHighlightsButton,
        shouldShowSingleScanButton: shouldShowSingleScanButton,
        shouldShowFloatingShutterButton: shouldShowFloatingShutterButton,
        shouldShowToolbar: shouldShowToolbar,
        shouldShowStatusIconsOnScan: shouldShowStatusIconsOnScan,
        shouldDisableModeOnExitButtonTapped: shouldDisableModeOnExitButtonTapped,
        shouldShowScanAreaGuides: shouldShowScanAreaGuides,
        toolbarSettings: _toolbarSettings?.toMap(),
        shouldShowListProgressBar: shouldShowListProgressBar,
        shouldShowTorchControl: shouldShowTorchControl,
        torchControlPosition: torchControlPosition.toString(),
        tapToUncountEnabled: tapToUncountEnabled,
        textForTapToUncountHint: textForTapToUncountHint,
        shouldShowStatusModeButton: shouldShowStatusModeButton,
        hasStatusProvider: _statusProvider != null,
        hasListener: _barcodeCountViewListener != null,
        hasUiListener: _barcodeCountViewUiListener != null,
        viewId: _viewId,
      ),
      'BarcodeCount': _barcodeCount.toMap(),
    };

    // The `json['View'][...] = x` writes below stay OUTSIDE the builder on purpose,
    // and the golden key-set test uses `containsAll` rather than `equals` for the
    // same reason. Every key here IS a buildBarcodeCountView parameter, so the
    // obvious cleanup is to pass `differs-from-default ? value : null` inline and
    // let the omit-when-null rule reproduce the key set. That is safe for the ~30
    // accessibility/hint strings, which are non-nullable `String` (see the
    // declarations above: `set listButtonAccessibilityHint(String newValue)`), so
    // "differs from default" can never mean "is null".
    //
    // It is NOT safe for the nullable members of the same block --
    // `Brush? _recognizedBrush`, `BarcodeCountMappingFlowSettings?
    // _mappingFlowSettings`, `BarcodeFilterHighlightSettings? _filterSettings`.
    // For those, a value that differs from its default MAY be null, and the
    // conditional writes it as PRESENT-null today. Routing them through an
    // optional non-nullable builder parameter would omit the key instead --
    // precisely the present-null -> absent shift that produced the two regressions
    // earlier on this branch (`focusGesture: null` disabling the gesture, and the
    // iOS toolbar accessibility throw documented in the barcode-count drift suite).
    //
    // Splitting the block per-key by nullability is real work with a real
    // regression surface, so it is deliberately not bundled into this migration.
    // Do not "simplify" this wholesale without checking each key's nullability and
    // its native reader first.
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

    if (statusModeButtonAccessibilityHint != BarcodeCountDefaults.viewDefaults.statusModeButtonAccessibilityHint) {
      json['View']['statusModeButtonAccessibilityHint'] = statusModeButtonAccessibilityHint; // iOS Only
    }

    if (statusModeButtonAccessibilityLabel != BarcodeCountDefaults.viewDefaults.statusModeButtonAccessibilityLabel) {
      json['View']['statusModeButtonAccessibilityLabel'] = statusModeButtonAccessibilityLabel; // iOS Only
    }

    if (statusModeButtonContentDescription != BarcodeCountDefaults.viewDefaults.statusModeButtonContentDescription) {
      json['View']['statusModeButtonContentDescription'] = statusModeButtonContentDescription; // Android Only
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
    if (textForBarcodesNotInListDetectedHint !=
        BarcodeCountDefaults.viewDefaults.textForBarcodesNotInListDetectedHint) {
      json['View']['textForBarcodesNotInListDetectedHint'] = textForBarcodesNotInListDetectedHint;
    }
    if (textForScreenCleanedUpHint != BarcodeCountDefaults.viewDefaults.textForScreenCleanedUpHint) {
      json['View']['textForScreenCleanedUpHint'] = textForScreenCleanedUpHint;
    }
    if (textForClusteringGestureHint != BarcodeCountDefaults.viewDefaults.textForClusteringGestureHint) {
      json['View']['textForClusteringGestureHint'] = textForClusteringGestureHint;
    }
    if (recognizedBrush != null) {
      json['View']['recognizedBrush'] = recognizedBrush?.toMap();
    }
    if (notInListBrush != null) {
      json['View']['notInListBrush'] = notInListBrush?.toMap();
    }
    if (acceptedBrush != null) {
      json['View']['acceptedBrush'] = acceptedBrush?.toMap();
    }
    if (rejectedBrush != null) {
      json['View']['rejectedBrush'] = rejectedBrush?.toMap();
    }
    if (filterSettings != null) {
      json['View']['filterSettings'] = filterSettings?.toMap();
    }

    if (hardwareTriggerSupported != BarcodeCountDefaults.viewDefaults.hardwareTriggerSupported) {
      json['View']['hardwareTriggerSupported'] = hardwareTriggerSupported;
    }
    if (_mappingFlowSettings != null) {
      json['View']['mappingFlowSettings'] = _mappingFlowSettings?.toMap();
    }

    json['View']['barcodeNotInListActionSettings'] = _barcodeNotInListActionSettings.toMap();
    json['View']['hardwareTriggerEnabled'] = _hardwareTriggerEnabled;
    json['View']['logoStyle'] = _logoStyle.toString();
    json['View']['logoAnchor'] = _logoAnchor.toString();

    return json;
  }
}

/// Barcode Count is a data capture mode that implements MatrixScan Count in use cases that include a counting workflow such as receiving, inventory count, and stock taking. MatrixScan Count is an out-of-the-box scan and count solution that enables faster and more accurate counting of multiple items at once.
///
/// Learn more on how to use Barcode Count in our [Get Started](https://docs.scandit.com/sdks/flutter/matrixscan-count/get-started) guide.
///
/// Added in version 6.17.0
class BarcodeCount extends DataCaptureMode {
  BarcodeCountFeedback _feedback = BarcodeCountFeedback.defaultFeedback;
  VoidCallback? _feedbackListener;

  bool _enabled = true;
  BarcodeCountSettings _settings;
  final List<BarcodeCountListener> _listeners = [];
  final List<AdaptiveRecognitionServiceListener> _areListeners = [];
  _BarcodeCountViewController? _controller;

  // Pending capture list to be set when controller is ready
  BarcodeCountCaptureList? _pendingCaptureList;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.context].
  ///
  /// Added in version 6.17.0
  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 6.17.0
  @override
  bool get isEnabled => _enabled;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 6.17.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller?.setModeEnabledState(newValue);
  }

  /// Instance of [BarcodeCountFeedback] that is used by the barcode scanner to notify users about Success and Failure events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// Added in version 6.17.0
  BarcodeCountFeedback get feedback => _feedback;

  /// Instance of [BarcodeCountFeedback] that is used by the barcode scanner to notify users about Success and Failure events.
  ///
  /// The default instance of the Feedback will have both sound and vibration enabled. A default beep sound will be used for the sound.
  ///
  /// Added in version 6.17.0
  set feedback(BarcodeCountFeedback newValue) {
    if (_feedback == newValue) {
      return;
    }
    _removeFeedbackListener();
    _feedback = newValue;
    _addFeedbackListener();
    _controller?.updateFeedback();
  }

  /// Returns the recommended camera settings for use with barcode count.
  ///
  /// Added in version 7.6.0
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
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  BarcodeCount._(this._settings) {
    _addFeedbackListener();
  }

  /// Constructs a new BarcodeCount instance with the provided settings.
  ///
  /// Added in version 7.6.0
  BarcodeCount(BarcodeCountSettings settings) : this._(settings);

  void _addFeedbackListener() {
    _feedbackListener = () {
      _controller?.updateFeedback();
    };
    _feedback.addListener(_feedbackListener!);
  }

  void _removeFeedbackListener() {
    if (_feedbackListener != null) {
      _feedback.removeListener(_feedbackListener!);
      _feedbackListener = null;
    }
  }

  /// Asynchronously applies the new settings to the barcode scanner, then calls whenDone. If the scanner is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If the scanner is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// Added in version 6.17.0
  Future<void> applySettings(BarcodeCountSettings settings) {
    _settings = settings;
    return didChange();
  }

  /// Adds the listener to observe this barcode capture instance.
  ///
  /// If the listener is already observing the barcode count instance, calling this method has no effect.
  ///
  /// Added in version 6.17.0
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

  /// Removes a previously added listener from this barcode count instance.
  ///
  /// If the listener is not currently observing the barcode count instance, calling this method has no effect.
  ///
  /// Added in version 6.17.0
  void removeListener(BarcodeCountListener listener) {
    _listeners.remove(listener);
    _checkAndUnsubscribeListeners();
  }

  void _checkAndUnsubscribeListeners() {
    if (_listeners.isEmpty) {
      _controller?.unsubscribeModeListeners();
    }
  }

  /// Adds the listener to observe the outcome of adaptive recognition dispatches performed by this mode’s adaptive recognition service. See [AdaptiveRecognitionServiceListener].
  ///
  /// Added in version 8.7.0
  void addAdaptiveRecognitionServiceListener(AdaptiveRecognitionServiceListener listener) {
    if (!_areListeners.contains(listener)) {
      _areListeners.add(listener);
    }
    // On every add, not only the first: the controller skips it when already subscribed, so a
    // native registration that failed earlier is retried here.
    _controller?.subscribeAreListeners();
  }

  /// Removes a previously added adaptive recognition service listener from this barcode count instance.
  ///
  /// Added in version 8.7.0
  void removeAdaptiveRecognitionServiceListener(AdaptiveRecognitionServiceListener listener) {
    _areListeners.remove(listener);
    _checkAndUnsubscribeAreListeners();
  }

  void _checkAndUnsubscribeAreListeners() {
    if (_areListeners.isEmpty) {
      _controller?.unsubscribeAreListeners();
    }
  }

  Future<void> didChange() {
    return _controller?.updateMode() ?? Future.value();
  }

  /// Resets the session, effectively clearing the history of tracked and unscanned barcodes.
  ///
  /// Added in version 6.17.0
  Future<void> reset() {
    return _controller?.reset() ?? Future.value();
  }

  /// Starts the capture session. If the [BarcodeCount.isEnabled] is false, this call has no effect.
  ///
  /// Added in version 6.17.0
  Future<void> startScanningPhase() {
    return _controller?.startScanningPhase() ?? Future.value();
  }

  /// Disables this mode and switches off the current [FrameSource].
  ///
  /// Added in version 6.17.0
  Future<void> endScanningPhase() {
    return _controller?.endScanningPhase() ?? Future.value();
  }

  /// Enables “Scanning against a list” mode, which provides additional functionality when looking for a specific set of Barcodes.
  ///
  /// Added in version 6.17.0
  Future<void> setBarcodeCountCaptureList(BarcodeCountCaptureList list) {
    final controller = _controller;
    if (controller != null) {
      return controller.setBarcodeCountCaptureList(list);
    }
    _pendingCaptureList = list;
    return Future.value();
  }

  List<Barcode> _additionalBarcodes = [];

  /// Use this method to inject barcodes that will be used as partial scanning result. [BarcodeCountView] will consider these barcodes when updating the UI. Note that, if scanning against a list where multiple instances of the same barcode are expected, each entry in this list will only count as 1 towards the expected total. In order to specify that several instances of a barcode were scanned in previous sessions, this list should include one entry per each of those instances.
  ///
  /// Added in version 6.17.0
  Future<void> setAdditionalBarcodes(List<Barcode> barcodes) {
    _additionalBarcodes = barcodes;
    return didChange();
  }

  /// Clears the additional barcodes.
  ///
  /// Added in version 6.17.0
  Future<void> clearAdditionalBarcodes() {
    _additionalBarcodes = [];
    return didChange();
  }

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodeCount(
      type: 'barcodeCount',
      feedback: _feedback.toMap(),
      settings: _settings.toMap(),
      additionalBarcodes: _additionalBarcodes.map((e) => e.toMap()).toList(growable: false),
      hasListeners: _listeners.isNotEmpty,
      isEnabled: _enabled,
    );
  }
}

/// Component for [BarcodeCount] that allows it to scan against a list of expected barcodes.
///
/// Added in version 6.17.0
class BarcodeCountCaptureList {
  final BarcodeCountCaptureListListener _listener;
  final List<TargetBarcode> _targetBarcodes;
  BarcodeDataTransformer? _barcodeDataTransformer;

  BarcodeCountCaptureList._(this._listener, this._targetBarcodes);

  /// Constructs a new capture list component and sets an initial list of target barcodes to search for. This list may be null.
  ///
  /// Added in version 6.17.0
  factory BarcodeCountCaptureList.create(BarcodeCountCaptureListListener listener, List<TargetBarcode> targetBarcodes) {
    return BarcodeCountCaptureList._(listener, targetBarcodes);
  }

  /// Sets a barcode data transformer for this instance of BarcodeCountCaptureList. The transformer will be applied to transform the barcode data before matching to the target barcodes.
  ///
  /// Added in version 8.3.0
  void setBarcodeDataTransformer(BarcodeDataTransformer? transformer) {
    _barcodeDataTransformer = transformer;
  }
}

class _BarcodeCountViewController extends BaseController {
  StreamSubscription<dynamic>? _viewEventsSubscription;
  late final BarcodeMethodHandler barcodeMethodHandler;

  final BarcodeCountView view;

  _BarcodeCountViewController(this.view) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
    _initialize();
  }

  void _initialize() {
    if (view._barcodeCount._listeners.isNotEmpty) {
      subscribeModeListeners();
    }
    if (view._barcodeCount._areListeners.isNotEmpty) {
      subscribeAreListeners();
    }
    _subscribeToEvents();
    // A listener assigned to the view before the platform view (and therefore this
    // controller) existed was stored on the widget but never registered with native,
    // because the `listener`/`uiListener` setters no-op while `_controller` is null.
    // Re-apply them now so the native delegate is actually attached.
    if (view._barcodeCountViewListener != null) {
      setListener(view._barcodeCountViewListener);
    }
    if (view._barcodeCountViewUiListener != null) {
      setUiListener(view._barcodeCountViewUiListener);
    }
  }

  void setUiListener(BarcodeCountViewUiListener? listener) {
    if (listener != null) {
      ListenerRegistry.instance
          .addListeners(_barcodeCountViewUiListenerEvents, ListenerTarget.view(view._viewId), this);
    } else {
      ListenerRegistry.instance
          .removeListeners(_barcodeCountViewUiListenerEvents, ListenerTarget.view(view._viewId), this);
    }
  }

  void _subscribeToEvents() {
    if (_viewEventsSubscription != null) return;

    _viewEventsSubscription = BarcodePluginEvents.barcodeCountEventStream.forView(view._viewId).listen((event) {
      if (event.isEvent(BarcodeCountViewListener._brushForRecognizedBarcodeEventName)) {
        _handleBrushForRecognizedBarcodeEvent(event.payload);
      } else if (event.isEvent(BarcodeCountViewListener._brushForRecognizedBarcodeNotInListEventName)) {
        _handleBrushForRecognizedBarcodeNotInListEvent(event.payload);
      } else if (event.isEvent(BarcodeCountViewExtendedListener._iconForRecognizedBarcodeEventName)) {
        _handleIconForRecognizedBarcodeEvent(event.payload);
      } else if (event.isEvent(BarcodeCountViewExtendedListener._iconForRecognizedBarcodeNotInListEventName)) {
        _handleIconForRecognizedBarcodeNotInListEvent(event.payload);
      } else if (event.isEvent(BarcodeCountViewExtendedListener._iconForAcceptedBarcodeEventName)) {
        _handleIconForAcceptedBarcodeEvent(event.payload);
      } else if (event.isEvent(BarcodeCountViewExtendedListener._iconForRejectedBarcodeEventName)) {
        _handleIconForRejectedBarcodeEvent(event.payload);
      } else if (event.isEvent(BarcodeCountViewListener._didTapFilteredBarcodeEventName)) {
        final payload = BarcodeCountViewListenerDidTapFilteredBarcode.fromJson(event.payload);
        view.listener?.didTapFilteredBarcode(view, TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode)));
      } else if (event.isEvent(BarcodeCountViewListener._didTapRecognizedBarcodeEventName)) {
        final payload = BarcodeCountViewListenerDidTapRecognizedBarcode.fromJson(event.payload);
        view.listener?.didTapRecognizedBarcode(
          view,
          TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode)),
        );
      } else if (event.isEvent(BarcodeCountViewListener._didTapRecognizedBarcodeNotInListEventName)) {
        final payload = BarcodeCountViewListenerDidTapRecognizedBarcodeNotInList.fromJson(event.payload);
        view.listener?.didTapRecognizedBarcodeNotInList(
          view,
          TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode)),
        );
      } else if (event.isEvent(BarcodeCountViewListener._didCompleteCaptureListEventName)) {
        BarcodeCountViewListenerDidCompleteCaptureList.fromJson(event.payload);
        view.listener?.didCompleteCaptureList(view);
      } else if (event.isEvent(BarcodeCountViewExtendedListener._didTapClusterEventName)) {
        if (view.listener is BarcodeCountViewExtendedListener) {
          final payload = BarcodeCountViewListenerDidTapCluster.fromJson(event.payload);
          (view.listener as BarcodeCountViewExtendedListener).didTapCluster(
            view,
            Cluster.fromJSON({'barcodes': payload.barcodes}),
          );
        }
      } else if (event.isEvent(BarcodeCountViewUiListener._onExitButtonTappedEventName)) {
        final payload = BarcodeCountViewUiListenerOnExitButtonTapped.fromJson(event.payload);
        final listener = view.uiListener;
        if (listener is BarcodeCountViewUiExtendedListener) {
          listener.didTapExitButtonWithSnapshot(view, _parseBarcodeCountSessionSnapshot(payload.snapshot));
        } else {
          // ignore: deprecated_member_use_from_same_package
          listener?.didTapExitButton(view);
        }
      } else if (event.isEvent(BarcodeCountViewUiListener._onListButtonTappedEventName)) {
        final payload = BarcodeCountViewUiListenerOnListButtonTapped.fromJson(event.payload);
        final listener = view.uiListener;
        if (listener is BarcodeCountViewUiExtendedListener) {
          listener.didTapListButtonWithSnapshot(view, _parseBarcodeCountSessionSnapshot(payload.snapshot));
        } else {
          // ignore: deprecated_member_use_from_same_package
          listener?.didTapListButton(view);
        }
      } else if (event.isEvent(BarcodeCountViewUiListener._onSingleScanButtonTappedEventName)) {
        BarcodeCountViewUiListenerOnSingleScanButtonTapped.fromJson(event.payload);
        view.uiListener?.didTapSingleScanButton(view);
      } else if (event.isEvent(BarcodeCountStatusProvider._onStatusRequestedEventName)) {
        _handleOnStatusRequestedEvent(event.payload);
      }
    });
  }

  void _handleOnStatusRequestedEvent(Map<String, dynamic> json) {
    final request = BarcodeCountStatusProviderRequest.fromJSON(json);

    view._statusProvider?.onStatusRequested(request.barcodes, BarcodeCountStatusProviderCallback._(this, request.id));
  }

  Future<void> submitBarcodeCountStatusProviderCallback(BarcodeCountStatusResult statusResult, String requestId) {
    final result = BarcodeCountStatusProviderResult.create(requestId, statusResult);
    return barcodeMethodHandler
        .submitBarcodeCountStatusProviderCallback(viewId: view._viewId, statusJson: jsonEncode(result.toMap()))
        .onError(onError);
  }

  Future<void> addBarcodeCountStatusProvider() {
    return barcodeMethodHandler.addBarcodeCountStatusProvider(viewId: view._viewId).onError(onError);
  }

  void _handleBrushForRecognizedBarcodeEvent(dynamic json) {
    var payload = BarcodeCountViewListenerBrushForRecognizedBarcode.fromJson(json);
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
    var brush = view.listener?.brushForRecognizedBarcode(view, trackedBarcode);

    barcodeMethodHandler.finishBarcodeCountBrushForRecognizedBarcode(
        viewId: view._viewId,
        trackedBarcodeId: trackedBarcode.identifier,
        brushJson: brush?.toMap() != null ? jsonEncode(brush?.toMap()) : null);
  }

  void _handleBrushForRecognizedBarcodeNotInListEvent(dynamic json) {
    var payload = BarcodeCountViewListenerBrushForRecognizedBarcodeNotInList.fromJson(json);
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
    var brush = view.listener?.brushForRecognizedBarcodeNotInList(view, trackedBarcode);

    barcodeMethodHandler.finishBarcodeCountBrushForRecognizedBarcodeNotInList(
        viewId: view._viewId,
        trackedBarcodeId: trackedBarcode.identifier,
        brushJson: brush?.toMap() != null ? jsonEncode(brush?.toMap()) : null);
  }

  // A null icon must cross the bridge as a null iconJson, so the generated handler omits the key.
  // Encoding it directly would send jsonEncode(null), i.e. the string "null" — the trap the brush
  // setters below still fall into. Every icon call site goes through here so there is one place to
  // get this right.
  static String? _encodeIcon(BarcodeCountIcon? icon) {
    return icon == null ? null : jsonEncode(icon.toMap());
  }

  // Icon callbacks live on the opt-in BarcodeCountViewExtendedListener. When the registered
  // listener does not implement it, the SDK default icon is returned so the native highlight is
  // unchanged for plain BarcodeCountViewListener consumers.
  void _handleIconForRecognizedBarcodeEvent(dynamic json) {
    var payload = BarcodeCountViewListenerIconForRecognizedBarcode.fromJson(json);
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
    var listener = view.listener;
    var icon = listener is BarcodeCountViewExtendedListener
        ? listener.iconForRecognizedBarcode(view, trackedBarcode)
        : BarcodeCountView.defaultRecognizedIcon;

    barcodeMethodHandler.finishBarcodeCountIconForRecognizedBarcode(
        viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon));
  }

  void _handleIconForRecognizedBarcodeNotInListEvent(dynamic json) {
    var payload = BarcodeCountViewListenerIconForRecognizedBarcodeNotInList.fromJson(json);
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
    var listener = view.listener;
    var icon = listener is BarcodeCountViewExtendedListener
        ? listener.iconForRecognizedBarcodeNotInList(view, trackedBarcode)
        : BarcodeCountView.defaultNotInListIcon;

    barcodeMethodHandler.finishBarcodeCountIconForRecognizedBarcodeNotInList(
        viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon));
  }

  void _handleIconForAcceptedBarcodeEvent(dynamic json) {
    var payload = BarcodeCountViewListenerIconForAcceptedBarcode.fromJson(json);
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
    var listener = view.listener;
    var icon = listener is BarcodeCountViewExtendedListener
        ? listener.iconForAcceptedBarcode(view, trackedBarcode)
        : BarcodeCountView.defaultAcceptedIcon;

    barcodeMethodHandler.finishBarcodeCountIconForAcceptedBarcode(
        viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon));
  }

  void _handleIconForRejectedBarcodeEvent(dynamic json) {
    var payload = BarcodeCountViewListenerIconForRejectedBarcode.fromJson(json);
    var trackedBarcode = TrackedBarcode.fromJSON(jsonDecode(payload.trackedBarcode));
    var listener = view.listener;
    var icon = listener is BarcodeCountViewExtendedListener
        ? listener.iconForRejectedBarcode(view, trackedBarcode)
        : BarcodeCountView.defaultRejectedIcon;

    barcodeMethodHandler.finishBarcodeCountIconForRejectedBarcode(
        viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon));
  }

  Future<void> clearHighlights() {
    return barcodeMethodHandler.clearBarcodeCountHighlights(viewId: view._viewId).onError(onError);
  }

  Future<void> setBrushForRecognizedBarcode(TrackedBarcode trackedBarcode, Brush? brush) {
    return barcodeMethodHandler
        .finishBarcodeCountBrushForRecognizedBarcode(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, brushJson: jsonEncode(brush?.toMap()))
        .onError(onError);
  }

  Future<void> setBrushForRecognizedBarcodeNotInList(TrackedBarcode trackedBarcode, Brush? brush) {
    return barcodeMethodHandler
        .finishBarcodeCountBrushForRecognizedBarcodeNotInList(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, brushJson: jsonEncode(brush?.toMap()))
        .onError(onError);
  }

  Future<void> setBrushForAcceptedBarcode(TrackedBarcode trackedBarcode, Brush? brush) {
    return barcodeMethodHandler
        .finishBarcodeCountBrushForAcceptedBarcode(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, brushJson: jsonEncode(brush?.toMap()))
        .onError(onError);
  }

  Future<void> setBrushForRejectedBarcode(TrackedBarcode trackedBarcode, Brush? brush) {
    return barcodeMethodHandler
        .finishBarcodeCountBrushForRejectedBarcode(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, brushJson: jsonEncode(brush?.toMap()))
        .onError(onError);
  }

  Future<void> setIconForRecognizedBarcode(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return barcodeMethodHandler
        .finishBarcodeCountIconForRecognizedBarcode(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon))
        .onError(onError);
  }

  Future<void> setIconForRecognizedBarcodeNotInList(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return barcodeMethodHandler
        .finishBarcodeCountIconForRecognizedBarcodeNotInList(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon))
        .onError(onError);
  }

  Future<void> setIconForAcceptedBarcode(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return barcodeMethodHandler
        .finishBarcodeCountIconForAcceptedBarcode(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon))
        .onError(onError);
  }

  Future<void> setIconForRejectedBarcode(TrackedBarcode trackedBarcode, BarcodeCountIcon? icon) {
    return barcodeMethodHandler
        .finishBarcodeCountIconForRejectedBarcode(
            viewId: view._viewId, trackedBarcodeId: trackedBarcode.identifier, iconJson: _encodeIcon(icon))
        .onError(onError);
  }

  Future<void> enableHardwareTrigger(int? hardwareTriggerKeyCode) {
    return barcodeMethodHandler
        .enableBarcodeCountHardwareTrigger(viewId: view._viewId, hardwareTriggerKeyCode: hardwareTriggerKeyCode)
        .onError(onError);
  }

  void setListener(BarcodeCountViewListener? listener) {
    if (listener != null) {
      barcodeMethodHandler.registerBarcodeCountViewListener(viewId: view._viewId).onError(onError);
    } else {
      barcodeMethodHandler.unregisterBarcodeCountViewListener(viewId: view._viewId).onError(onError);
    }
  }

  Future<void> updateView() {
    return barcodeMethodHandler
        .updateBarcodeCountView(viewId: view._viewId, viewJson: jsonEncode(view.toMap()['View']))
        .onError(onError);
  }

  StreamSubscription<dynamic>? _streamModeSubscription;
  BarcodeCountCaptureList? _barcodeCountCaptureList;

  void subscribeModeListeners() {
    barcodeMethodHandler
        .registerBarcodeCountListener(viewId: view._viewId)
        .then((value) => _setupBarcodeCountSubscription())
        .onError(onError);
  }

  void _setupBarcodeCountSubscription() {
    _streamModeSubscription = BarcodePluginEvents.barcodeCountEventStream.forView(view._viewId).listen((event) async {
      if (event.isEvent('BarcodeCountListener.onScan')) {
        // Schema assertion only: the result is intentionally discarded. It flags a
        // payload that does not match barcode_count_listener_on_scan.json. `session`
        // is a serialized JSON string inside the payload, so BarcodeCountSession does
        // the actual decoding — this call guards the envelope, not the session body.
        // A mismatch is logged rather than thrown: onScan blocks the native scanning
        // thread until finishBarcodeCountOnScan arrives, so validation must never cost
        // the ack.
        try {
          BarcodeCountListenerOnScan.fromJson(event.payload);
        } catch (e) {
          dev.log('BarcodeCountListener.onScan payload failed schema validation: $e');
        }
        try {
          var session = BarcodeCountSession.fromJSON(event.payload);
          if (session.recognizedClusters.isNotEmpty) {
            dev.log(
                'BarcodeCountListener.onScan: ${session.recognizedClusters.map((e) => jsonEncode(e.toMap())).toList()}');
          }
          await _notifyListenersOfOnScan(session);
        } finally {
          barcodeMethodHandler
              .finishBarcodeCountOnScan(
                viewId: view._viewId,
              )
              .onError(onError);
        }
      } else if (event.isEvent('BarcodeCountListener.didUpdateSession')) {
        // Schema assertion only — see the note on the onScan branch above.
        try {
          BarcodeCountListenerDidUpdateSession.fromJson(event.payload);
        } catch (e) {
          dev.log('BarcodeCountListener.didUpdateSession payload failed schema validation: $e');
        }
        try {
          var session = BarcodeCountSession.fromJSON(event.payload);
          _notifyListenersOfOnSessionUpdated(session);
        } finally {
          barcodeMethodHandler
              .finishBarcodeCountOnSessionUpdated(
                viewId: view._viewId,
              )
              .onError(onError);
        }
      } else if (event.isEvent('BarcodeCountCaptureListListener.didUpdateSession')) {
        final payload = BarcodeCountCaptureListListenerDidUpdateSession.fromJson(event.payload);
        var session = BarcodeCountCaptureListSession.fromJSON(jsonDecode(payload.session));
        _notifyBarcodeCountCaptureList(session);
      } else if (event.isEvent('BarcodeCountCaptureListListener.didCompleteCaptureList')) {
        final payload = BarcodeCountCaptureListListenerDidCompleteCaptureList.fromJson(event.payload);
        var session = BarcodeCountCaptureListSession.fromJSON(jsonDecode(payload.session));
        _notifyBarcodeCountCaptureListCompleted(session);
      } else if (event.isEvent('BarcodeDataTransformer.transformBarcodeData')) {
        var data = event.payload['data'] as String?;
        var transformedData = _transformBarcodeData(data);
        barcodeMethodHandler
            .submitBarcodeDataTransformerResult(viewId: view._viewId, transformedData: transformedData)
            .onError(onError);
      }
    });
  }

  void unsubscribeModeListeners() {
    _streamModeSubscription?.cancel();
    _streamModeSubscription = null;
    barcodeMethodHandler.unregisterBarcodeCountListener(viewId: view._viewId).onError(onError);
  }

  StreamSubscription<dynamic>? _streamAreSubscription;

  // Bumped by both subscribeAreListeners and unsubscribeAreListeners. registerBarcodeCount
  // AdaptiveRecognitionServiceListener is async, so a remove/dispose issued before it resolves
  // would otherwise still set up _streamAreSubscription in the pending `.then()` callback below,
  // after the very unsubscribe that was meant to tear it down - leaving a live subscription with
  // no matching native registration. The `.then()` callback only attaches the subscription when
  // the generation it captured is still current.
  int _areRegistrationGeneration = 0;
  bool _isAreSubscribed = false;
  bool _isAreSubscribing = false;

  void subscribeAreListeners() {
    if (_isAreSubscribed || _isAreSubscribing) {
      return;
    }
    _isAreSubscribing = true;
    final generation = ++_areRegistrationGeneration;
    barcodeMethodHandler
        .registerBarcodeCountAdaptiveRecognitionServiceListener(viewId: view._viewId)
        .then<void>((value) {
      if (generation != _areRegistrationGeneration) {
        // A newer subscribeAreListeners/unsubscribeAreListeners call ran while this native
        // call was in flight; this registration is stale, so do not attach a subscription.
        return;
      }
      _isAreSubscribing = false;
      _isAreSubscribed = true;
      _setupAreSubscription();
    }).onError((Object error, StackTrace stackTrace) {
      if (generation == _areRegistrationGeneration) {
        // Not subscribed, so the next addAdaptiveRecognitionServiceListener retries.
        _isAreSubscribing = false;
      }
      // Logged rather than passed to onError, which rethrows: the failure is recoverable by
      // the retry above, matching jsmobile.
      dev.log('BarcodeCount adaptive recognition registration failed: $error');
    });
  }

  void _setupAreSubscription() {
    _streamAreSubscription = BarcodePluginEvents.barcodeCountEventStream.forView(view._viewId).listen((event) {
      if (event.isEvent('BarcodeCountAdaptiveRecognitionListener.dispatchStarted')) {
        unawaited(_processAreDispatchStarted(event.payload));
      } else if (event.isEvent('BarcodeCountAdaptiveRecognitionListener.response')) {
        unawaited(_processAreResponse(event.payload));
      } else if (event.isEvent('BarcodeCountAdaptiveRecognitionListener.error')) {
        unawaited(_processAreError(event.payload));
      }
    });
  }

  void unsubscribeAreListeners() {
    _areRegistrationGeneration++;
    _isAreSubscribing = false;
    _isAreSubscribed = false;
    _streamAreSubscription?.cancel();
    _streamAreSubscription = null;
    barcodeMethodHandler
        .unregisterBarcodeCountAdaptiveRecognitionServiceListener(viewId: view._viewId)
        .onError(onError);
  }

  // Fire-and-forget: unlike onScan/didUpdateSession above, native does not block on a reply for
  // these callbacks, so there is no finishXxx ack call here.
  Future<void> _processAreDispatchStarted(Map<String, dynamic> raw) async {
    BarcodeCountAdaptiveRecognitionListenerDispatchStarted payload;
    try {
      payload = BarcodeCountAdaptiveRecognitionListenerDispatchStarted.fromJson(raw);
    } catch (error) {
      dev.log('BarcodeCount dispatchStarted payload failed schema validation: $error');
      return;
    }
    final frameMetadata = AdaptiveRecognitionFrameMetadata.fromJSON(payload.frameMetadata.toJson());
    for (final listener in view._barcodeCount._areListeners.toList()) {
      try {
        listener.onAdaptiveRecognitionServiceDispatchStarted(
          () => _getAreFrameData(payload.frameDataId),
          frameMetadata,
        );
      } catch (error) {
        dev.log('BarcodeCount dispatchStarted listener threw: $error');
      }
    }
  }

  Future<void> _processAreResponse(Map<String, dynamic> raw) async {
    BarcodeCountAdaptiveRecognitionListenerResponse payload;
    try {
      payload = BarcodeCountAdaptiveRecognitionListenerResponse.fromJson(raw);
    } catch (error) {
      dev.log('BarcodeCount response payload failed schema validation: $error');
      return;
    }
    final frameMetadata = AdaptiveRecognitionFrameMetadata.fromJSON(payload.frameMetadata.toJson());
    for (final listener in view._barcodeCount._areListeners.toList()) {
      try {
        listener.onAdaptiveRecognitionServiceResponse(payload.response, frameMetadata);
      } catch (error) {
        dev.log('BarcodeCount response listener threw: $error');
      }
    }
  }

  Future<void> _processAreError(Map<String, dynamic> raw) async {
    BarcodeCountAdaptiveRecognitionListenerError payload;
    try {
      payload = BarcodeCountAdaptiveRecognitionListenerError.fromJson(raw);
    } catch (error) {
      dev.log('BarcodeCount error payload failed schema validation: $error');
      return;
    }
    final frameMetadata = AdaptiveRecognitionFrameMetadata.fromJSON(payload.frameMetadata.toJson());
    final reason = AdaptiveRecognitionErrorReason.fromJSON(payload.reason);
    for (final listener in view._barcodeCount._areListeners.toList()) {
      try {
        listener.onAdaptiveRecognitionServiceError(reason, frameMetadata);
      } catch (error) {
        dev.log('BarcodeCount error listener threw: $error');
      }
    }
  }

  // Best effort: the frame may already be evicted from the native cache, in which case this
  // resolves null rather than the onScan/didUpdateSession getters' non-null placeholder.
  Future<FrameData?> _getAreFrameData(String frameDataId) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: frameDataId)
        .then((value) => value == null ? null : DefaultFrameData.fromJSON(value), onError: onError);
  }

  Future<void> reset() {
    return barcodeMethodHandler.resetBarcodeCount(viewId: view._viewId).onError(onError);
  }

  Future<void> startScanningPhase() {
    return barcodeMethodHandler.startBarcodeCountScanningPhase(viewId: view._viewId).onError(onError);
  }

  Future<void> endScanningPhase() {
    return barcodeMethodHandler.endBarcodeCountScanningPhase(viewId: view._viewId).onError(onError);
  }

  Future<void> setBarcodeCountCaptureList(BarcodeCountCaptureList list) {
    _barcodeCountCaptureList = list;
    return barcodeMethodHandler
        .setBarcodeCountCaptureList(
            viewId: view._viewId,
            captureListJson: jsonEncode(list._targetBarcodes.map((e) => e.toMap()).toList()),
            hasTransformer: list._barcodeDataTransformer != null)
        .onError(onError);
  }

  Future<FrameData> _getLastFrameData(BarcodeCountSession session) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: onError);
  }

  Future<void> updateMode() {
    return barcodeMethodHandler
        .updateBarcodeCountMode(viewId: view._viewId, barcodeCountJson: jsonEncode(view._barcodeCount.toMap()))
        .onError(onError);
  }

  Future<void> updateFeedback() {
    return barcodeMethodHandler
        .updateBarcodeCountFeedback(viewId: view._viewId, feedbackJson: jsonEncode(view._barcodeCount.feedback.toMap()))
        .onError(onError);
  }

  void setModeEnabledState(bool newValue) {
    barcodeMethodHandler.setBarcodeCountModeEnabledState(viewId: view._viewId, isEnabled: newValue).onError(onError);
  }

  Future<void> _notifyListenersOfOnScan(BarcodeCountSession session) async {
    for (var listener in view._barcodeCount._listeners.toList()) {
      await listener.didScan(view._barcodeCount, session, () => _getLastFrameData(session));
    }
  }

  void _notifyListenersOfOnSessionUpdated(BarcodeCountSession session) {
    for (var listener in view._barcodeCount._listeners.toList()) {
      if (listener is BarcodeCountExtendedListener) {
        listener.didUpdateSession(view._barcodeCount, session, () => _getLastFrameData(session));
      }
    }
  }

  void _notifyBarcodeCountCaptureList(BarcodeCountCaptureListSession session) {
    var barcodeCountCaptureList = _barcodeCountCaptureList;
    if (barcodeCountCaptureList != null) {
      _barcodeCountCaptureList?._listener.didUpdateSession(barcodeCountCaptureList, session);
    }
  }

  void _notifyBarcodeCountCaptureListCompleted(BarcodeCountCaptureListSession session) {
    var barcodeCountCaptureList = _barcodeCountCaptureList;
    if (barcodeCountCaptureList != null &&
        _barcodeCountCaptureList?._listener is BarcodeCountCaptureListExtendedListener) {
      (_barcodeCountCaptureList!._listener as BarcodeCountCaptureListExtendedListener)
          .didCompleteCaptureList(barcodeCountCaptureList, session);
    }
  }

  String? _transformBarcodeData(String? data) {
    var barcodeCountCaptureList = _barcodeCountCaptureList;
    var transformer = barcodeCountCaptureList?._barcodeDataTransformer;
    if (transformer != null) {
      return transformer.transformBarcodeData(data);
    }
    return data;
  }

  @override
  void dispose() {
    unsubscribeModeListeners();
    unsubscribeAreListeners();
    if (view._barcodeCountViewUiListener != null) {
      ListenerRegistry.instance
          .removeListeners(_barcodeCountViewUiListenerEvents, ListenerTarget.view(view._viewId), this);
    }

    _viewEventsSubscription?.cancel();
    _viewEventsSubscription = null;
    super.dispose();
  }
}

// ignore: experimental_member_use
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
        // ignore: experimental_member_use
        CameraOwnershipHelper.requestOwnership(CameraPosition.worldFacing, this);
      } else {
        // ignore: experimental_member_use
        CameraOwnershipHelper.releaseOwnership(CameraPosition.worldFacing, this);
      }
    }
  }

  void _applyPendingCaptureList() {
    final pendingList = widget._barcodeCount._pendingCaptureList;
    if (pendingList != null) {
      widget._barcodeCount._pendingCaptureList = null;
      _controller?.setBarcodeCountCaptureList(pendingList);
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
              _applyPendingCaptureList();
              _syncFeedback();
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
          _applyPendingCaptureList();
          _syncFeedback();
        },
      );
    }
  }

  // A new native view restores the toolbar's saved feedback, so send the mode's feedback again.
  void _syncFeedback() {
    _controller?.updateFeedback();
  }

  @override
  void dispose() {
    // A newer view may already own the shared mode; only detach our own controller.
    if (identical(widget._barcodeCount._controller, _controller)) widget._barcodeCount._controller = null;
    if (identical(widget._controller, _controller)) widget._controller = null;
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }
}
