/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_info_annotation_footer.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_ar_annotation_trigger.dart';
import 'barcode_ar_common.dart';
import 'barcode_ar_defaults.dart';
import 'barcode_ar_info_annotation_anchor.dart';
import 'barcode_ar_info_annotation_body_component.dart';

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

  bool isEntirePopoverTappable = BarcodeArDefaults.view.defaultIsEntirePopoverTappable;

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

  final BarcodeArInfoAnnotation? _closeUpAnnotation;
  final BarcodeArInfoAnnotation? _farAwayAnnotation;
  double _threshold = BarcodeArDefaults.view.defaultResponsiveAnnotationThreshold;

  @override
  BarcodeArResponsiveAnnotation(this._barcode, this._closeUpAnnotation, this._farAwayAnnotation)
      : super._(BarcodeArDefaults.view.defaultResponsiveAnnotationTrigger, 'barcodeArResponsiveAnnotation');

  BarcodeArInfoAnnotation? get closeUpAnnotation => _closeUpAnnotation;

  BarcodeArInfoAnnotation? get farAwayAnnotation => _farAwayAnnotation;

  double get threshold => _threshold;

  set threshold(double newValue) {
    _threshold = newValue;
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
    // Propagate controller and barcodeId to child annotations before serialization
    if (_closeUpAnnotation != null) {
      _closeUpAnnotation.controller = controller;
      _closeUpAnnotation.barcodeId = barcodeId;
    }
    if (_farAwayAnnotation != null) {
      _farAwayAnnotation.controller = controller;
      _farAwayAnnotation.barcodeId = barcodeId;
    }

    var json = super.toMap();
    if (_closeUpAnnotation != null) {
      json['closeUpAnnotation'] = _closeUpAnnotation.toMap();
    }
    if (_farAwayAnnotation != null) {
      json['farAwayAnnotation'] = _farAwayAnnotation.toMap();
    }
    json['threshold'] = _threshold;
    return json;
  }
}
