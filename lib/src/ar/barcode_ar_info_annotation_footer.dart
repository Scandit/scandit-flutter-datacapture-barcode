/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_ar_defaults.dart';

/// The footer of an info annotation ([BarcodeArInfoAnnotation]).
///
/// Added in version 7.1.0
class BarcodeArInfoAnnotationFooter extends Serializable with ChangeNotifier {
  String? _text = BarcodeArDefaults.view.defaultInfoAnnotationFooterText;
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

  ScanditIcon? _icon = BarcodeArDefaults.view.defaultInfoAnnotationFooterIcon;
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

  Color? _backgroundColor = BarcodeArDefaults.view.defaultInfoAnnotationFooterBackgroundColor;
  /// The background color. Default is #000000.
  ///
  /// Added in version 7.1.0
  Color? get backgroundColor => _backgroundColor;
  /// The background color. Default is #000000.
  ///
  /// Added in version 7.1.0
  set backgroundColor(Color? newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }

  Color? _textColor = BarcodeArDefaults.view.defaultInfoAnnotationFooterTextColor;
  /// The color of the text. Default is #FFFFFF.
  ///
  /// Added in version 7.1.0
  Color? get textColor => _textColor;
  /// The color of the text. Default is #FFFFFF.
  ///
  /// Added in version 7.1.0
  set textColor(Color? newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  double _textSize = BarcodeArDefaults.view.defaultInfoAnnotationFooterTextSize;
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

  /// Constructs a new instance of the info annotation footer.
  ///
  /// Added in version 7.1.0
  BarcodeArInfoAnnotationFooter();

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
