/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

@immutable
class BarcodeFindItem implements Serializable {
  final BarcodeFindItemSearchOptions _searchOptions;
  final BarcodeFindItemContent? _content;

  const BarcodeFindItem(this._searchOptions, this._content);

  BarcodeFindItemSearchOptions get searchOptions => _searchOptions;

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

@immutable
class BarcodeFindItemSearchOptions implements Serializable {
  final String _barcodeData;

  const BarcodeFindItemSearchOptions(this._barcodeData);

  String get barcodeData => _barcodeData;

  @override
  Map<String, dynamic> toMap() {
    return {'barcodeData': barcodeData};
  }
}

@immutable
class BarcodeFindItemContent implements Serializable {
  final String? _info;
  final String? _additionalInfo;
  final Image? _image;

  const BarcodeFindItemContent(this._info, this._additionalInfo, this._image);

  String? get info => _info;

  String? get additionalInfo => _additionalInfo;

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
