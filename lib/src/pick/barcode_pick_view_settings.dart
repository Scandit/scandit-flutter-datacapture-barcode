/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';

import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart'
    show buildBarcodePickViewSettings;

import 'barcode_pick_defaults.dart';
import 'ui/barcode_pick_view_highlight_style.dart';

/// Settings used to configure [BarcodePickView].
///
/// Added in version 6.22.0
class BarcodePickViewSettings extends Serializable {
  /// Constructs a new *BarcodePickViewSettings* object with default values.
  ///
  /// Added in version 6.22.0
  BarcodePickViewSettings();

  /// The highlight style used by the view. Default is `RectangularWithIcons`.
  ///
  /// Added in version 6.22.0
  BarcodePickViewHighlightStyle highlightStyle = BarcodePickDefaults.viewSettingsDefaults.highlightStyle;
  /// Enables or disables the loading dialog. Default is *true*.
  ///
  /// Added in version 6.22.0
  bool showLoadingDialog = BarcodePickDefaults.viewSettingsDefaults.showLoadingDialog;
  /// Configures the text shown by the loading dialog when picking.
  ///
  /// Added in version 7.3.0
  String loadingDialogTextForPicking = BarcodePickDefaults.viewSettingsDefaults.loadingDialogTextForPicking;
  /// Configures the text shown by the loading dialog when unpicking.
  ///
  /// Added in version 7.3.0
  String loadingDialogTextForUnpicking = BarcodePickDefaults.viewSettingsDefaults.loadingDialogTextForUnpicking;
  /// Enables or disables the messages shown in the center of the view. Default is *true*.
  ///
  /// Added in version 6.22.0
  bool showGuidelines = BarcodePickDefaults.viewSettingsDefaults.showGuidelines;
  /// Configures the text shown when the mode is first launched.
  ///
  /// Added in version 6.22.0
  String initialGuidelineText = BarcodePickDefaults.viewSettingsDefaults.initialGuidelineText;
  /// Configures the text shown when there are no barcodes detected on screen.
  ///
  /// Added in version 6.22.0
  String moveCloserGuidelineText = BarcodePickDefaults.viewSettingsDefaults.moveCloserGuidelineText;
  /// Enables or disables the messages shown at the top of the view. Default is *true*.
  ///
  /// Added in version 6.22.0
  bool showHints = BarcodePickDefaults.viewSettingsDefaults.showHints;
  /// Configures the text shown when the first item to pick is recognized and shown on screen.
  ///
  /// Added in version 6.22.0
  String onFirstItemToPickFoundHintText = BarcodePickDefaults.viewSettingsDefaults.onFirstItemToPickFoundHintText;
  /// Configures the text shown when the first item pick is completed.
  ///
  /// Added in version 6.22.0
  String onFirstItemPickCompletedHintText = BarcodePickDefaults.viewSettingsDefaults.onFirstItemPickCompletedHintText;
  /// Configures the text shown when the first item that was not a target is picked.
  ///
  /// Added in version 6.22.0
  String onFirstUnmarkedItemPickCompletedHintText =
      BarcodePickDefaults.viewSettingsDefaults.onFirstUnmarkedItemPickCompletedHintText;
  /// Configures the text shown when the user reverses a pick.
  ///
  /// Added in version 6.22.0
  String onFirstItemUnpickCompletedHintText =
      BarcodePickDefaults.viewSettingsDefaults.onFirstItemUnpickCompletedHintText;
  /// Indicates whether the finish button should be shown to the user. Default is *true*.
  ///
  /// Added in version 6.22.0
  bool showFinishButton = BarcodePickDefaults.viewSettingsDefaults.showFinishButton;
  /// Indicates whether the pause button should be shown to the user. Default is *true*.
  ///
  /// Added in version 6.22.0
  bool showPauseButton = BarcodePickDefaults.viewSettingsDefaults.showPauseButton;
  /// Indicates whether the zoom button should be shown to the user. When clicked, it will switch between [CameraSettings.zoomFactor] and [CameraSettings.zoomGestureZoomFactor], which default to 1x and 2x respectively when using [BarcodePick.createRecommendedCameraSettings]. Default is *false*.
  ///
  /// Added in version 7.3.0
  bool showZoomButton = BarcodePickDefaults.viewSettingsDefaults.showZoomButton;
  /// Indicates the position where the zoom button will be shown to the user. If this position is shared with other controls, all of them will be shown in a row. Default is [Anchor.bottomRight].
  ///
  /// Only [Anchor.topLeft], [Anchor.topCenter], [Anchor.topRight], [Anchor.bottomLeft] and [Anchor.bottomRight] are supported.
  ///
  /// Any other value will default to [Anchor.bottomRight].
  ///
  /// Added in version 7.3.0
  Anchor zoomButtonPosition = BarcodePickDefaults.viewSettingsDefaults.zoomButtonPosition;
  /// Indicates whether the torch button should be shown to the user. Default is *false*.
  ///
  /// Added in version 7.3.0
  bool showTorchButton = BarcodePickDefaults.viewSettingsDefaults.showTorchButton;
  /// Indicates the position where the torch button will be shown to the user. If this position is shared with other controls, all of them will be shown in a row. Default is [Anchor.topLeft].
  ///
  /// Only [Anchor.topLeft], [Anchor.topCenter], [Anchor.topRight], [Anchor.bottomLeft] and [Anchor.bottomRight] are supported.
  ///
  /// Any other value will default to [Anchor.topLeft].
  ///
  /// Added in version 7.3.0
  Anchor torchButtonPosition = BarcodePickDefaults.viewSettingsDefaults.torchButtonPosition;
  /// Configures the text shown to suggest the user to pause the scanning to pick items.
  ///
  /// Added in version 7.3.0
  String tapShutterToPauseGuidelineText = BarcodePickDefaults.viewSettingsDefaults.tapShutterToPauseGuidelineText;
  /// Can be used to specify the vertical offset (for Portrait, horizontal for Landscape) for the UI buttons.
  ///
  /// Will be applied only when running on Android. Default value is 32dp.
  ///
  /// Added in version 7.3.0
  DoubleWithUnit? uiButtonsOffset = BarcodePickDefaults.viewSettingsDefaults.uiButtonsOffset;
  /// Added in version 7.3.0
  bool hardwareTriggerEnabled = BarcodePickDefaults.viewSettingsDefaults.hardwareTriggerEnabled;
  /// The button that acts as a scan trigger. Leave *null* to use the default button (The default button will be the dedicated HW button on XCover devices, and “volume down” key for other devices). This is only taken into consideration if [BarcodePickViewSettings.hardwareTriggerEnabled] is true.
  ///
  /// Added in version 7.3.0
  int? hardwareTriggerKeyCode = BarcodePickDefaults.viewSettingsDefaults.hardwareTriggerKeyCode;
  /// Use this property to configure the appearance of the barcodes that are filtered. Default is *null*, filtered barcodes won’t be visualized.
  ///
  /// Added in version 7.3.0
  BarcodeFilterHighlightSettings? filterHighlightSettings =
      BarcodePickDefaults.viewSettingsDefaults.filterHighlightSettings;
  /// The style of the logo, either the extended “Scanning By Scandit” or the minimal “Scandit”.
  ///
  /// Default is [LogoStyle.extended].
  ///
  /// Added in version 8.5.0
  LogoStyle logoStyle = BarcodePickDefaults.viewSettingsDefaults.logoStyle;
  /// The anchor point used to position the Scandit logo.
  ///
  /// Default is [Anchor.bottomRight].
  ///
  /// Added in version 8.5.0
  Anchor logoAnchor = BarcodePickDefaults.viewSettingsDefaults.logoAnchor;

  @override
  Map<String, dynamic> toMap() {
    return buildBarcodePickViewSettings(
      highlightStyle: highlightStyle.toMap(),
      shouldShowLoadingDialog: showLoadingDialog,
      showLoadingDialogTextForPicking: loadingDialogTextForPicking,
      showLoadingDialogTextForUnpicking: loadingDialogTextForUnpicking,
      shouldShowGuidelines: showGuidelines,
      initialGuidelineText: initialGuidelineText,
      moveCloserGuidelineText: moveCloserGuidelineText,
      shouldShowHints: showHints,
      onFirstItemToPickFoundHintText: onFirstItemToPickFoundHintText,
      onFirstItemPickCompletedHintText: onFirstItemPickCompletedHintText,
      onFirstUnmarkedItemPickCompletedHintText: onFirstUnmarkedItemPickCompletedHintText,
      onFirstItemUnpickCompletedHintText: onFirstItemUnpickCompletedHintText,
      showFinishButton: showFinishButton,
      showPauseButton: showPauseButton,
      showZoomButton: showZoomButton,
      zoomButtonPosition: zoomButtonPosition.toString(),
      showTorchButton: showTorchButton,
      torchButtonPosition: torchButtonPosition.toString(),
      tapShutterToPauseGuidelineText: tapShutterToPauseGuidelineText,
      hardwareTriggerEnabled: hardwareTriggerEnabled,
      hardwareTriggerKeyCode: hardwareTriggerKeyCode,
      filterHighlightSettings: filterHighlightSettings?.toMap(),
      // Sent as a JSON *string* while the schema types it as a UIValue object.
      // Preserved verbatim: correcting it is a wire-format change, not this ticket.
      uiButtonsOffset: jsonEncodeOrNull(uiButtonsOffset),
      logoStyle: logoStyle.toString(),
      logoAnchor: logoAnchor.toString(),
    );
  }
}
