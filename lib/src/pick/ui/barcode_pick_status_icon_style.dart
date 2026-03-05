/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodePickStatusIconStyle extends Serializable {
  BarcodePickStatusIconStyle._();

  factory BarcodePickStatusIconStyle.withIcon(String iconBase64, String text) {
    return _BarcodePickStatusIconStyleWithIcon(iconBase64: iconBase64, text: text);
  }

  factory BarcodePickStatusIconStyle.withScanditIcon(ScanditIcon icon, String text) {
    return _BarcodePickStatusIconStyleWithScanditIcon(icon: icon, text: text);
  }

  factory BarcodePickStatusIconStyle.withColors(Color iconColor, Color iconBackgroundColor, String text) {
    return _BarcodePickStatusIconStyleWithColors(
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      text: text,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

/// Style with a custom bitmap icon
class _BarcodePickStatusIconStyleWithIcon extends BarcodePickStatusIconStyle {
  final String iconBase64;
  final String text;

  _BarcodePickStatusIconStyleWithIcon({required this.iconBase64, required this.text}) : super._();

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'icon',
      'text': text,
      'icon': iconBase64,
    };
  }
}

/// Style with a ScanditIcon
class _BarcodePickStatusIconStyleWithScanditIcon extends BarcodePickStatusIconStyle {
  final ScanditIcon icon;
  final String text;

  _BarcodePickStatusIconStyleWithScanditIcon({required this.icon, required this.text}) : super._();

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'icon',
      'text': text,
      'icon': jsonEncode(icon.toMap()),
    };
  }
}

/// Style with colors for the default icon
class _BarcodePickStatusIconStyleWithColors extends BarcodePickStatusIconStyle {
  final Color iconColor;
  final Color iconBackgroundColor;
  final String text;

  _BarcodePickStatusIconStyleWithColors({
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.text,
  }) : super._();

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'colors',
      'text': text,
      'iconColor': iconColor.jsonValue,
      'iconBackgroundColor': iconBackgroundColor.jsonValue,
    };
  }
}
