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

import 'barcode_ar_defaults.dart';

class BarcodeArInfoAnnotationFooter extends Serializable with ChangeNotifier {
  String? _text = BarcodeArDefaults.view.defaultInfoAnnotationFooterText;
  String? get text => _text;
  set text(String? newValue) {
    _text = newValue;
    notifyListeners();
  }

  ScanditIcon? _icon = BarcodeArDefaults.view.defaultInfoAnnotationFooterIcon;
  ScanditIcon? get icon => _icon;
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    notifyListeners();
  }

  Color? _backgroundColor = BarcodeArDefaults.view.defaultInfoAnnotationFooterBackgroundColor;
  Color? get backgroundColor => _backgroundColor;
  set backgroundColor(Color? newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }

  Color? _textColor = BarcodeArDefaults.view.defaultInfoAnnotationFooterTextColor;
  Color? get textColor => _textColor;
  set textColor(Color? newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeArDefaults.view.defaultInfoAnnotationFooterTextSize;
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

  BarcodeArInfoAnnotationFooter();

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
