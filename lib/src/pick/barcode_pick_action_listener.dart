/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view.dart';

/// Will be notified when an action is performed by the user.
///
/// Added in version 6.22.0
abstract class BarcodePickActionListener {
  /// This method will be called when the user taps on a code that is not picked.
  ///
  /// Added in version 6.22.0
  void didPick(String itemData, BarcodePickActionCallback callback);
  /// This method will be called when the user taps on a code that is already picked.
  ///
  /// Added in version 6.22.0
  void didUnpick(String itemData, BarcodePickActionCallback callback);
}
