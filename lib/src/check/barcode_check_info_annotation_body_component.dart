/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/check/barcode_check_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeCheckInfoAnnotationBodyComponent with ChangeNotifier implements Serializable {
  String? _text;
  String? get text => _text;
  set text(String? newValue) {
    _text = newValue;
    notifyListeners();
  }

  Color _textColor = BarcodeCheckDefaults.view.defaultInfoAnnotationBodyElementTextColor;
  Color get textColor => _textColor;
  set textColor(Color newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  TextAlignment _textAlign = TextAlignment.center;
  TextAlignment get textAlign => _textAlign;
  set textAlign(TextAlignment newValue) {
    _textAlign = newValue;
    notifyListeners();
  }

  FontFamily _fontFamily = FontFamily.systemDefault;
  FontFamily get fontFamily => _fontFamily;
  set fontFamily(FontFamily newValue) {
    _fontFamily = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeCheckDefaults.view.defaultInfoAnnotationBodyElementTextSize;
  double get textSize => _textSize;
  set textSize(double newValue) {
    _textSize = newValue;
    notifyListeners();
  }

  bool _isLeftIconTappable = BarcodeCheckDefaults.view.defaultInfoAnnotationBodyElementLeftIconTappable;
  bool get isLeftIconTappable => _isLeftIconTappable;
  set isLeftIconTappable(bool newValue) {
    _isLeftIconTappable = newValue;
    notifyListeners();
  }

  ScanditIcon? _leftIcon = BarcodeCheckDefaults.view.defaultInfoAnnotationBodyElementLeftIcon;
  ScanditIcon? get leftIcon => _leftIcon;
  set leftIcon(ScanditIcon? newValue) {
    _leftIcon = newValue;
    notifyListeners();
  }

  bool _isRightIconTappable = BarcodeCheckDefaults.view.defaultInfoAnnotationBodyElementRightIconTappable;
  bool get isRightIconTappable => _isRightIconTappable;
  set isRightIconTappable(bool newValue) {
    _isRightIconTappable = newValue;
    notifyListeners();
  }

  ScanditIcon? _rightIcon = BarcodeCheckDefaults.view.defaultInfoAnnotationBodyElementRightIcon;
  ScanditIcon? get rightIcon => _rightIcon;
  set rightIcon(ScanditIcon? newValue) {
    _rightIcon = newValue;
    notifyListeners();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'textColor': textColor.jsonValue,
      'textAlign': textAlign.toString(),
      'fontFamily': fontFamily.toString(),
      'isLeftIconTappable': isLeftIconTappable,
      'leftIcon': (leftIcon != null ? jsonEncode(leftIcon!.toMap()) : null),
      'isRightIconTappable': isRightIconTappable,
      'rightIcon': (rightIcon != null ? jsonEncode(rightIcon!.toMap()) : null),
      'textSize': textSize,
    };
  }
}
