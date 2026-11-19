/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';
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

abstract class BarcodeArInfoAnnotationListener {
  void didTapInfoAnnotationHeader(BarcodeArInfoAnnotation annotation);
  void didTapInfoAnnotationFooter(BarcodeArInfoAnnotation annotation);
  void didTapInfoAnnotationLeftIcon(BarcodeArInfoAnnotation annotation, int componentIndex);
  void didTapInfoAnnotationRightIcon(BarcodeArInfoAnnotation annotation, int componentIndex);
  void didTapInfoAnnotation(BarcodeArInfoAnnotation annotation);
}

abstract class BarcodeArPopoverAnnotationListener {
  void didTapPopoverButton(
      BarcodeArPopoverAnnotation popover, BarcodeArPopoverAnnotationButton button, int buttonIndex);

  void didTapPopover(BarcodeArPopoverAnnotation popover);
}

abstract class BarcodeArAnnotation extends Serializable with PrivateBarcodeArAnnotation {
  final String _type;

  BarcodeArAnnotationTrigger _annotationTrigger;

  BarcodeArAnnotation._(this._annotationTrigger, this._type);

  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

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

class BarcodeArInfoAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  BarcodeArInfoAnnotation(this._barcode)
      : super._(BarcodeArDefaults.view.defaultInfoAnnotationTrigger, 'barcodeArInfoAnnotation');

  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  bool _hasTip = BarcodeArDefaults.view.defaultInfoAnnotationHasTip;
  bool get hasTip => _hasTip;
  set hasTip(bool newValue) {
    _hasTip = newValue;
    controller?.updateAnnotation(this);
  }

  bool _isEntireAnnotationTappable = BarcodeArDefaults.view.defaultInfoAnnotationEntireAnnotationTappable;
  bool get isEntireAnnotationTappable => _isEntireAnnotationTappable;
  set isEntireAnnotationTappable(bool newValue) {
    _isEntireAnnotationTappable = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationAnchor _anchor = BarcodeArDefaults.view.defaultInfoAnnotationAnchor;
  BarcodeArInfoAnnotationAnchor get anchor => _anchor;
  set anchor(BarcodeArInfoAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationWidthPreset _width = BarcodeArDefaults.view.defaultInfoAnnotationWidth;
  BarcodeArInfoAnnotationWidthPreset get width => _width;
  set width(BarcodeArInfoAnnotationWidthPreset newValue) {
    _width = newValue;
    controller?.updateAnnotation(this);
  }

  List<BarcodeArInfoAnnotationBodyComponent> _body = [];
  List<BarcodeArInfoAnnotationBodyComponent> get body => _body;
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
  BarcodeArInfoAnnotationHeader? get header => _header;
  set header(BarcodeArInfoAnnotationHeader? newValue) {
    _header?.removeListener(_onHeaderFooterChange);
    _header = newValue;
    _header?.addListener(_onHeaderFooterChange);
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationFooter? _footer;
  BarcodeArInfoAnnotationFooter? get footer => _footer;
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
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArInfoAnnotationListener? _listener;
  BarcodeArInfoAnnotationListener? get listener => _listener;
  set listener(BarcodeArInfoAnnotationListener? newValue) {
    _listener = newValue;
    controller?.updateAnnotation(this);
  }

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

class BarcodeArPopoverAnnotationButton with ChangeNotifier implements Serializable {
  final ScanditIcon _icon;
  final String _text;
  int _index = -1;

  BarcodeArPopoverAnnotationButton(this._icon, this._text);

  Color _textColor = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationButtonTextColor;
  Color get textColor => _textColor;
  set textColor(Color newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationButtonTextSize;
  double get textSize => _textSize;
  set textSize(double newValue) {
    _textSize = newValue;
    notifyListeners();
  }

  FontFamily _fontFamily = FontFamily.systemDefault;
  FontFamily get fontFamily => _fontFamily;
  set fontFamily(FontFamily newValue) {
    _fontFamily = newValue;
    notifyListeners();
  }

  ScanditIcon get icon => _icon;

  String get text => _text;

  bool _enabled = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationButtonEnabled;
  bool get enabled => _enabled;
  set enabled(bool newValue) {
    _enabled = newValue;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'icon': jsonEncode(_icon.toMap()),
      'text': _text,
      'textColor': textColor.jsonValue,
      'textSize': textSize,
      'fontFamily': fontFamily.toString(),
      'index': _index,
    };
  }
}

class BarcodeArPopoverAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  late List<BarcodeArPopoverAnnotationButton> _buttons;

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

  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  bool _isEntirePopoverTappable = BarcodeArDefaults.view.defaultIsEntirePopoverTappable;
  bool get isEntirePopoverTappable => _isEntirePopoverTappable;
  set isEntirePopoverTappable(bool newValue) {
    _isEntirePopoverTappable = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArPopoverAnnotationAnchor _anchor = BarcodeArDefaults.view.defaultBarcodeArPopoverAnnotationAnchor;
  BarcodeArPopoverAnnotationAnchor get anchor => _anchor;
  set anchor(BarcodeArPopoverAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArPopoverAnnotationListener? _listener;
  BarcodeArPopoverAnnotationListener? get listener => _listener;
  set listener(BarcodeArPopoverAnnotationListener? newValue) {
    _listener = newValue;
    controller?.updateAnnotation(this);
  }

  List<BarcodeArPopoverAnnotationButton> get buttons => _buttons;

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

class BarcodeArStatusIconAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  BarcodeArStatusIconAnnotation(this._barcode)
      : super._(BarcodeArDefaults.view.defaultStatusIconAnnotationTrigger, 'barcodeArStatusIconAnnotation');

  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

  @override
  set annotationTrigger(BarcodeArAnnotationTrigger newValue) {
    _annotationTrigger = newValue;
    controller?.updateAnnotation(this);
  }

  bool _hasTip = BarcodeArDefaults.view.defaultStatusIconAnnotationHasTip;
  bool get hasTip => _hasTip;
  set hasTip(bool newValue) {
    _hasTip = newValue;
    controller?.updateAnnotation(this);
  }

  ScanditIcon _icon = BarcodeArDefaults.view.defaultStatusIconAnnotationIcon;
  ScanditIcon get icon => _icon;
  set icon(ScanditIcon newValue) {
    _icon = newValue;
    controller?.updateAnnotation(this);
  }

  String? _text = BarcodeArDefaults.view.defaultStatusIconAnnotationText;
  String? get text => _text;
  set text(String? newValue) {
    _text = newValue;
    controller?.updateAnnotation(this);
  }

  Color _textColor = BarcodeArDefaults.view.defaultStatusIconAnnotationTextColor;
  Color get textColor => _textColor;
  set textColor(Color newValue) {
    _textColor = newValue;
    controller?.updateAnnotation(this);
  }

  Color _backgroundColor = BarcodeArDefaults.view.defaultStatusIconAnnotationBackgroundColor;
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeArStatusIconAnnotationAnchor _anchor = BarcodeArDefaults.view.defaultStatusIconAnnotationAnchor;
  BarcodeArStatusIconAnnotationAnchor get anchor => _anchor;
  set anchor(BarcodeArStatusIconAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  Barcode get barcode => _barcode;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'hasTip': hasTip,
      'icon': jsonEncode(icon.toMap()),
      'text': text,
      'textColor': textColor.jsonValue,
      'backgroundColor': backgroundColor.jsonValue,
      'anchor': anchor.toString(),
    });
    return json;
  }
}

class BarcodeArCustomAnnotation extends BarcodeArAnnotation {
  final Widget _child;
  final Barcode _barcode;
  final Anchor _anchor;
  BarcodeArCustomAnnotation._(this._barcode, BarcodeArAnnotationTrigger annotationTrigger, this._child, this._anchor)
      : super._(annotationTrigger, 'barcodeArCustomAnnotation');

  BarcodeArCustomAnnotation({
    required Barcode barcode,
    required BarcodeArAnnotationTrigger annotationTrigger,
    required Widget child,
    Anchor? anchor,
  }) : this._(barcode, annotationTrigger, child, anchor ?? Anchor.topCenter);

  Barcode get barcode => _barcode;

  Widget get child => _child;

  Anchor get anchor => _anchor;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    return json;
  }
}

class BarcodeArResponsiveAnnotation extends BarcodeArAnnotation {
  final Barcode _barcode;

  final Map<double, BarcodeArInfoAnnotation?> _annotationsByThreshold;

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
      this._barcode, Map<double, BarcodeArInfoAnnotation?> annotationsByThreshold)
      : _annotationsByThreshold = _validate(annotationsByThreshold),
        _usesLegacyTwoStateApi = false,
        super._(BarcodeArDefaults.view.defaultResponsiveAnnotationTrigger, 'barcodeArResponsiveAnnotation');

  @Deprecated('Use the constructor that accepts an annotationsByThreshold map instead. Will be removed in 9.0.')
  BarcodeArResponsiveAnnotation(
      this._barcode, BarcodeArInfoAnnotation? closeUpAnnotation, BarcodeArInfoAnnotation? farAwayAnnotation)
      : _annotationsByThreshold = _validate({
          BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold: farAwayAnnotation,
          1.0: closeUpAnnotation,
        }),
        _usesLegacyTwoStateApi = true,
        super._(BarcodeArDefaults.view.defaultResponsiveAnnotationTrigger, 'barcodeArResponsiveAnnotation');

  static Map<double, BarcodeArInfoAnnotation?> _validate(Map<double, BarcodeArInfoAnnotation?> input) {
    var result = <double, BarcodeArInfoAnnotation?>{};
    for (final entry in input.entries) {
      if (entry.key <= 0 || entry.key > 1) {
        developer.log('Threshold ${entry.key} is out of range (0, 1] and will be ignored.',
            name: 'BarcodeArResponsiveAnnotation.annotationsByThreshold');
        continue;
      }
      result[entry.key] = entry.value;
    }
    var sortedKeys = result.keys.toList()..sort();
    return {for (final key in sortedKeys) key: result[key]};
  }

  /// The annotations keyed by the area-ratio upper bound (in (0.0, 1.0]) at or below which each
  /// is shown, ordered by ascending threshold. A null value means no annotation is shown in that
  /// range.
  Map<double, BarcodeArInfoAnnotation?> get annotationsByThreshold => Map.unmodifiable(_annotationsByThreshold);

  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  BarcodeArInfoAnnotation? get closeUpAnnotation => _annotationsByThreshold[1.0];

  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  BarcodeArInfoAnnotation? get farAwayAnnotation => _legacyFarAwayEntry()?.value;

  // The lowest-threshold entry that isn't the close-up (1.0) slot; this is what the legacy
  // 2-arg constructor mapped to farAwayAnnotation/threshold, and what the legacy toMap keys
  // are derived from.
  MapEntry<double, BarcodeArInfoAnnotation?>? _legacyFarAwayEntry() {
    for (final entry in _annotationsByThreshold.entries) {
      if (entry.key != 1.0) {
        return entry;
      }
    }
    return null;
  }

  @Deprecated('Use annotationsByThreshold instead. Will be removed in 9.0.')
  double get threshold => _legacyFarAwayEntry()?.key ?? BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold;

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

  Barcode get barcode => _barcode;

  @override
  BarcodeArAnnotationTrigger get annotationTrigger => _annotationTrigger;

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
    if (closeUp != null) {
      json['closeUpAnnotation'] = closeUp.toMap();
    }
    var farAwayEntry = _legacyFarAwayEntry();
    var farAway = farAwayEntry?.value;
    if (farAway != null) {
      json['farAwayAnnotation'] = farAway.toMap();
    }
    json['threshold'] = farAwayEntry?.key ?? BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold;

    return json;
  }
}
