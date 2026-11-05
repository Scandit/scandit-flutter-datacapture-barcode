/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_info_annotation_footer.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_ar_annotation_trigger.dart';
import 'barcode_ar_common.dart';
import 'barcode_ar_defaults.dart';
import 'barcode_ar_info_annotation_anchor.dart';
import 'barcode_ar_info_annotation_body_component.dart';
import 'barcode_ar_popover_annotation_anchor.dart';
import 'barcode_ar_status_icon_annotation_anchor.dart';

import 'barcode_ar_info_annotation_header.dart';
import 'barcode_ar_info_annotation_width_preset.dart';

/// The listener for the info annotation.
///
/// Added in version 7.1.0
abstract class BarcodeArInfoAnnotationListener {
  /// Called when the annotation header is tapped. Called only if [BarcodeArInfoAnnotation.isEntireAnnotationTappable] is *false*.
  ///
  /// Added in version 7.1.0
  void didTapInfoAnnotationHeader(BarcodeArInfoAnnotation annotation);
  /// Called when the annotation footer is tapped. Called only if [BarcodeArInfoAnnotation.isEntireAnnotationTappable] is *false*.
  ///
  /// Added in version 7.1.0
  void didTapInfoAnnotationFooter(BarcodeArInfoAnnotation annotation);
  /// Called when the left icon of an annotation component is tapped. componentIndex specifies the index of the component containing the tapped icon within the [BarcodeArInfoAnnotation.body] array. Called only if [BarcodeArInfoAnnotation.isEntireAnnotationTappable] is *false*.
  ///
  /// Added in version 7.1.0
  void didTapInfoAnnotationLeftIcon(BarcodeArInfoAnnotation annotation, int componentIndex);
  /// Called when the right icon of an annotation component is tapped. componentIndex specifies the index of the component containing the tapped icon within the [BarcodeArInfoAnnotation.body] array. Called only if [BarcodeArInfoAnnotation.isEntireAnnotationTappable] is *false*.
  ///
  /// Added in version 7.1.0
  void didTapInfoAnnotationRightIcon(BarcodeArInfoAnnotation annotation, int componentIndex);
  /// Called when the annotation is tapped. Called only if [BarcodeArInfoAnnotation.isEntireAnnotationTappable] is *true*.
  ///
  /// Added in version 7.1.0
  void didTapInfoAnnotation(BarcodeArInfoAnnotation annotation);
}

/// The listener for the popover annotation.
///
/// Added in version 7.1.0
abstract class BarcodeArPopoverAnnotationListener {
  /// Called when a button is tapped. The buttonIndex parameter can be used to identify which button was tapped. Called only if [BarcodeArPopoverAnnotation.isEntirePopoverTappable] is *false*.
  ///
  /// Added in version 7.1.0
  void didTapPopoverButton(
      BarcodeArPopoverAnnotation popover, BarcodeArPopoverAnnotationButton button, int buttonIndex);

  /// Called when the popover is tapped. Called only if [BarcodeArPopoverAnnotation.isEntirePopoverTappable] is *true*.
  ///
  /// Added in version 7.1.0
  void didTapPopover(BarcodeArPopoverAnnotation popover);
}

/// Common interface for Barcode Ar annotations. Annotations are used to display additional information and/or trigger actions. They are displayed outside of the area of a barcode, and attach to the scanned barcode. They are available in different types and have configurable styles. Currently, three types of highlights are supported: [BarcodeArInfoAnnotation], [BarcodeArPopoverAnnotation] and [BarcodeArStatusIconAnnotation].
///
/// <div style="margin-bottom: 20px"></div>
///
/// You can also create your own custom annotation by extending [BarcodeArAnnotation]. For instance, the following code creates a custom annotation that displays a custom image on top of the barcode:
///
/// Added in version 7.1.0
abstract class BarcodeArAnnotation extends Serializable with PrivateBarcodeArAnnotation {
  final String _type;

  BarcodeArAnnotationTrigger _annotationTrigger;

  BarcodeArAnnotation._(this._annotationTrigger, this._type);

  /// The trigger that causes the annotation to be presented.
  ///
  /// Added in version 7.1.0
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  /// The trigger that causes the annotation to be presented.
  ///
  /// Added in version 7.1.0
  set annotationTrigger(BarcodeArAnnotationTrigger value) {
    _annotationTrigger = value;
    controller?.updateAnnotation(this);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': _type,
      'barcodeId': barcodeId,
      'annotationTrigger': annotationTrigger.toString(),
    };
  }
}

mixin PrivateBarcodeArAnnotation {
  String barcodeId = '';
  BarcodeArViewController? controller; // will be set externally
}

/// Info annotations are tooltips that display text and icons, structured as an array of body components ([BarcodeArInfoAnnotationBodyComponent]). Each body component contains text and may include optional tappable icons on both the left and right sides.
///
/// In addition to the body components, info annotations can include an optional header, and footer. By default, they appear automatically when the corresponding barcode is scanned. Info annotations are available in three predefined widths, with their height dynamically adjusting to fit the content. Here are some examples:
///
/// |  |  |  |
/// | --- | --- | --- |
/// | *Body component only.* | *Body component and header.* | *Body component with attributed text and tappable icon.* |
///
/// Added in version 7.1.0
class BarcodeArInfoAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  /// Constructs a new instance with the given barcode.
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotation(this._barcode)
      : super._(BarcodeArDefaults.view.defaultInfoAnnotationTrigger, 'barcodeArInfoAnnotation');

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTapAndBarcodeScan].
  ///
  /// Added in version 8.6.0
  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTapAndBarcodeScan].
  ///
  /// Added in version 8.6.0
  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  bool _hasTip = BarcodeArDefaults.view.defaultInfoAnnotationHasTip;
  /// Whether the annotation has a tip. The default value is *true*.
  ///
  /// Added in version 7.1.0
  bool get hasTip => _hasTip;
  /// Whether the annotation has a tip. The default value is *true*.
  ///
  /// Added in version 7.1.0
  set hasTip(bool newValue) {
    _hasTip = newValue;
    controller?.updateAnnotation(this);
  }

  bool _isEntireAnnotationTappable = BarcodeArDefaults.view.defaultInfoAnnotationEntireAnnotationTappable;
  /// If *false*, each individual element within the annotation (header, footer, icons in body components) is tappable. If *true*, the entire annotation is tappable.
  ///
  /// Added in version 7.1.0
  bool get isEntireAnnotationTappable => _isEntireAnnotationTappable;
  /// If *false*, each individual element within the annotation (header, footer, icons in body components) is tappable. If *true*, the entire annotation is tappable.
  ///
  /// Added in version 7.1.0
  set isEntireAnnotationTappable(bool newValue) {
    _isEntireAnnotationTappable = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationAnchor _anchor = BarcodeArDefaults.view.defaultInfoAnnotationAnchor;
  /// The annotation anchor. The default value is [BarcodeArInfoAnnotationAnchor.bottom].
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationAnchor get anchor => _anchor;
  /// The annotation anchor. The default value is [BarcodeArInfoAnnotationAnchor.bottom].
  ///
  /// Added in version 7.1.0
  set anchor(BarcodeArInfoAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationWidthPreset _width = BarcodeArDefaults.view.defaultInfoAnnotationWidth;
  /// The annotation width. The default value is [BarcodeArInfoAnnotationWidthPreset.small].
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationWidthPreset get width => _width;
  /// The annotation width. The default value is [BarcodeArInfoAnnotationWidthPreset.small].
  ///
  /// Added in version 7.1.0
  set width(BarcodeArInfoAnnotationWidthPreset newValue) {
    _width = newValue;
    controller?.updateAnnotation(this);
  }

  List<BarcodeArInfoAnnotationBodyComponent> _body = [];
  /// The annotation body, represented as an array of body components ([BarcodeArInfoAnnotationBodyComponent]). The default value is [].
  ///
  /// Added in version 7.1.0
  List<BarcodeArInfoAnnotationBodyComponent> get body => _body;
  /// The annotation body, represented as an array of body components ([BarcodeArInfoAnnotationBodyComponent]). The default value is [].
  ///
  /// Added in version 7.1.0
  set body(List<BarcodeArInfoAnnotationBodyComponent> newValue) {
    _body = List.unmodifiable(newValue);
    for (var component in _body) {
      component.addListener(_onBodyChange);
    }
    controller?.updateAnnotation(this);
  }

  void _onBodyChange() {
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationHeader? _header;
  /// The annotation header. The default value is *null*.
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationHeader? get header => _header;
  /// The annotation header. The default value is *null*.
  ///
  /// Added in version 7.1.0
  set header(BarcodeArInfoAnnotationHeader? newValue) {
    _header?.removeListener(_onHeaderFooterChange);
    _header = newValue;
    _header?.addListener(_onHeaderFooterChange);
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationFooter? _footer;
  /// The annotation footer. The default value is *null*.
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationFooter? get footer => _footer;
  /// The annotation footer. The default value is *null*.
  ///
  /// Added in version 7.1.0
  set footer(BarcodeArInfoAnnotationFooter? newValue) {
    _footer?.removeListener(_onHeaderFooterChange);
    _footer = newValue;
    _footer?.addListener(_onHeaderFooterChange);
    controller?.updateAnnotation(this);
  }

  void _onHeaderFooterChange() {
    controller?.updateAnnotation(this);
  }

  Color _backgroundColor = BarcodeArDefaults.view.defaultInfoAnnotationBackgroundColor;
  /// The background color. The default value is #CCFFFFFF.
  ///
  /// Added in version 7.1.0
  Color get backgroundColor => _backgroundColor;
  /// The background color. The default value is #CCFFFFFF.
  ///
  /// Added in version 7.1.0
  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationListener? _listener;
  /// An object that receives notifications for UI-related events.
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationListener? get listener => _listener;
  /// An object that receives notifications for UI-related events.
  ///
  /// Added in version 7.1.0
  set listener(BarcodeArInfoAnnotationListener? newValue) {
    _listener = newValue;
    controller?.updateAnnotation(this);
  }

  /// The barcode instance for the annotation.
  ///
  /// Added in version 7.1.0
  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'hasTip': hasTip,
      'isEntireAnnotationTappable': isEntireAnnotationTappable,
      'anchor': anchor.toString(),
      'width': width.toString(),
      'body': body.map((e) => e.toMap()).toList(),
      'header': header?.toMap(),
      'footer': footer?.toMap(),
      'backgroundColor': backgroundColor.jsonValue,
      'hasListener': listener != null
    });
    return json;
  }
}

/// Added in version 7.1.0
class BarcodeArPopoverAnnotationButton with ChangeNotifier implements Serializable {
  final ScanditIcon _icon;
  final String _text;
  int _index = -1;

  /// Constructs a new instance with the given icon and text.
  ///
  /// Added in version 7.1.0
  BarcodeArPopoverAnnotationButton(this._icon, this._text);

  Color _textColor = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationButtonTextColor;
  /// The color of the text. Default is #3D4852.
  ///
  /// Added in version 7.1.0
  Color get textColor => _textColor;
  /// The color of the text. Default is #3D4852.
  ///
  /// Added in version 7.1.0
  set textColor(Color newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationButtonTextSize;
  /// The size of the text. Default is 10 scale-independent pixels.
  ///
  /// Added in version 7.1.0
  double get textSize => _textSize;
  /// The size of the text. Default is 10 scale-independent pixels.
  ///
  /// Added in version 7.1.0
  set textSize(double newValue) {
    _textSize = newValue;
    notifyListeners();
  }

  FontFamily _fontFamily = FontFamily.systemDefault;
  /// The font used for the text.
  ///
  /// Added in version 7.1.0
  FontFamily get fontFamily => _fontFamily;
  /// The font used for the text.
  ///
  /// Added in version 7.1.0
  set fontFamily(FontFamily newValue) {
    _fontFamily = newValue;
    notifyListeners();
  }

  /// The icon provided in the constructor.
  ///
  /// Added in version 7.1.0
  ScanditIcon get icon => _icon;

  /// The text provided in the constructor.
  ///
  /// Added in version 7.1.0
  String get text => _text;

  bool _enabled = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationButtonEnabled;
  /// Whether the button is enabled. Default is *true*.
  ///
  /// Added in version 7.1.0
  bool get enabled => _enabled;
  /// Whether the button is enabled. Default is *true*.
  ///
  /// Added in version 7.1.0
  set enabled(bool newValue) {
    _enabled = newValue;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'icon': _icon.toMap(),
      'text': _text,
      'textColor': textColor.jsonValue,
      'textSize': textSize,
      'fontFamily': fontFamily.toString(),
      'index': _index,
    };
  }
}

/// An annotation comprising a set of buttons, each containing an icon and text, which appears only when the user taps on the corresponding barcode highlight.
///
/// Added in version 7.1.0
class BarcodeArPopoverAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  late List<BarcodeArPopoverAnnotationButton> _buttons;

  /// Constructs a new instance with the given buttons and barcode.
  ///
  /// Added in version 7.1.0
  BarcodeArPopoverAnnotation(this._barcode, List<BarcodeArPopoverAnnotationButton> buttons)
      : super._(BarcodeArDefaults.view.defaultPopoverAnnotationTrigger, 'barcodeArPopoverAnnotation') {
    _buttons = List.unmodifiable(buttons);
    for (var i = 0; i < _buttons.length; i++) {
      var button = _buttons[i];
      button._index = i;
      button.addListener(() => _buttonChanged(i));
    }
  }

  void _buttonChanged(int buttonIndex) {
    controller?.updateBarcodeArPopoverButtonAtIndex(this, buttonIndex);
  }

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTap].
  ///
  /// Added in version 8.6.0
  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTap].
  ///
  /// Added in version 8.6.0
  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  bool _isEntirePopoverTappable = BarcodeArDefaults.view.defaultIsEntirePopoverTappable;
  /// If *false* each individual button in the popover is tappable. If *true* the entire popover is tappable. Default is *false*.
  ///
  /// Added in version 7.1.0
  bool get isEntirePopoverTappable => _isEntirePopoverTappable;
  /// If *false* each individual button in the popover is tappable. If *true* the entire popover is tappable. Default is *false*.
  ///
  /// Added in version 7.1.0
  set isEntirePopoverTappable(bool newValue) {
    _isEntirePopoverTappable = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArPopoverAnnotationAnchor _anchor = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationAnchor;
  /// The annotation anchor. The default value is [BarcodeArPopoverAnnotationAnchor.bottom].
  ///
  /// Added in version 8.5.0
  BarcodeArPopoverAnnotationAnchor get anchor => _anchor;
  /// The annotation anchor. The default value is [BarcodeArPopoverAnnotationAnchor.bottom].
  ///
  /// Added in version 8.5.0
  set anchor(BarcodeArPopoverAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArPopoverAnnotationListener? _listener;
  /// An object that receives notifications for UI-related events, such as tapping on a button.
  ///
  /// Added in version 7.1.0
  BarcodeArPopoverAnnotationListener? get listener => _listener;
  /// An object that receives notifications for UI-related events, such as tapping on a button.
  ///
  /// Added in version 7.1.0
  set listener(BarcodeArPopoverAnnotationListener? newValue) {
    _listener = newValue;
    controller?.updateAnnotation(this);
  }

  /// Returns the buttons provided in the constructor.
  ///
  /// Added in version 7.1.0
  List<BarcodeArPopoverAnnotationButton> get buttons => _buttons;

  /// Returns the barcode provided in the constructor.
  ///
  /// Added in version 7.1.0
  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'anchor': anchor.toString(),
      'isEntirePopoverTappable': isEntirePopoverTappable,
      'buttons': buttons.map((e) => e.toMap()).toList(),
      'hasListener': listener != null
    });
    return json;
  }
}

/// A tooltip annotation that toggles between collapsed and expanded states upon tap. In the collapsed state, only the icon is visible. In the expanded state, both the icon and text are displayed.
///
/// |  |  |
/// | --- | --- |
/// | *Collapsed state.* | *Expanded state.* |
///
/// Added in version 7.1.0
class BarcodeArStatusIconAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  /// Constructs a new instance of this class.
  ///
  /// Added in version 7.1.0
  BarcodeArStatusIconAnnotation(this._barcode)
      : super._(BarcodeArDefaults.view.defaultStatusIconAnnotationTrigger, 'barcodeArStatusIconAnnotation');

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTapAndBarcodeScan].
  ///
  /// Added in version 8.6.0
  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTapAndBarcodeScan].
  ///
  /// Added in version 8.6.0
  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  bool _hasTip = BarcodeArDefaults.view.defaultStatusIconAnnotationHasTip;
  /// Whether the status icon has a tip. Default is *true*.
  ///
  /// Added in version 7.1.0
  bool get hasTip => _hasTip;
  /// Whether the status icon has a tip. Default is *true*.
  ///
  /// Added in version 7.1.0
  set hasTip(bool newValue) {
    _hasTip = newValue;
    controller?.updateAnnotation(this);
  }

  ScanditIcon _icon = BarcodeArDefaults.view.defaultStatusIconAnnotationIcon;
  /// The icon. Default value is black [ScanditIconType.exclamationMark] with a background color of #FBC02C.
  ///
  /// Added in version 7.1.0
  ScanditIcon get icon => _icon;
  /// The icon. Default value is black [ScanditIconType.exclamationMark] with a background color of #FBC02C.
  ///
  /// Added in version 7.1.0
  set icon(ScanditIcon newValue) {
    _icon = newValue;
    controller?.updateAnnotation(this);
  }

  String? _text = BarcodeArDefaults.view.defaultStatusIconAnnotationText;
  /// The text shown in the expanded state. Maximum allowed length is 20 characters, including whitespaces. If *null*, the status icon doesn’t expand on tap. Default is *null*.
  ///
  /// Added in version 7.1.0
  String? get text => _text;
  /// The text shown in the expanded state. Maximum allowed length is 20 characters, including whitespaces. If *null*, the status icon doesn’t expand on tap. Default is *null*.
  ///
  /// Added in version 7.1.0
  set text(String? newValue) {
    _text = newValue;
    controller?.updateAnnotation(this);
  }

  Color _textColor = BarcodeArDefaults.view.defaultStatusIconAnnotationTextColor;
  /// The color of the text. Default is #121619.
  ///
  /// Added in version 7.1.0
  Color get textColor => _textColor;
  /// The color of the text. Default is #121619.
  ///
  /// Added in version 7.1.0
  set textColor(Color newValue) {
    _textColor = newValue;
    controller?.updateAnnotation(this);
  }

  Color _backgroundColor = BarcodeArDefaults.view.defaultStatusIconAnnotationBackgroundColor;
  /// The annotation background color. Default is #FFFFFF.
  ///
  /// Added in version 7.1.0
  Color get backgroundColor => _backgroundColor;
  /// The annotation background color. Default is #FFFFFF.
  ///
  /// Added in version 7.1.0
  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArStatusIconAnnotationAnchor _anchor = BarcodeArDefaults.view.defaultStatusIconAnnotationAnchor;
  /// The annotation anchor. The default value is [BarcodeArStatusIconAnnotationAnchor.bottom].
  ///
  /// Added in version 8.6.0
  BarcodeArStatusIconAnnotationAnchor get anchor => _anchor;
  /// The annotation anchor. The default value is [BarcodeArStatusIconAnnotationAnchor.bottom].
  ///
  /// Added in version 8.6.0
  set anchor(BarcodeArStatusIconAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  /// The barcode instance for the annotation.
  ///
  /// Added in version 7.1.0
  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'hasTip': hasTip,
      'icon': icon.toMap(),
      'text': text,
      'textColor': textColor.jsonValue,
      'backgroundColor': backgroundColor.jsonValue,
      'anchor': anchor.toString(),
    });
    return json;
  }
}

/// A custom annotation that can be used to attach your own component to a scanned barcode.
///
/// Added in version 8.1.0
class BarcodeArCustomAnnotation extends BarcodeArAnnotation {
  final Widget _child;
  final Barcode _barcode;
  final Anchor _anchor;
  BarcodeArCustomAnnotation._(this._barcode, BarcodeArAnnotationTrigger annotationTrigger, this._child, this._anchor)
      : super._(annotationTrigger, 'barcodeArCustomAnnotation');

  /// Creates a new instance of the custom annotation.
  ///
  /// Added in version 8.1.0
  BarcodeArCustomAnnotation({
    required Barcode barcode,
    required BarcodeArAnnotationTrigger annotationTrigger,
    required Widget child,
    Anchor? anchor,
  }) : this._(barcode, annotationTrigger, child, anchor ?? Anchor.topCenter);

  /// The barcode instance for the annotation.
  ///
  /// Added in version 8.1.0
  Barcode get barcode => _barcode;

  /// The child widget to be used as a custom annotation.
  ///
  /// Added in version 8.1.0
  Widget get child => _child;

  /// Specifies the anchor point for the annotation. The default is [Anchor.topCenter]
  ///
  /// The child widget can be any Flutter widget, allowing for complete customization of the annotation appearance.
  ///
  /// ```dart
  /// BarcodeArCustomAnnotation(
  ///   barcode: barcode,
  ///   annotationTrigger: annotationTrigger,
  ///   child: YourCustomWidget(),
  /// );
  /// ```
  ///
  /// Added in version 8.1.0
  Anchor get anchor => _anchor;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    return json;
  }
}

/// Responsive annotations dynamically switch between different annotation variations based on the barcode’s size relative to the screen. This allows for different display styles as a barcode gets closer to or further from the camera.
///
/// Each variation is gated by an area-ratio upper bound (the barcode area as a percentage of the screen area). The variations are evaluated from far to close, and the one whose upper bound is the first at or above the current ratio is displayed.
///
/// Each variation is a [BarcodeArAnnotation] — an info, popover, status icon or custom annotation — and any can be set to *null* to display nothing in that range.
///
/// A [BarcodeArResponsiveAnnotation] passed as a variation is ignored with a warning.
///
/// A [BarcodeArPopoverAnnotation] is not fully supported as a variation. [BarcodeArView] only applies popover-specific handling — dark scrim, exclusive visibility, hiding on tap — to a popover the annotation provider returns directly, so a popover used as a variation does not receive it.
///
/// Added in version 8.2.0
class BarcodeArResponsiveAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  final Map<double, BarcodeArAnnotation?> _annotationsByThreshold;

  // True when built through the deprecated two-annotation constructor. Only such an instance
  // has a meaningful single `threshold`, so only there may the deprecated setter rebuild the
  // map — on a map-constructed instance rebuilding would discard states 3..N.
  final bool _usesLegacyTwoStateApi;

  /// Constructs a new responsive annotation whose displayed variation depends on the barcode's
  /// area relative to the view. Each key is the area-ratio upper bound (in the range (0.0, 1.0])
  /// at or below which the associated annotation is shown; ranges are evaluated from far to
  /// close. A null value suppresses the annotation in that range. Keys outside (0.0, 1.0] are
  /// dropped with a warning.
  BarcodeArResponsiveAnnotation.withAnnotationsByThreshold(
      this._barcode, Map<double, BarcodeArAnnotation?> annotationsByThreshold)
      : _annotationsByThreshold = _validate(annotationsByThreshold),
        _usesLegacyTwoStateApi = false,
        super._(BarcodeArDefaults.view.defaultResponsiveAnnotationTrigger, 'barcodeArResponsiveAnnotation');

  /// Constructs a new responsive annotation with the given barcode and annotation variations.
  ///
  /// Added in version 8.2.0
  @Deprecated('Use the constructor that accepts an annotationsByThreshold map instead. Will be removed in 9.0.')
  BarcodeArResponsiveAnnotation(
      this._barcode, BarcodeArInfoAnnotation? closeUpAnnotation, BarcodeArInfoAnnotation? farAwayAnnotation)
      : _annotationsByThreshold = _validate({
          BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold: farAwayAnnotation,
          1.0: closeUpAnnotation,
        }),
        _usesLegacyTwoStateApi = true,
        super._(BarcodeArDefaults.view.defaultResponsiveAnnotationTrigger, 'barcodeArResponsiveAnnotation');

  static Map<double, BarcodeArAnnotation?> _validate(Map<double, BarcodeArAnnotation?> input) {
    var result = <double, BarcodeArAnnotation?>{};
    for (final entry in input.entries) {
      if (entry.key <= 0 || entry.key > 1) {
        developer.log('Threshold ${entry.key} is out of range (0, 1] and will be ignored.',
            name: 'BarcodeArResponsiveAnnotation.annotationsByThreshold');
        continue;
      }
      final value = entry.value;
      if (value is BarcodeArResponsiveAnnotation) {
        developer.log('A ${value.runtimeType} cannot be nested in a responsive annotation and will be ignored.',
            name: 'BarcodeArResponsiveAnnotation.annotationsByThreshold');
        continue;
      }
      result[entry.key] = value;
    }
    var sortedKeys = result.keys.toList()..sort();
    return {for (final key in sortedKeys) key: result[key]};
  }

  /// The annotations keyed by the area-ratio upper bound (in (0.0, 1.0]) at or below which each
  /// is shown, ordered by ascending threshold. A null value means no annotation is shown in that
  /// range.
  ///
  /// The annotations keyed by the area-ratio upper bound (in (0.0, 1.0]) at or below which each is shown, with *null* for a range that shows nothing. Keys passed to the initializer outside (0.0, 1.0] are dropped.
  ///
  /// Added in version 8.6.0
  Map<double, BarcodeArAnnotation?> get annotationsByThreshold => Map.unmodifiable(_annotationsByThreshold);

  /// The annotation displayed when the barcode appears close-up (when the barcode area exceeds the [BarcodeArResponsiveAnnotation.threshold]).
  ///
  /// Can be *null* to display nothing for close-up barcodes.
  ///
  /// Added in version 8.2.0
  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  BarcodeArInfoAnnotation? get closeUpAnnotation {
    final annotation = _annotationsByThreshold[1.0];
    return annotation is BarcodeArInfoAnnotation ? annotation : null;
  }

  /// The annotation displayed when the barcode appears far away (when the barcode area is below or equal to the [BarcodeArResponsiveAnnotation.threshold]).
  ///
  /// Can be *null* to display nothing for far-away barcodes.
  ///
  /// Added in version 8.2.0
  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  BarcodeArInfoAnnotation? get farAwayAnnotation {
    final annotation = _legacyFarAwayEntry()?.value;
    return annotation is BarcodeArInfoAnnotation ? annotation : null;
  }

  // The lowest-threshold entry that isn't the close-up (1.0) slot; this is what the legacy
  // 2-arg constructor mapped to farAwayAnnotation/threshold, and what the legacy toMap keys
  // are derived from.
  MapEntry<double, BarcodeArAnnotation?>? _legacyFarAwayEntry() {
    for (final entry in _annotationsByThreshold.entries) {
      if (entry.key != 1.0) {
        return entry;
      }
    }
    return null;
  }

  /// The threshold (percentage of the barcode area vs screen area) that determines when to display close-up vs far-away annotations.
  ///
  /// The value should be between 0.0 and 1.0, where 0.1 represents 10% of the screen area.
  ///
  /// The default value is 0.05.
  ///
  /// The threshold is a class-level property that applies to all instances of [BarcodeArResponsiveAnnotation].
  ///
  /// Added in version 8.2.0
  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  double get threshold => _legacyFarAwayEntry()?.key ?? BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold;

  /// The threshold (percentage of the barcode area vs screen area) that determines when to display close-up vs far-away annotations.
  ///
  /// The value should be between 0.0 and 1.0, where 0.1 represents 10% of the screen area.
  ///
  /// The default value is 0.05.
  ///
  /// The threshold is a class-level property that applies to all instances of [BarcodeArResponsiveAnnotation].
  ///
  /// Added in version 8.2.0
  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  set threshold(double newValue) {
    if (!_usesLegacyTwoStateApi) {
      developer.log(
          'The deprecated threshold cannot be set on an annotation built with annotationsByThreshold. '
          'Rebuild the annotation with the desired thresholds instead.',
          name: 'BarcodeArResponsiveAnnotation.threshold');
      return;
    }
    var farAway = _legacyFarAwayEntry()?.value;
    var closeUp = _annotationsByThreshold[1.0];
    _annotationsByThreshold
      ..clear()
      ..addAll(_validate({newValue: farAway, 1.0: closeUp}));
    controller?.updateAnnotation(this);
  }

  /// The barcode instance for the annotation.
  ///
  /// Added in version 8.2.0
  Barcode get barcode => _barcode;

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTapAndBarcodeScan].
  ///
  /// Added in version 8.2.0
  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  /// The trigger that causes the annotation to be presented. By default is [BarcodeArAnnotationTrigger.highlightTapAndBarcodeScan].
  ///
  /// Added in version 8.2.0
  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  @override
  Map<String, dynamic> toMap() {
    // Propagate controller and barcodeId to every child annotation before serialization.
    for (final annotation in _annotationsByThreshold.values) {
      if (annotation != null) {
        annotation.controller = controller;
        annotation.barcodeId = barcodeId;
      }
    }

    var json = super.toMap();
    json['annotationsByThreshold'] = {
      for (final entry in _annotationsByThreshold.entries) entry.key.toString(): entry.value?.toMap()
    };

    // Legacy keys, kept for the shared native parsers (and the jsmobile TS layer that reuses
    // them), which still read closeUpAnnotation/farAwayAnnotation/threshold directly.
    var closeUp = _annotationsByThreshold[1.0];
    if (closeUp is BarcodeArInfoAnnotation) {
      json['closeUpAnnotation'] = closeUp.toMap();
    }
    var farAwayEntry = _legacyFarAwayEntry();
    var farAway = farAwayEntry?.value;
    if (farAway is BarcodeArInfoAnnotation) {
      json['farAwayAnnotation'] = farAway.toMap();
    }
    json['threshold'] = farAwayEntry?.key ?? BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold;

    return json;
  }
}
