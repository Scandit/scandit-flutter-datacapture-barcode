/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/pick/ui/barcode_pick_status_icon_style.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodePickViewHighlightStyleResponse implements Serializable {
  final Brush? _brush;
  final Brush? _selectedBrush;
  final String? _iconBase64;
  final ScanditIcon? _iconScandit;
  final String? _selectedIconBase64;
  final ScanditIcon? _selectedIconScandit;
  final BarcodePickStatusIconStyle? _statusIconStyle;

  BarcodePickViewHighlightStyleResponse._({
    Brush? brush,
    Brush? selectedBrush,
    String? iconBase64,
    ScanditIcon? iconScandit,
    String? selectedIconBase64,
    ScanditIcon? selectedIconScandit,
    BarcodePickStatusIconStyle? statusIconStyle,
  })  : _brush = brush,
        _selectedBrush = selectedBrush,
        _iconBase64 = iconBase64,
        _iconScandit = iconScandit,
        _selectedIconBase64 = selectedIconBase64,
        _selectedIconScandit = selectedIconScandit,
        _statusIconStyle = statusIconStyle;

  static Future<BarcodePickViewHighlightStyleResponse> withBrushAndIcon(
    Brush? brush,
    Image? icon,
    BarcodePickStatusIconStyle? statusIconStyle,
  ) async {
    final iconBase64 = await icon?.base64String;
    return BarcodePickViewHighlightStyleResponse._(
      brush: brush,
      iconBase64: iconBase64,
      statusIconStyle: statusIconStyle,
    );
  }

  static Future<BarcodePickViewHighlightStyleResponse> withBrushAndScanditIcon(
    Brush? brush,
    ScanditIcon icon,
    BarcodePickStatusIconStyle? statusIconStyle,
  ) async {
    return BarcodePickViewHighlightStyleResponse._(brush: brush, iconScandit: icon, statusIconStyle: statusIconStyle);
  }

  static Future<BarcodePickViewHighlightStyleResponse> withSelectedBrushAndIcon(
    Brush? brush,
    Brush? selectedBrush,
    Image? icon,
    Image? selectedIcon,
    BarcodePickStatusIconStyle? statusIconStyle,
  ) async {
    final iconBase64 = await icon?.base64String;
    final selectedIconBase64 = await selectedIcon?.base64String;

    return BarcodePickViewHighlightStyleResponse._(
      brush: brush,
      selectedBrush: selectedBrush,
      iconBase64: iconBase64,
      selectedIconBase64: selectedIconBase64,
      statusIconStyle: statusIconStyle,
    );
  }

  static Future<BarcodePickViewHighlightStyleResponse> withSelectedBrushAndScanditIcon(
    Brush? brush,
    Brush? selectedBrush,
    ScanditIcon icon,
    ScanditIcon? selectedIcon,
    BarcodePickStatusIconStyle? statusIconStyle,
  ) async {
    return BarcodePickViewHighlightStyleResponse._(
      brush: brush,
      selectedBrush: selectedBrush,
      iconScandit: icon,
      selectedIconScandit: selectedIcon,
      statusIconStyle: statusIconStyle,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> json = {
      'brush': _brush?.toMap(),
      'selectedBrush': _selectedBrush?.toMap(),
      'statusIconStyle': _statusIconStyle?.toMap(),
    };

    if (_iconBase64 != null) {
      json['icon'] = _iconBase64;
    }

    if (_selectedIconBase64 != null) {
      json['selectedIcon'] = _selectedIconBase64;
    }

    if (_iconScandit != null) {
      json['icon'] = _iconScandit?.toMap();
    }

    if (_selectedIconScandit != null) {
      json['selectedIcon'] = _selectedIconScandit?.toMap();
    }

    json.removeWhere((key, value) => value == null);
    return json;
  }

  static BarcodePickViewHighlightStyleResponseBuilder builder() {
    return BarcodePickViewHighlightStyleResponseBuilder();
  }
}

enum _IconType { none, image, asset, scandit }

class BarcodePickViewHighlightStyleResponseBuilder {
  Brush? _brush;
  Brush? _selectedBrush;
  Image? _iconImage;
  Image? _selectedIconImage;
  String? _iconAsset;
  String? _selectedIconAsset;
  ScanditIcon? _iconScandit;
  ScanditIcon? _selectedIconScandit;
  BarcodePickStatusIconStyle? _statusIconStyle;
  _IconType _iconType = _IconType.none;
  _IconType _selectedIconType = _IconType.none;

  BarcodePickViewHighlightStyleResponseBuilder();

  BarcodePickViewHighlightStyleResponseBuilder setBrush(Brush? brush) {
    _brush = brush;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setSelectedBrush(Brush? selectedBrush) {
    _selectedBrush = selectedBrush;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setIcon(Image? icon) {
    _iconImage = icon;
    _iconType = _IconType.image;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setSelectedIcon(Image? selectedIcon) {
    _selectedIconImage = selectedIcon;
    _selectedIconType = _IconType.image;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setIconFromAsset(String assetName) {
    _iconAsset = assetName;
    _iconType = _IconType.asset;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setSelectedIconFromAsset(String selectedAssetName) {
    _selectedIconAsset = selectedAssetName;
    _selectedIconType = _IconType.asset;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setIconFromScanditIcon(ScanditIcon icon) {
    _iconScandit = icon;
    _iconType = _IconType.scandit;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setSelectedIconFromScanditIcon(ScanditIcon? selectedIcon) {
    _selectedIconScandit = selectedIcon;
    _selectedIconType = _IconType.scandit;
    return this;
  }

  BarcodePickViewHighlightStyleResponseBuilder setStatusIconStyle(BarcodePickStatusIconStyle? statusIconStyle) {
    _statusIconStyle = statusIconStyle;
    return this;
  }

  Future<BarcodePickViewHighlightStyleResponse> build() async {
    String? iconBase64;
    String? selectedIconBase64;
    ScanditIcon? iconScandit;
    ScanditIcon? selectedIconScandit;

    switch (_iconType) {
      case _IconType.image:
        iconBase64 = await _iconImage?.base64String;
        break;
      case _IconType.asset:
        if (_iconAsset != null) {
          final ByteData data = await rootBundle.load(_iconAsset!);
          final Uint8List bytes = data.buffer.asUint8List();
          iconBase64 = base64Encode(bytes);
        }
        break;
      case _IconType.scandit:
        iconScandit = _iconScandit;
        break;
      case _IconType.none:
        break;
    }

    switch (_selectedIconType) {
      case _IconType.image:
        selectedIconBase64 = await _selectedIconImage?.base64String;
        break;
      case _IconType.asset:
        if (_selectedIconAsset != null) {
          final ByteData data = await rootBundle.load(_selectedIconAsset!);
          final Uint8List bytes = data.buffer.asUint8List();
          selectedIconBase64 = base64Encode(bytes);
        }
        break;
      case _IconType.scandit:
        selectedIconScandit = _selectedIconScandit;
        break;
      case _IconType.none:
        break;
    }

    return BarcodePickViewHighlightStyleResponse._(
      brush: _brush,
      selectedBrush: _selectedBrush,
      iconBase64: iconBase64,
      iconScandit: iconScandit,
      selectedIconBase64: selectedIconBase64,
      selectedIconScandit: selectedIconScandit,
      statusIconStyle: _statusIconStyle,
    );
  }
}
