/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_ar_defaults.dart';

/// The header of an info annotation ([BarcodeArInfoAnnotation]).
///
/// Added in version 7.1.0
class BarcodeArInfoAnnotationHeader extends Serializable with ChangeNotifier {
  String? _text = BarcodeArDefaults.view.defaultInfoAnnotationHeaderText;
  /// The text. Default is *null*.
  ///
  /// Added in version 7.1.0
  String? get text => _text;
  /// The text. Default is *null*.
  ///
  /// Added in version 7.1.0
  set text(String? newValue) {
    _text = newValue;
    notifyListeners();
  }

  ScanditIcon? _icon = BarcodeArDefaults.view.defaultInfoAnnotationHeaderIcon;
  /// The icon. Default is *null*.
  ///
  /// Added in version 7.1.0
  ScanditIcon? get icon => _icon;
  /// The icon. Default is *null*.
  ///
  /// Added in version 7.1.0
  set icon(ScanditIcon? newValue) {
    _icon = newValue;
    notifyListeners();
  }

  Color? _backgroundColor = BarcodeArDefaults.view.defaultInfoAnnotationHeaderBackgroundColor;
  /// The background color. Default is #00FFFF.
  ///
  /// Added in version 7.1.0
  Color? get backgroundColor => _backgroundColor;
  /// The background color. Default is #00FFFF.
  ///
  /// Added in version 7.1.0
  set backgroundColor(Color? newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }

  Color? _textColor = BarcodeArDefaults.view.defaultInfoAnnotationHeaderTextColor;
  /// The color of the text. Default is #000000.
  ///
  /// Added in version 7.1.0
  Color? get textColor => _textColor;
  /// The color of the text. Default is #000000.
  ///
  /// Added in version 7.1.0
  set textColor(Color? newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeArDefaults.view.defaultInfoAnnotationHeaderTextSize;
  /// The size of the text. Default is 16 scale-independent pixels.
  ///
  /// Added in version 7.1.0
  double get textSize => _textSize;
  /// The size of the text. Default is 16 scale-independent pixels.
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

  /// Constructs a new instance of the info annotation header.
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationHeader();

  @override
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'icon': icon?.toMap(),
      'backgroundColor': backgroundColor?.jsonValue,
      'textColor': textColor?.jsonValue,
      'textSize': textSize,
      'fontFamily': fontFamily.toString()
    };
  }
}
