/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/ar/barcode_ar_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// A component that forms the body of an info annotation ([BarcodeArInfoAnnotation]). Each component represents a “row,” containing text with optional icons on the left and/or right sides.
///
/// Added in version 7.1.0
class BarcodeArInfoAnnotationBodyComponent with ChangeNotifier implements Serializable {
  /// Constructs a new instance of the body component.
  ///
  /// Added in version 8.6.0
  BarcodeArInfoAnnotationBodyComponent();

  String? _text;
  /// The text shown in the component.
  ///
  /// Added in version 7.1.0
  String? get text => _text;
  /// The text shown in the component.
  ///
  /// Added in version 7.1.0
  set text(String? newValue) {
    _text = newValue;
    notifyListeners();
  }

  Color _textColor = BarcodeArDefaults.view.defaultInfoAnnotationBodyElementTextColor;
  /// The color of the text. The default value is #121619.
  ///
  /// Added in version 7.1.0
  Color get textColor => _textColor;
  /// The color of the text. The default value is #121619.
  ///
  /// Added in version 7.1.0
  set textColor(Color newValue) {
    _textColor = newValue;
    notifyListeners();
  }

  TextAlignment _textAlign = TextAlignment.center;
  /// The text alignment. The default value is center.
  ///
  /// Added in version 7.1.0
  TextAlignment get textAlign => _textAlign;
  /// The text alignment. The default value is center.
  ///
  /// Added in version 7.1.0
  set textAlign(TextAlignment newValue) {
    _textAlign = newValue;
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

  double _textSize = BarcodeArDefaults.view.defaultInfoAnnotationBodyElementTextSize;
  /// The size of the text. Default is 14 scale-independent pixels.
  ///
  /// Added in version 7.1.0
  double get textSize => _textSize;
  /// The size of the text. Default is 14 scale-independent pixels.
  ///
  /// Added in version 7.1.0
  set textSize(double newValue) {
    _textSize = newValue;
    notifyListeners();
  }

  bool _isLeftIconTappable = BarcodeArDefaults.view.defaultInfoAnnotationBodyElementLeftIconTappable;
  /// Whether the left icon is tappable. Default is *true*.
  ///
  /// Added in version 7.1.0
  bool get isLeftIconTappable => _isLeftIconTappable;
  /// Whether the left icon is tappable. Default is *true*.
  ///
  /// Added in version 7.1.0
  set isLeftIconTappable(bool newValue) {
    _isLeftIconTappable = newValue;
    notifyListeners();
  }

  ScanditIcon? _leftIcon = BarcodeArDefaults.view.defaultInfoAnnotationBodyElementLeftIcon;
  /// The icon displayed on the left side of the component. If *null*, no button is shown. The default value is *null*.
  ///
  /// Added in version 7.1.0
  ScanditIcon? get leftIcon => _leftIcon;
  /// The icon displayed on the left side of the component. If *null*, no button is shown. The default value is *null*.
  ///
  /// Added in version 7.1.0
  set leftIcon(ScanditIcon? newValue) {
    _leftIcon = newValue;
    notifyListeners();
  }

  bool _isRightIconTappable = BarcodeArDefaults.view.defaultInfoAnnotationBodyElementRightIconTappable;
  /// Whether the right icon is tappable. Default is *true*.
  ///
  /// Added in version 7.1.0
  bool get isRightIconTappable => _isRightIconTappable;
  /// Whether the right icon is tappable. Default is *true*.
  ///
  /// Added in version 7.1.0
  set isRightIconTappable(bool newValue) {
    _isRightIconTappable = newValue;
    notifyListeners();
  }

  ScanditIcon? _rightIcon = BarcodeArDefaults.view.defaultInfoAnnotationBodyElementRightIcon;
  /// The icon displayed on the right side of the component. If *null*, no button is shown. The default value is *null*.
  ///
  /// Added in version 7.1.0
  ScanditIcon? get rightIcon => _rightIcon;
  /// The icon displayed on the right side of the component. If *null*, no button is shown. The default value is *null*.
  ///
  /// Added in version 7.1.0
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
      'leftIcon': leftIcon?.toMap(),
      'isRightIconTappable': isRightIconTappable,
      'rightIcon': rightIcon?.toMap(),
      'textSize': textSize,
    };
  }
}
