/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';

import 'barcode_check_defaults.dart';

class BarcodeCheckInfoAnnotationFooter extends Serializable with ChangeNotifier {
  String? _text = BarcodeCheckDefaults.view.defaultInfoAnnotationFooterText;
  String? get text => _text;
  set text(String? newValue) {
    _text = newValue;
    notifyListeners();
  }

  ScanditIcon? _icon = BarcodeCheckDefaults.view.defaultInfoAnnotationFooterIcon;
  ScanditIcon? get icon => _icon;
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    notifyListeners();
  }

  Color? _backgroundColor = BarcodeCheckDefaults.view.defaultInfoAnnotationFooterBackgroundColor;
  Color? get backgroundColor => _backgroundColor;
  set backgroundColor(Color? newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }

  Color? _textColor = BarcodeCheckDefaults.view.defaultInfoAnnotationFooterTextColor;
  Color? get textColor => _textColor;
  set textColor(Color? newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeCheckDefaults.view.defaultInfoAnnotationFooterTextSize;
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

  BarcodeCheckInfoAnnotationFooter();

  @override
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'icon': jsonEncodeOrNull(icon),
      'backgroundColor': backgroundColor?.jsonValue,
      'textColor': textColor?.jsonValue,
      'textSize': textSize,
      'fontFamily': fontFamily.toString()
    };
  }
}
