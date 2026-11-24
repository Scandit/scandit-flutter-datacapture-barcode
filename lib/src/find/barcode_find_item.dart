/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// An object that represents an item in Barcode Find.
///
/// Added in version 6.22.0
@immutable
class BarcodeFindItem implements Serializable {
  final BarcodeFindItemSearchOptions _searchOptions;
  final BarcodeFindItemContent? _content;

  /// Added in version 6.22.0
  const BarcodeFindItem(this._searchOptions, this._content);

  /// The item data to search, and any other option that control the search.
  ///
  /// Added in version 6.22.0
  BarcodeFindItemSearchOptions get searchOptions => _searchOptions;

  /// Optional info about the item.
  ///
  /// Added in version 6.22.0
  BarcodeFindItemContent? get content => _content;

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{'searchOptions': searchOptions.toMap()};

    if (content != null) {
      json['content'] = content?.toMap();
    }

    return json;
  }
}

/// An object that defines the search options.
///
/// Added in version 6.22.0
@immutable
class BarcodeFindItemSearchOptions implements Serializable {
  final String _barcodeData;
  final Brush? _brush;

  /// Creates a new BarcodeFindItemSearchOptions object with the provided barcode data and a custom [Brush] to be applied to the shown dot.
  ///
  /// Added in version 8.5.0
  const BarcodeFindItemSearchOptions(this._barcodeData) : _brush = null;

  const BarcodeFindItemSearchOptions.withBrush(this._barcodeData, this._brush);

  /// The barcode data as a string.
  ///
  /// Added in version 6.22.0
  String get barcodeData => _barcodeData;

  /// The [Brush] to be applied to the dot shown over the barcode, when detected.
  ///
  /// Added in version 8.5.0
  Brush? get brush => _brush;

  @override
  Map<String, dynamic> toMap() {
    final json = <String, dynamic>{'barcodeData': barcodeData};
    if (_brush != null) {
      json['brush'] = _brush.toMap();
    }
    return json;
  }
}

/// An object that contains additional info about the product.
///
/// Added in version 6.22.0
@immutable
class BarcodeFindItemContent implements Serializable {
  final String? _info;
  final String? _additionalInfo;
  final Image? _image;

  /// Added in version 6.22.0
  const BarcodeFindItemContent(this._info, this._additionalInfo, this._image);

  /// Optional item name.
  ///
  /// Added in version 6.22.0
  String? get info => _info;

  /// Optional item details.
  ///
  /// Added in version 6.22.0
  String? get additionalInfo => _additionalInfo;

  /// Optional item image.
  ///
  /// Added in version 6.22.0
  Image? get image => _image;

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{};

    if (info != null) {
      json['info'] = info;
    }

    if (additionalInfo != null) {
      json['additionalInfo'] = additionalInfo;
    }

    if (image != null) {
      json['image'] = image?.base64String;
    }

    return json;
  }
}
