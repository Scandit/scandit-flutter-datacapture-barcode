/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';

/// Listener interface for BarcodeFind.
///
/// Added in version 6.22.0
abstract class BarcodeFindListener {
  /// Invoked whenever the search process has been started.
  ///
  /// This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first.
  ///
  /// Added in version 6.22.0
  void didStartSearch();
  /// Invoked whenever the search process has been paused. The foundItems parameter contains all the items found on the last processed camera frame.
  ///
  /// This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first.
  ///
  /// Added in version 6.22.0
  void didPauseSearch(Set<BarcodeFindItem> foundItems);
  /// Invoked whenever the search process has been stopped. The foundItems parameter contains all the items found since the start of the process.
  ///
  /// This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first.
  ///
  /// Added in version 6.22.0
  void didStopSearch(Set<BarcodeFindItem> foundItems);
}
