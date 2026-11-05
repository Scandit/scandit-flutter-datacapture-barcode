/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view.dart';

/// Added in version 6.22.0
abstract class BarcodePickViewUiListener {
  /// Callback method that can be used to define an action that should be performed when the finish button is tapped from the view. Called from the main thread.
  ///
  /// Added in version 6.22.0
  void didTapFinishButton(BarcodePickView view);
}
