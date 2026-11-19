/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_status_item.dart';

abstract class BarcodeCountStatusResult extends Serializable {}

class BarcodeCountStatusResultSuccess implements BarcodeCountStatusResult {
  final List<BarcodeCountStatusItem> _statusList;
  final String _statusModeEnabledMessage;
  final String _statusModeDisabledMessage;

  BarcodeCountStatusResultSuccess._(this._statusList, this._statusModeEnabledMessage, this._statusModeDisabledMessage);

  static BarcodeCountStatusResult create(
      List<BarcodeCountStatusItem> statusList, String statusModeEnabledMessage, String statusModeDisabledMessage) {
    return BarcodeCountStatusResultSuccess._(statusList, statusModeEnabledMessage, statusModeDisabledMessage);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeCountStatusResultSuccess',
      'statusList': _statusList.map((e) => e.toMap()).toList(),
      'statusModeEnabledMessage': _statusModeEnabledMessage,
      'statusModeDisabledMessage': _statusModeDisabledMessage,
    };
  }
}

class BarcodeCountStatusResultError implements BarcodeCountStatusResult {
  final List<BarcodeCountStatusItem> _statusList;
  final String _errorMessage;
  final String _statusModeDisabledMessage;

  BarcodeCountStatusResultError._(this._statusList, this._errorMessage, this._statusModeDisabledMessage);

  static BarcodeCountStatusResult create(
      List<BarcodeCountStatusItem> statusList, String errorMessage, String statusModeDisabledMessage) {
    return BarcodeCountStatusResultError._(statusList, errorMessage, statusModeDisabledMessage);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeCountStatusResultError',
      'statusList': _statusList.map((e) => e.toMap()).toList(),
      'errorMessage': _errorMessage,
      'statusModeDisabledMessage': _statusModeDisabledMessage,
    };
  }
}

class BarcodeCountStatusResultAbort implements BarcodeCountStatusResult {
  final String _errorMessage;

  BarcodeCountStatusResultAbort._(this._errorMessage);

  static BarcodeCountStatusResult create(String errorMessage) {
    return BarcodeCountStatusResultAbort._(errorMessage);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'barcodeCountStatusResultAbort',
      'errorMessage': _errorMessage,
    };
  }
}
