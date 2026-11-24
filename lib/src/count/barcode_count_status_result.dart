/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_count_status_item.dart';

/// An interface representing an object used to provide a status list when calling [BarcodeCountStatusProviderCallback.onStatusReady]. Can be created using one of the creator methods [BarcodeCountStatusResultSuccess.create], [BarcodeCountStatusResultError.create] or [BarcodeCountStatusResultAbort.create].
///
/// Added in version 7.0.0
abstract class BarcodeCountStatusResult extends Serializable {}

/// Added in version 7.0.0
class BarcodeCountStatusResultSuccess implements BarcodeCountStatusResult {
  final List<BarcodeCountStatusItem> _statusList;
  final String _statusModeEnabledMessage;
  final String _statusModeDisabledMessage;

  BarcodeCountStatusResultSuccess._(this._statusList, this._statusModeEnabledMessage, this._statusModeDisabledMessage);

  /// Creator method that constructs a [BarcodeCountStatusResult] representing success when retrieving the status for the required barcodes. statusModeEnabledMessage will be presented to the user after successfully enabling status mode, and statusModeDisabledMessage will be displayed when exiting it.
  ///
  /// Added in version 7.0.0
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

/// Added in version 7.0.0
class BarcodeCountStatusResultError implements BarcodeCountStatusResult {
  final List<BarcodeCountStatusItem> _statusList;
  final String _errorMessage;
  final String _statusModeDisabledMessage;

  BarcodeCountStatusResultError._(this._statusList, this._errorMessage, this._statusModeDisabledMessage);

  /// Creator method that constructs a [BarcodeCountStatusResult] representing an error when retrieving the status for the required barcodes. errorMessage will be presented to the user after successfully enabling status mode, and statusModeDisabledMessage will be displayed when exiting it.
  ///
  /// Added in version 7.0.0
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

/// Added in version 7.0.0
class BarcodeCountStatusResultAbort implements BarcodeCountStatusResult {
  final String _errorMessage;

  BarcodeCountStatusResultAbort._(this._errorMessage);

  /// Creator method that constructs a [BarcodeCountStatusResult] representing a critical failure when retrieving the status for the required barcodes. Will abort the status mode immediately, displaying errorMessage to the user.
  ///
  /// Added in version 7.0.0
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
