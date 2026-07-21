/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../barcode_count_status_result.dart';

class BarcodeCountStatusProviderResult implements Serializable {
  final BarcodeCountStatusResult _result;
  final String _requestId;

  BarcodeCountStatusProviderResult._(this._requestId, this._result);

  factory BarcodeCountStatusProviderResult.create(
    String requestId,
    BarcodeCountStatusResult result,
  ) {
    return BarcodeCountStatusProviderResult._(requestId, result);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'requestId': _requestId}..addAll(_result.toMap());
  }
}
