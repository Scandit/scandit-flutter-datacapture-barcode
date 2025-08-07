/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/check/barcode_check_info_annotation_footer.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode.dart';
import 'barcode_check_annotation_trigger.dart';
import 'barcode_check_common.dart';
import 'barcode_check_defaults.dart';
import 'barcode_check_info_annotation_anchor.dart';
import 'barcode_check_info_annotation_body_component.dart';

import 'barcode_check_info_annotation_header.dart';
import 'barcode_check_info_annotation_width_preset.dart';

abstract class BarcodeCheckInfoAnnotationListener {
  void didTapInfoAnnotationHeader(BarcodeCheckInfoAnnotation annotation);
  void didTapInfoAnnotationFooter(BarcodeCheckInfoAnnotation annotation);
  void didTapInfoAnnotationLeftIcon(BarcodeCheckInfoAnnotation annotation, int componentIndex);
  void didTapInfoAnnotationRightIcon(BarcodeCheckInfoAnnotation annotation, int componentIndex);
  void didTapInfoAnnotation(BarcodeCheckInfoAnnotation annotation);
}

abstract class BarcodeCheckPopoverAnnotationListener {
  void didTapPopoverButton(
      BarcodeCheckPopoverAnnotation popover, BarcodeCheckPopoverAnnotationButton button, int buttonIndex);

  void didTapPopover(BarcodeCheckPopoverAnnotation popover);
}

abstract class BarcodeCheckAnnotation extends Serializable with PrivateBarcodeCheckAnnotation {
  final String _type;

  BarcodeCheckAnnotationTrigger _annotationTrigger;

  BarcodeCheckAnnotation._(this._annotationTrigger, this._type);

  BarcodeCheckAnnotationTrigger get annotationTrigger => _annotationTrigger;

  set annotationTrigger(BarcodeCheckAnnotationTrigger value) {
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

mixin PrivateBarcodeCheckAnnotation {
  String barcodeId = '';
  BarcodeCheckViewController? controller; // will be set externally
}

class BarcodeCheckInfoAnnotation extends BarcodeCheckAnnotation {
  final Barcode _barcode;

  BarcodeCheckInfoAnnotation(this._barcode)
      : super._(BarcodeCheckDefaults.view.defaultInfoAnnotationTrigger, 'barcodeCheckInfoAnnotation');

  bool _hasTip = BarcodeCheckDefaults.view.defaultInfoAnnotationHasTip;
  bool get hasTip => _hasTip;
  set hasTip(bool newValue) {
    _hasTip = newValue;
    controller?.updateAnnotation(this);
  }

  bool _isEntireAnnotationTappable = BarcodeCheckDefaults.view.defaultInfoAnnotationEntireAnnotationTappable;
  bool get isEntireAnnotationTappable => _isEntireAnnotationTappable;
  set isEntireAnnotationTappable(bool newValue) {
    _isEntireAnnotationTappable = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeCheckInfoAnnotationAnchor _anchor = BarcodeCheckDefaults.view.defaultInfoAnnotationAnchor;
  BarcodeCheckInfoAnnotationAnchor get anchor => _anchor;
  set anchor(BarcodeCheckInfoAnnotationAnchor newValue) {
    _anchor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeCheckInfoAnnotationWidthPreset _width = BarcodeCheckDefaults.view.defaultInfoAnnotationWidth;
  BarcodeCheckInfoAnnotationWidthPreset get width => _width;
  set width(BarcodeCheckInfoAnnotationWidthPreset newValue) {
    _width = newValue;
    controller?.updateAnnotation(this);
  }

  List<BarcodeCheckInfoAnnotationBodyComponent> _body = [];
  List<BarcodeCheckInfoAnnotationBodyComponent> get body => _body;
  set body(List<BarcodeCheckInfoAnnotationBodyComponent> newValue) {
    _body = List.unmodifiable(newValue);
    for (var component in _body) {
      component.addListener(_onBodyChange);
    }
    controller?.updateAnnotation(this);
  }

  void _onBodyChange() {
    controller?.updateAnnotation(this);
  }

  BarcodeCheckInfoAnnotationHeader? _header;
  BarcodeCheckInfoAnnotationHeader? get header => _header;
  set header(BarcodeCheckInfoAnnotationHeader? newValue) {
    _header?.removeListener(_onHeaderFooterChange);
    _header = newValue;
    _header?.addListener(_onHeaderFooterChange);
    controller?.updateAnnotation(this);
  }

  BarcodeCheckInfoAnnotationFooter? _footer;
  BarcodeCheckInfoAnnotationFooter? get footer => _footer;
  set footer(BarcodeCheckInfoAnnotationFooter? newValue) {
    _footer?.removeListener(_onHeaderFooterChange);
    _footer = newValue;
    _footer?.addListener(_onHeaderFooterChange);
    controller?.updateAnnotation(this);
  }

  void _onHeaderFooterChange() {
    controller?.updateAnnotation(this);
  }

  Color _backgroundColor = BarcodeCheckDefaults.view.defaultInfoAnnotationBackgroundColor;
  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    controller?.updateAnnotation(this);
  }

  BarcodeCheckInfoAnnotationListener? _listener;
  BarcodeCheckInfoAnnotationListener? get listener => _listener;
  set listener(BarcodeCheckInfoAnnotationListener? newValue) {
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

class BarcodeCheckPopoverAnnotationButton with ChangeNotifier implements Serializable {
  final ScanditIcon _icon;
  final String _text;
  int _index = -1;

  BarcodeCheckPopoverAnnotationButton(this._icon, this._text);

  Color _textColor = BarcodeCheckDefaults.view.defaultBarcodeCheckPopoverAnnotationButtonTextColor;
  Color get textColor => _textColor;
  set textColor(Color newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeCheckDefaults.view.defaultBarcodeCheckPopoverAnnotationButtonTextSize;
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

  bool _enabled = BarcodeCheckDefaults.view.defaultBarcodeCheckPopoverAnnotationButtonEnabled;
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

class BarcodeCheckPopoverAnnotation extends BarcodeCheckAnnotation {
  final Barcode _barcode;

  late List<BarcodeCheckPopoverAnnotationButton> _buttons;

  BarcodeCheckPopoverAnnotation(this._barcode, List<BarcodeCheckPopoverAnnotationButton> buttons)
      : super._(BarcodeCheckDefaults.view.defaultPopoverAnnotationTrigger, 'barcodeCheckPopoverAnnotation') {
    _buttons = List.unmodifiable(buttons);
    for (var i = 0; i < _buttons.length; i++) {
      var button = _buttons[i];
      button._index = i;
      button.addListener(() => _buttonChanged(i));
    }
  }

  void _buttonChanged(int buttonIndex) {
    controller?.updateBarcodeCheckPopoverButtonAtIndex(this, buttonIndex);
  }

  bool isEntirePopoverTappable = BarcodeCheckDefaults.view.defaultIsEntirePopoverTappable;

  BarcodeCheckPopoverAnnotationListener? _listener;
  BarcodeCheckPopoverAnnotationListener? get listener => _listener;
  set listener(BarcodeCheckPopoverAnnotationListener? newValue) {
    _listener = newValue;
    controller?.updateAnnotation(this);
  }

  List<BarcodeCheckPopoverAnnotationButton> get buttons => _buttons;

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

class BarcodeCheckStatusIconAnnotation extends BarcodeCheckAnnotation {
  final Barcode _barcode;

  BarcodeCheckStatusIconAnnotation(this._barcode)
      : super._(BarcodeCheckDefaults.view.defaultStatusIconAnnotationTrigger, 'barcodeCheckStatusIconAnnotation');

  bool _hasTip = BarcodeCheckDefaults.view.defaultStatusIconAnnotationHasTip;
  bool get hasTip => _hasTip;
  set hasTip(bool newValue) {
    _hasTip = newValue;
    controller?.updateAnnotation(this);
  }

  ScanditIcon _icon = BarcodeCheckDefaults.view.defaultStatusIconAnnotationIcon;
  ScanditIcon get icon => _icon;
  set icon(ScanditIcon newValue) {
    _icon = newValue;
    controller?.updateAnnotation(this);
  }

  String? _text = BarcodeCheckDefaults.view.defaultStatusIconAnnotationText;
  String? get text => _text;
  set text(String? newValue) {
    _text = newValue;
    controller?.updateAnnotation(this);
  }

  Color _textColor = BarcodeCheckDefaults.view.defaultStatusIconAnnotationTextColor;
  Color get textColor => _textColor;
  set textColor(Color newValue) {
    _textColor = newValue;
    controller?.updateAnnotation(this);
  }

  Color _backgroundColor = BarcodeCheckDefaults.view.defaultStatusIconAnnotationBackgroundColor;
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
